#import <Foundation/Foundation.h>

#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The class that stores the widget matching condition that can be serialized and applied by
 * Flutter through Flutter driver extension service.
 */
@interface GREYFlutterMatchingRule : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates the instance with the values for its properties.
 *
 * @param rules The value of the rules property.
 * @return A GREYFlutterMatchingRule instance.
 */
- (instancetype)initWithRules:(GREYJSONDictionary *)rules NS_DESIGNATED_INITIALIZER;

/**
 * Descriptions of the matcher to be used by Flutter. Each key is a field name of the matcher,
 * and the corresponding value is the value for that field.
 */
@property(nonatomic, readonly) GREYJSONDictionary *rules;

@end

NS_ASSUME_NONNULL_END
