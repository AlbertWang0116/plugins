#import <Foundation/Foundation.h>

#import "GREYJSONRpcRequest.h"
#import "GREYJSONRpcResponse.h"
#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Checks whether @c jsonValue is a number and return it or nil.
 */
NSNumber *GREYNumberFromJSONValue(GREYJSONValue jsonValue);

/**
 * Checks whether @c jsonValue is a string and return it or nil.
 */
NSString *GREYStringFromJSONValue(GREYJSONValue jsonValue);

/**
 * Checks whether @c jsonValue is an array and return it or nil.
 */
NSArray *GREYArrayFromJSONValue(GREYJSONValue jsonValue);

/**
 * Checks whether @c jsonValue is a dictionary and return it or nil.
 */
GREYJSONDictionary *GREYDictionaryFromJSONValue(GREYJSONValue jsonValue);

/**
 * Validates each property of @c request so that it conforms to JSON-RPC specifications, including:
 *
 * @c request.requestID: It can be NSString, NSNumber or nil. In the case of nil, the server will
 *                consider request to be notification.
 * @c request.method: It should not be nil, or in reserved format, i.e. 'rpc.*'.
 * @c request.params: It can be any JSON object, or nil.
 *
 * @param request The validated GREYJSONRpcRequest instance.
 */
void GREYValidateJSONRpcRequest(GREYJSONRpcRequest *request);

/**
 * Validates each property of @c response so that it conforms to JSON-RPC specifications, including:
 *
 * @c response.requestID: It should be either NSString or NSNumber.
 * @c response.error: It can be any JSON object or nil. When it is not nil, the @c response.result
 *                    should be nil.
 * @c response.result: It can be any JSON object or nil. When it is not nil, the @c response.error
 *                     should be nil.
 *
 * @param response The validated GREYJSONRpcResponse instance.
 */
void GREYValidateJSONRpcResponse(GREYJSONRpcResponse *response);

/**
 * Merges multiple JSON objects as an array of NSDictionary into one JSON object.
 *
 * @param jsonDictionaries An array of string-key dictionaries.
 *
 * @return A string-key dictionary as merged JSON object. It is the union of @c jsonObjects.
 *
 * @note Any field name appearing in @c jsonObjects should be unique.
 */
GREYJSONDictionary *GREYMergeJSONDictionaries(NSArray<GREYJSONDictionary *> *jsonDictionaries);

NS_ASSUME_NONNULL_END
