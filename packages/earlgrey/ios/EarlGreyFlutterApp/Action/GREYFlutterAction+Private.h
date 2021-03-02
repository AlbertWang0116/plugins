#import "GREYFlutterAction.h"

#import "GREYFlutterMatchingRule.h"
#import "GREYFlutterTestingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A protocol for actions that will be performed on Flutter widgets.
 *
 * The protocol is currently reserved as private type so that custom implementation is not
 * available. The behavior of this protocol is subject to change, but we will ensure
 * the built-in implementations exposed to user through GREYFlutterActions will not change.
 */
@protocol GREYFlutterAction

/**
 * The name of the action, will be used in debug and failure message.
 */
@property(nonatomic, readonly) NSString *name;

/**
 * Performs an action, specified by GREYFlutterAction implementation, on a Flutter widget described
 * by @c matchingRule.
 *
 * @param matchingRule    The description to a Flutter widget. Action can send it to Flutter
 *                        through @c testingProtocol to fetch widget info or perform synthetic
 *                        action.
 * @param testingProtocol It provides communication protocol between the action and target Flutter
 *                        application.
 * @param containerView   The container UIView of the Flutter application.
 * @param[out] errorOrNil Error that will be populated on failure. The implementing class should
 *                        handle the behavior when it is @c nil by, for example, logging the error
 *                        or throwing an exception.
 *
 * @return @c YES if the action succeeded, else @c NO. If an action returns @c NO, it does not
 *         mean that the action was not performed at all but somewhere during the action execution
 *         the error occurred and so the UI may be in an unrecoverable state.
 */
- (BOOL)performAction:(GREYFlutterMatchingRule *)matchingRule
    withTestingProtocol:(id<GREYFlutterTestingProtocol>)testingProtocol
      withContainerView:(UIView *)containerView
                  error:(__strong NSError **)errorOrNil;

@end

NS_ASSUME_NONNULL_END
