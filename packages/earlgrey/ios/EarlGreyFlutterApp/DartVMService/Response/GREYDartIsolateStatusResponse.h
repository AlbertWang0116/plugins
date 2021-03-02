#import <Foundation/Foundation.h>

#import "GREYJSONRpcResponse.h"
#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An entity class of isolate State that is returned from Dart VM service.
 */
@interface GREYDartIsolateStatusResponse : NSObject

/**
 * The name field of the isolate.
 */
@property(nonatomic, readonly) NSString *name;

/**
 * The unique identifier of the isolate.
 */
@property(nonatomic, readonly) NSString *isolateID;

/**
 * The available Dart VM service extensions that are available on the isolate.
 */
@property(nonatomic, readonly) NSSet<NSString *> *extensionRPCs;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYDartIsolateStatusResponse instance.
 *
 * @param params A NSDictionary instance containing entities that can be parsed to the properties
 *               of this instance.
 * @return A GREYDartIsolateStatusResponse instance.
 */
- (instancetype)initWithDictionary:(GREYJSONDictionary *)params NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
