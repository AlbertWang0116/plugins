#import <Foundation/Foundation.h>

#import "GREYFlutterMatchingRule.h"
#import "GREYFlutterTestingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A protocol for assertions that checks if a Flutter widget satisfies a condition.
 *
 * The protocol is currently reserved as private type so that custom implementation is not
 * available. The behavior of this protocol is subject to change, but we will ensure
 * the built-in implementations exposed to users through GREYFlutterAssertion will not change.
 */
@protocol GREYFlutterAssertion

/**
 * The name of the assertion, for use in the debug and failure message.
 */
@property(nonatomic, readonly) NSString *name;

/**
 * Performs an assertion, specified by GREYFlutterAssertion implementation, on a Flutter widget
 * described by @c matchingRule.
 *
 * @param matchingRule The description of a Flutter widget. Assertion can send it to Flutter
 *                     through @c testingProtocol to fetch widget info or perform Dart
 *                     assertion inside Flutter.
 * @param testingProtocol It provides communication protocol between the assertion and target
 *                        Flutter application.
 * @param[out] errorOrNil Error that will be populated on failure. The implementing class should
 *                        handle the behavior when it is @c nil by, for example, logging the error
 *                        or throwing an exception.
 *
 * @return @c YES if the assertion succeeded, else @c NO.
 */
- (BOOL)assert:(GREYFlutterMatchingRule *)matchingRule
    withTestingProtocol:(id<GREYFlutterTestingProtocol>)testingProtocol
                  error:(__strong NSError **)errorOrNil;

@end

NS_ASSUME_NONNULL_END
