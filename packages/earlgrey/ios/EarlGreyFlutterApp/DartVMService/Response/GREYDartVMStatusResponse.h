#import <Foundation/Foundation.h>

#import "GREYJSONRpcResponse.h"
#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An entity class of VM state that is returned from Dart VM service.
 */
@interface GREYDartVMStatusResponse : NSObject

/**
 * The name field of the Dart VM.
 */
@property(nonatomic, readonly) NSString *name;

/**
 * The list of identifiers of the active Dart isolates on that Dart VM.
 */
@property(nonatomic, readonly) NSArray<NSString *> *isolateIDs;

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYDartVMStatusResponse instance from @c response.
 *
 * @param params A NSDictionary instance containing entities that can be parsed to the properties
 *               of this instance.
 * @return A GREYDartVMStatusResponse instance.
 */
- (instancetype)initWithDictionary:(GREYJSONDictionary *)params NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
