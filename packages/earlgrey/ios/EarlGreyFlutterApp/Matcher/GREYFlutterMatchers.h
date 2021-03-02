#import "GREYFlutterMatcher.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * A factory class that exposes Flutter matchers.
 */
@interface GREYFlutterMatchers : NSObject

/**
 * @return A matcher to find widgets by dartWidget::key. The targeted property of matched widgets
 *         should be a Dart ValueKey instance, which wraps the string the same as @c key.
 */
+ (id<GREYFlutterMatcher>)matcherWithValueKey:(NSString *)key;

/**
 * @return A matcher to find widgets by dartWidget::runtimeType in string form, which is the same
 *         as @c typeName
 */
+ (id<GREYFlutterMatcher>)matcherWithTypeName:(NSString *)typeName;

/**
 * @return A matcher to find widgets by dartWidget::tooltip. The targeted property of matched
 *         widgets should be a string the same as @c tooltip.
 */
+ (id<GREYFlutterMatcher>)matcherWithTooltip:(NSString *)tooltip;

/**
 * @return A matcher to find text widgets by the displaying text, which is the same as @c text.
 */
+ (id<GREYFlutterMatcher>)matcherWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
