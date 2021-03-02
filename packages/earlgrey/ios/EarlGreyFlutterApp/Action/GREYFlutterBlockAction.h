#import "GREYFlutterAction+Private.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^GREYFlutterActionBlock)(GREYFlutterMatchingRule *matchingRule,
                                       id<GREYFlutterTestingProtocol> testingProtocol,
                                       UIView *containerView,
                                       __strong NSError **errorOrNil);

/**
 * A block based GREYFlutterAction implementation.
 */
@interface GREYFlutterBlockAction : NSObject <GREYFlutterAction>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYFlutterAction that performs the action in the provided @c block.
 *
 * @param name        The name property of the GREYFlutterAction.
 * @param block       A block that contains the action to execute.
 *
 * @return A GREYActionBlock instance with the given property values.
 */
- (instancetype)initWithName:(NSString *)name
             withActionBlock:(GREYFlutterActionBlock)block NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
