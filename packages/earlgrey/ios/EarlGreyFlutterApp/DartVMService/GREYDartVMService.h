#import <Foundation/Foundation.h>

#import "GREYDartIsolateStatusResponse.h"
#import "GREYDartVMStatusResponse.h"
#import "GREYJSONValue.h"
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GREYDartVMService

/**
 * Fetches information of Dart VM which runs inside this iOS application.
 *
 * @return A FBLPromise instance. On success, it is resolved with a GREYDartVMStatusResponse
 *         instance which exposes Dart VM information through its properties.
 */
- (FBLPromise<GREYDartVMStatusResponse *> *)fetchDartVMStatus;

/**
 * Fetches information of each Dart isolate which runs inside the only Dart VM heled by this iOS
 * application.
 *
 * @return A FBLPromise instance. On success, it is resolved with a list of
 *         GREYDartIsolateStatusResponse instances, and each of them exposes the isolate information
 *         through its properties.
 */
- (FBLPromise<NSArray<GREYDartIsolateStatusResponse *> *> *)fetchDartIsolatesStatus;

/**
 * Fetches information of a Dart isolate which runs inside the only Dart VM held by this iOS
 * application.
 *
 * @param isolateID The Dart isolate to query.
 * @return A FBLPromise instance. On success, it is resolved with a GREYDartIsolateStatusResponse
 * instance which exposes the isolate information through its properties.
 */
- (FBLPromise<GREYDartIsolateStatusResponse *> *)fetchDartIsolateStatusWithIsolateID:
    (NSString *)isolateID;

/**
 * Sends a Flutter driver command to target Flutter application.
 *
 * @param command The command name which is one of the available value defined in the driver
 *                extension protocol.
 * @param isolateID The unique identifier of the isolate that the Flutter application runs on.
 * @param driverParams Additional parameters required for the driver command, which is defined in
 *                     the driver extension protocol.
 * @return A FBLPromise instance. On success, it is resolved with a JSON object as the response
 *         of the sent driver command. If either Dart VM service request or Flutter driver command
 *         fails, the promise will be resolved as failure.
 */
- (FBLPromise<GREYJSONValue> *)invokeFlutterDriverCommand:(NSString *)command
                                         onFlutterIsolate:(NSString *)isolateID
                                               withParams:(GREYJSONDictionary *)driverParams;

@end

NS_ASSUME_NONNULL_END
