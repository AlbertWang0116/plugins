#import "GREYDartVMService.h"

#import "GREYDartIsolateStatusResponse.h"
#import "GREYDartVMStatusResponse.h"
#import "GREYJSONRpcClient.h"
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

@interface GREYDartVMServiceImpl : NSObject <GREYDartVMService>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYDartVMService instance to communicate with the Dart VM.
 *
 * @param client A JSON-RPC client instance that has connection to a Dart VM observatory.
 * @return A GREYDartVMService instance.
 */
- (instancetype)initWithJSONRpcClient:(id<GREYJSONRpcClient>)client NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
