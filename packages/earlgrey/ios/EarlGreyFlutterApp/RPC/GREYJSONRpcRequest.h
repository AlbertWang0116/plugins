#import <Foundation/Foundation.h>

#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An entity class that represents JSON-RPC 2.0 request. It exposes the top-level fields
 * of a JSON-RPC request as properties of this class.
 *
 * There is no validation applied for initializer. To validate whether the request instance
 * conforms to JSON-RPC specification, please use GREYJSONRpcRequest::validateRequest: method is in
 * the Util category.
 */
@interface GREYJSONRpcRequest : NSObject

/**
 * The 'id' field of JSON-RPC.
 */
@property(nonatomic, readonly, nullable) GREYJSONValue requestID;

/**
 * The 'method' field of JSON-RPC.
 */
@property(nonatomic, readonly) NSString *method;

/**
 * The 'params' field of JSON-RPC.
 */
@property(nonatomic, readonly, nullable) GREYJSONValue params;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates the instance with the values for its properties.
 *
 * @param requestID The value of the requestID property.
 * @param method The value of the method property.
 * @param params The value of the params property
 * @return A GREYJSONRpcRequest instance.
 */
- (instancetype)initWithRequestID:(nullable GREYJSONValue)requestID
                       withMethod:(NSString *)method
                       withParams:(nullable GREYJSONValue)params NS_DESIGNATED_INITIALIZER;

/**
 * Creates a NSDictionary instance that can be converted to JSON string.
 */
- (GREYJSONDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
