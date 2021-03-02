#import "GREYFlutterAssertion.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * A factory class that exposes Flutter assertions.
 */
@interface GREYFlutterAssertions : NSObject

/**
 * @return A GREYFlutterAssertion which asserts that there is a matched widget existing in Flutter
 *         widget tree.
 */
+ (id<GREYFlutterAssertion>)assertionForNotNil;

/**
 * @return A GREYFlutterAssertion which asserts that there is a matched widget that has finished
 *         rendering on the screen.
 */
+ (id<GREYFlutterAssertion>)assertionForInScreen;

@end

NS_ASSUME_NONNULL_END
