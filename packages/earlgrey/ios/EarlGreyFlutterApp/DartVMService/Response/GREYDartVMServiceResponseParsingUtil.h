#import <Foundation/Foundation.h>

#import "GREYDartIsolateStatusResponse.h"
#import "GREYDartVMStatusResponse.h"
#import "GREYJSONRpcResponse.h"
#import "GREYJSONValue.h"
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Checks if @c response is a JSON-RPC error.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError instance if
 * the @c response is an error, or @c response.result otherwise.
 */
FBLPromise<GREYJSONValue> *GREYCheckIfJSONRpcResponseHasError(
    GREYJSONRpcResponse *response);

/**
 * Converts JSON-RPC response @c response to a GREYDartVMStatusResponse
 * instance.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError instance if
 * the @c response is an error, or a GREYDartVMStatusResponse instance
 * otherwise.
 */
FBLPromise<GREYDartVMStatusResponse *> *GREYParseDartVMStatusResponse(
    GREYJSONRpcResponse *response);

/**
 * Converts JSON-RPC response @c response to a GREYDartIsolateStatusResponse
 * instance.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError instance if
 * the @c response is an error, or a GREYDartIsolateStatusResponse instance
 * otherwise.
 */
FBLPromise<GREYDartIsolateStatusResponse *> *GREYParseDartIsolateStatusResponse(
    GREYJSONRpcResponse *response);

/**
 * Extracts Flutter driver extesnion response from a JSON-RPC response @c
 * response, and checks if the Flutter driver extension response is an error.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError instance if
 * the @c response or the JSON-RPC result is an error, otherwise a JSON object
 * as driver response will be resolved.
 */
FBLPromise<GREYJSONValue> *GREYCheckIfFlutterDriverResponseHasError(
    GREYJSONRpcResponse *response);

/**
 * Checks if the request of GREYFlutterDriverExtTap fails.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError if either
 * JSON-RPC failed or the request failed, or a NSNull instance otherwise.
 */
FBLPromise<NSNull *> *GREYParseFlutterDriverTapResponse(
    GREYJSONRpcResponse *response);

/**
 * Checks if the request of GREYFlutterDriverExtWait fails.
 *
 * @param response The JSON-RPC response returned from Dart VM service.
 * @return A FBLPromise instance which will be resolved with NSError if either
 * JSON-RPC failed or the request failed, or a NSNull instance otherwise.
 */
FBLPromise<NSNull *> *GREYParseFlutterDriverWaitResponse(
    GREYJSONRpcResponse *response);

NS_ASSUME_NONNULL_END
