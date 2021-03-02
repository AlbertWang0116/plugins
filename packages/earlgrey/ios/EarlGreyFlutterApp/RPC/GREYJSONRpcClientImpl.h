#import "GREYJSONRpcClient.h"

@interface GREYJSONRpcClientImpl : NSObject <GREYJSONRpcClient>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the client and sends connection request to the @c URL.
 *
 * @param URL Server URL the client will connect to.
 *
 * @return An instance of GREYJSONRpcClient.
 */
- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

@end
