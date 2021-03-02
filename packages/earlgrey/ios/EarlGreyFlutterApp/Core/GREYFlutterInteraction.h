#import <Foundation/Foundation.h>

#import "GREYFlutterAction.h"
#import "GREYFlutterAssertion.h"
#import "GREYFlutterMatcher.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Interface for creating an interaction with Flutter widget.
 */
@interface GREYFlutterInteraction : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes the interaction with a single Flutter widget matching @c matcher.
 *
 * @param matcher Matcher for selecting Flutter widget to interact with.
 *
 * @return An instance of GREYFlutterInteraction, initialized with a specified matcher.
 */
- (instancetype)initWithFlutterMatcher:(id<GREYFlutterMatcher>)matcher NS_DESIGNATED_INITIALIZER;

/**
 * Starts an interaction by performing @c action on the target widget. If the interaction fails,
 * the error will be propagated through @c error;
 *
 * @params action     The action to be performed on the target widget.
 * @params[out] error The error handle to be populated on failure.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)performAction:(id<GREYFlutterAction>)action error:(__autoreleasing NSError **)error;

/**
 * Starts an interaction by performing @c assertion on the target widget. If the interaction fails,
 * the error will be propagated through @c error;
 *
 * @params assertion  The assertion to be performed on the target widget.
 * @params[out] error The error handle to be populated on failure.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)assert:(id<GREYFlutterAssertion>)assertion error:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END
