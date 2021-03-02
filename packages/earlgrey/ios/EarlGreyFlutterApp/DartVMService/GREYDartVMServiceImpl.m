#import "GREYDartVMServiceImpl.h"

#import "GREYDartVMConnectionUtil.h"
#import "GREYDartVMServiceResponseParsingUtil.h"
#import "GREYJSONRpcClient.h"
#import "GREYJSONRpcRequest.h"
#import "GREYJSONRpcResponse.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kDartVMStatusMethod = @"getVM";
static NSString *const kDartIsolateStatusMethod = @"getIsolate";
static NSString *const kFlutterDriverExtensionMethod = @"ext.flutter.driver";

static NSString *const kCommandParam = @"command";
static NSString *const kIsolateIDParam = @"isolateId";
static NSString *const kTimeoutParam = @"timeout";

static const NSUInteger kGREYFlutterDriverExntensionRequestTimeout = 10000;

NSURL *GREYWebSocketURLFromURL(NSURL *url);

@implementation GREYDartVMServiceImpl {
  id<GREYJSONRpcClient> _client;
}

#pragma mark - public

- (instancetype)initWithJSONRpcClient:(id<GREYJSONRpcClient>)client {
  self = [super init];
  if (self) {
    _client = client;
  }
  return self;
}

- (void)dealloc {
  [_client closeAsync];
}

- (FBLPromise<GREYDartVMStatusResponse *> *)fetchDartVMStatus {
  GREYJSONRpcRequest *request = [[GREYJSONRpcRequest alloc] initWithRequestID:[self nextID]
                                                                   withMethod:kDartVMStatusMethod
                                                                   withParams:nil];
  return [[_client sendRequest:request] then:^id(GREYJSONRpcResponse *response) {
    return GREYParseDartVMStatusResponse(response);
  }];
}

- (FBLPromise<NSArray<GREYDartIsolateStatusResponse *> *> *)fetchDartIsolatesStatus {
  return [[self fetchDartVMStatus] then:^id(GREYDartVMStatusResponse *dartVMStatus) {
    NSArray<NSString *> *isolateIDs = dartVMStatus.isolateIDs;
    NSMutableArray<FBLPromise<GREYDartIsolateStatusResponse *> *> *promises =
        [NSMutableArray arrayWithCapacity:isolateIDs.count];
    for (NSString *isolateID in isolateIDs) {
      [promises addObject:[self fetchDartIsolateStatusWithIsolateID:isolateID]];
    }
    return [FBLPromise all:promises];
  }];
}

- (FBLPromise<GREYDartIsolateStatusResponse *> *)fetchDartIsolateStatusWithIsolateID:
    (NSString *)isolateID {
  GREYJSONRpcRequest *request =
      [[GREYJSONRpcRequest alloc] initWithRequestID:[self nextID]
                                         withMethod:kDartIsolateStatusMethod
                                         withParams:@{kIsolateIDParam : isolateID}];
  return [[_client sendRequest:request] then:^id(GREYJSONRpcResponse *response) {
    return GREYParseDartIsolateStatusResponse(response);
  }];
}

- (FBLPromise<GREYJSONValue> *)invokeFlutterDriverCommand:(NSString *)command
                                         onFlutterIsolate:(NSString *)isolateID
                                               withParams:(GREYJSONDictionary *)driverParams {
  NSMutableDictionary<NSString *, GREYJSONValue> *params =
      [NSMutableDictionary dictionaryWithDictionary:driverParams];
  params[kCommandParam] = command;
  params[kIsolateIDParam] = isolateID;
  params[kTimeoutParam] = @(kGREYFlutterDriverExntensionRequestTimeout);
  GREYJSONRpcRequest *request =
      [[GREYJSONRpcRequest alloc] initWithRequestID:[self nextID]
                                         withMethod:kFlutterDriverExtensionMethod
                                         withParams:params];
  return [[_client sendRequest:request] then:^id(GREYJSONRpcResponse *response) {
    return GREYCheckIfFlutterDriverResponseHasError(response);
  }];
}

#pragma mark - private

- (NSString *)nextID {
  static NSUInteger nextID;
  @synchronized([self class]) {
    return [NSString stringWithFormat:@"EarlGrey-Flutter %lu", (unsigned long)nextID++];
  }
}

@end

NSURL *GREYWebSocketURLFromURL(NSURL *url) {
  NSString *wsURLString =
      [NSString stringWithFormat:@"ws://%@:%@%@/ws", url.host, url.port, url.path];
  return [[NSURL alloc] initWithString:wsURLString];
}

NS_ASSUME_NONNULL_END
