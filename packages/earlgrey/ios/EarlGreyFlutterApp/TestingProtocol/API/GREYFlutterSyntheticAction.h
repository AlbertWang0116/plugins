#import <Foundation/Foundation.h>

#import "GREYJSONValue.h"
#import "GREYFlutterMatchingRule.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This class stores widget synthetic action command that can be serialized and applied by
 * Flutter through Flutter driver extension service.
 */
@interface GREYFlutterSyntheticAction : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates the instance with the values for its properties.
 *
 * @param name The value of the name property.
 * @param params The value of the params property.
 * @return A GREYFlutterSyntheticAction instance.
 */
- (instancetype)initWithName:(NSString *)name
                  withParams:(GREYJSONDictionary *)params NS_DESIGNATED_INITIALIZER;

/**
 * The name of the synthetic action, which is one of the predefined Flutter driver commands.
 */
@property(nonatomic, readonly) NSString *name;

/**
 * Descriptions of the action parameters. Each key is a field name of the parameter, and the
 * corresponding value is the value of that field.
 */
@property(nonatomic, readonly) GREYJSONDictionary *params;

@end

NS_ASSUME_NONNULL_END
