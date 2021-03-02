#import <Foundation/Foundation.h>

#import "GREYJSONRpcRequest.h"
#import "GREYJSONRpcResponse.h"
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A general JSON-RPC client based on promise.
 */
@protocol GREYJSONRpcClient

/**
 * Asynchronously sends connect request to the server. It should be called at most once.
 */
- (void)open;

/**
 * Sends @c request to the server which this client connects to. GREYJSONRpcClient::open should be
 * called before calling this method. If the connection has not been created yet, the request will
 * be queued.
 *
 * @param request The body of JSON-RPC in the form of dictionary. As it is sent to Dart VM Service,
 * it should at lease have 'id' field.
 *
 * @return A FBLPromise which will be resolved with JSON-RPC response, in the form of dictionary,
 *         once client receives the response. The callback is executed on a background serial queue.
 */
- (nullable FBLPromise<GREYJSONRpcResponse *> *)sendRequest:(GREYJSONRpcRequest *)request;

/**
 * Synchronously closes the client. This invocation will block the current thread and wait for all
 * ongoing requests to be completed. Requests sent after this invocation will not be processed.
 *
 * Be aware this should not be called on the main queue as it will be blocked. In that case, use
 * GREYJSONRpcClient::closeAsync and handle the close event through promise.
 */
- (void)close;

/**
 * Asynchronously closes the client. It will call synchronous `close` on global concurrent queue
 * so caller thread will not get blocked. The returned FBLPromise will be resolved when this client
 * is successfully closed. Before this client is fully closed, unresolved FBLPromises generated
 * by the ongoing requests will be kept and processed once response comes back.
 *
 * @return A FBLPromise instance which will be resolved with NSNull when the client is fully closed.
 */
- (FBLPromise<NSNull *> *)closeAsync;

@end

NS_ASSUME_NONNULL_END
