#import "GREYFlutterAssertion+Private.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^GREYFlutterAssertionBlock)(GREYFlutterMatchingRule *matchingRule,
                                          id<GREYFlutterTestingProtocol> testingProtocol,
                                          __strong NSError **errorOrNil);

/**
 * A block based GREYFlutterAssertion implementation.
 */
@interface GREYFlutterBlockAssertion : NSObject <GREYFlutterAssertion>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYFlutterAssertion that performs the assertion in the provided @c block.
 *
 * @param name  The name property of the GREYFlutterAssertion.
 * @param block A block that contains the assertion to execute.
 *
 * @return A GREYAssertionBlock instance with the given property values.
 */
- (instancetype)initWithName:(NSString *)name
          withAssertionBlock:(GREYFlutterAssertionBlock)block NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
