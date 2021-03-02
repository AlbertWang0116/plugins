#import "GREYFlutterMatcher+Private.h"

#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A semantic rule based GREYFlutterRuleMatcher implementation. It contains serializable
 * matching condition that can be sent to Flutter app to match widget.
 */
@interface GREYFlutterRuleMatcher : NSObject <GREYFlutterMatcher>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Create an instance with key-value based matching condition @c rules.
 *
 * @param rules A dictionary data describing the matching arguments.
 *
 * @return A GREYFlutterRuleMatcher instance.
 */
- (instancetype)initWithRules:(GREYJSONDictionary *)rules NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
