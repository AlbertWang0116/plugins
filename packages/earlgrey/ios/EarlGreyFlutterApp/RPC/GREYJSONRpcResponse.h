#import <Foundation/Foundation.h>

#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An entity class that represents JSON-RPC 2.0 response.
 *
 * There is no validation applied for initilizer. To validate whether the response instance conforms
 * to JSON-RPC specification, please use GREYJSONRpcResponse::validateResponse: method in the Util
 * category.
 */
@interface GREYJSONRpcResponse : NSObject

/**
 * The 'id' field of JSON-RPC response.
 */
@property(nonatomic, readonly, nullable) GREYJSONValue requestID;

/**
 * The 'error' field of JSON-RPC response.
 */
@property(nonatomic, readonly, nullable) GREYJSONValue error;

/**
 * The 'result' field of JSON-RPC response.
 */
@property(nonatomic, readonly, nullable) GREYJSONValue result;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYJSONRpcResponse instance from a JSON object @c dictionary as NSDictionary.
 *
 * @param dictionary The JSON object to be converted.
 * @return an GREYJSONRpcResponse instance.
 */
- (instancetype)initWithDictionary:(GREYJSONDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

/**
 * Creates an NSDictionary instance that can be converted to JSON string.
 */
- (GREYJSONDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
