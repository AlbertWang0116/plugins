#import "GREYJSONRpcClientImpl.h"

#import "GREYJSONObjectUtil.h"
#import <SocketRocket/SRWebSocket.h>

// TODO(b/135627523): clean up other EG2 files or remove this.
NS_ASSUME_NONNULL_BEGIN

@interface GREYJSONRpcClientImpl () <SRWebSocketDelegate>

@end

@implementation GREYJSONRpcClientImpl {
  /** The web socket client used by this class to connect to the server. */
  SRWebSocket *_webSocketClient;

  /** The serial dispatch queue used to send request content. */
  dispatch_queue_t _rpcRequestQueue;

  /**
   * The task group of ongoing connection and RPC requests that this client should wait for before
   * being closed.
   */
  dispatch_group_t _ongoingRequestsGroup;

  /**
   * The dictionary used to track the requests which haven't received response from server. The key
   * is the requestID field of incoming GREYJSONRpcRequest, which should be either NSNumber or
   * NSString (NSNull is a valid requestID but it is considered as notification instead of request).
   * The value is a FBLPromise instance which is going to be resolved when the client receives
   * response from JSON-RPC server.
   */
  NSMutableDictionary<id<NSCopying>, FBLPromise<GREYJSONRpcResponse *> *> *_ongoingRequests;

  /**
   * Indicates whether the client sends out the connection request to server. This variable cannot
   * be accessed outside of @synchronized(_webSocketClient).
   */
  BOOL _isOpened;

  /**
   * Indicates whether the client has stopped accepting requests and waiting for close. This
   * variable cannot be accessed outside of @synchronized(_webSocketClient).
   */
  BOOL _isClosed;
}

/** Fetches shared dispatch queue which is used to handle server side response data. */
+ (dispatch_queue_t)rpcResponseQueue {
  static dispatch_queue_t rpcResponseQueue;
  static dispatch_once_t once_token;
  dispatch_once(&once_token, ^{
    rpcResponseQueue = dispatch_queue_create("com.google.earlgrey.flutter.jsonrpc.response", NULL);
  });
  return rpcResponseQueue;
}

#pragma mark - public

- (instancetype)initWithURL:(NSURL *)URL {
  self = [super init];
  if (self) {
    _webSocketClient = [[SRWebSocket alloc] initWithURL:URL];
    _rpcRequestQueue = dispatch_queue_create("com.google.earlgrey.flutter.jsonrpc.request",
                                             DISPATCH_QUEUE_CONCURRENT);
    _ongoingRequests = [NSMutableDictionary dictionary];
    _ongoingRequestsGroup = dispatch_group_create();

    _webSocketClient.delegate = self;
    [_webSocketClient setDelegateDispatchQueue:[[self class] rpcResponseQueue]];
  }
  return self;
}

- (void)open {
  @synchronized(_webSocketClient) {
    // TODO(b/135293968): Throws an exception.
    NSAssert(!_isOpened, @"client cannot be opened twice!");
    // TODO(b/135293968): Throws an exception.
    NSAssert(!_isClosed, @"Cannot open a closed client!");
    _isOpened = YES;
    dispatch_suspend(_rpcRequestQueue);
    dispatch_group_enter(_ongoingRequestsGroup);
    [_webSocketClient open];
  }
}

- (nullable FBLPromise<GREYJSONRpcResponse *> *)sendRequest:(GREYJSONRpcRequest *)request {
  GREYValidateJSONRpcRequest(request);
  @synchronized(_webSocketClient) {
    // TODO(b/135293968): Throws an exception.
    NSAssert(_isOpened, @"Should always call open before sending requests.");
    if (_isClosed) {
      // TODO(b/135293968): Formalize the error.
      NSError *error = [NSError errorWithDomain:@"Sending request fail: JSON-RPC client is closed."
                                           code:-1
                                       userInfo:nil];
      return [FBLPromise resolvedWith:error];
    }
    FBLPromise<GREYJSONRpcResponse *> *promise;
    id<NSCopying> requestID = request.requestID;
    if (requestID) {
      promise = [FBLPromise pendingPromise];
      // TODO(b/135562951): pass this error to user through promise.
      NSAssert(!_ongoingRequests[requestID], @"request id %@ is sent and waiting for response",
               requestID);
      _ongoingRequests[requestID] = promise;
    }
    // Block uses weak reference to hold client instance to avoid retain cycle. Client won't be
    // released before block being executed if user call `close` to it.
    __weak GREYJSONRpcClientImpl *weakSelf = self;
    dispatch_async(_rpcRequestQueue, ^{
      GREYJSONRpcClientImpl *strongSelf = weakSelf;
      // TODO(b/135293968): Throws an exception.
      NSAssert(strongSelf, @"strongSelf should not be nil.");
      dispatch_group_enter(strongSelf->_ongoingRequestsGroup);
      NSError *error;
      NSDictionary<NSString *, id> *jsonObject = [request dictionaryValue];
      // TODO(b/135562951): pass this error to user through promise.
      NSAssert(jsonObject, @"request %@ failed to call `dictionaryValue`", request);
      NSData *contentData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
      // TODO(b/135562951): pass this error to user through promise.
      NSAssert(contentData, @"JSON serialization error: %@", error);
      NSString *content = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
      // TODO(b/135562951): pass this error to user through promise.
      NSAssert(content, @"Failed to transform JSON object to string, check JSON format:%@",
               jsonObject);
      [strongSelf->_webSocketClient send:content];
    });
    return promise;
  }
}

- (void)close {
  @synchronized(_webSocketClient) {
    _isClosed = YES;
  }
  dispatch_barrier_sync(_rpcRequestQueue, ^{
    dispatch_group_wait(_ongoingRequestsGroup, DISPATCH_TIME_FOREVER);
  });
  [_webSocketClient close];
}

- (FBLPromise<NSNull *> *)closeAsync {
  FBLPromise<NSNull *> *promise = [FBLPromise pendingPromise];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    [self close];
    [promise fulfill:[NSNull null]];
  });
  return promise;
}

- (void)dealloc {
  // TODO(b/135293968): Throws an exception.
  NSAssert(_isClosed, @"Should always call `close` before release a GREYJSONRpcClient.");
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
  dispatch_resume(_rpcRequestQueue);
  dispatch_group_leave(_ongoingRequestsGroup);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  // TODO(b/135562951): pass this error to user through promise.
  NSAssert([message isKindOfClass:[NSString class]],
           @"Fatal error: received an unexpected message: %@", message);
  NSError *error;
  NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
  // TODO(b/135562951): pass this error to user through promise.
  NSAssert(messageData, @"Failed to convert response string to NSData, check response string:%@",
           message);
  NSDictionary<NSString *, id> *messageJSON = [NSJSONSerialization JSONObjectWithData:messageData
                                                                              options:0
                                                                                error:&error];
  // TODO(b/135562951): pass this error to user through promise.
  NSAssert([messageJSON isKindOfClass:[NSDictionary class]],
           @"JSON RPC response failed to be parsed as NSDictionary, check response string:%@\nand "
           @"error:%@",
           message, error);
  GREYJSONRpcResponse *response = [[GREYJSONRpcResponse alloc] initWithDictionary:messageJSON];
  GREYValidateJSONRpcResponse(response);
  id<NSCopying> requestID = response.requestID;
  FBLPromise<GREYJSONRpcResponse *> *promise = _ongoingRequests[requestID];
  // TODO(b/135562951): pass this error to user through promise.
  NSAssert(promise, @"received a response which doesn't have corresponding request, detail:\n%@",
           message);
  [_ongoingRequests removeObjectForKey:requestID];
  [promise fulfill:response];
  dispatch_group_leave(_ongoingRequestsGroup);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
  // TODO(b/135562951): When this callback is reached, web socket will be closed. So this client
  //                    should clean up promises with the error.
  NSAssert(!error, @"Websocket request failed with error: %@", error.localizedDescription);
}

@end

NS_ASSUME_NONNULL_END
