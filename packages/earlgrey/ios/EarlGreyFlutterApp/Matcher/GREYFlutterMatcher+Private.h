#import "GREYFlutterMatcher.h"

#import "GREYFlutterMatchingRule.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A protocol that defines the matching condition to locate a Flutter widget.
 *
 * The protocol is currently reserved as private type so that custom implementation is not
 * available. The behavior of this protocol is subject to change, but we will ensure
 * the built-in implementations exposed to user through GREYFlutterMatchers will not change.
 */
@protocol GREYFlutterMatcher

/**
 * @return A GREYFlutterMatchingRule instance which contains the serializable matching condition
 *         which can be sent to Flutter app to match the widget.
 */
@property(nonatomic, readonly) GREYFlutterMatchingRule *matchingRule;

@end

NS_ASSUME_NONNULL_END
