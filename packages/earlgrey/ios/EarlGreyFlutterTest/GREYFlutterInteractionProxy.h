#import <Foundation/Foundation.h>

#import "GREYFlutterAction.h"
#import "GREYFlutterAssertion.h"
#import "GREYFlutterMatcher.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Test-side class for directing calls to GREYFlutterInteraction in the app process. Must be
 *  called after establishing a valid connection with app process.
 */
@interface GREYFlutterInteractionProxy : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Initializes a proxy interaction which redirects commands to a GREYFlutterInteraction instance
 * at the app side.
 *
 * @param matcher Matcher for selecting Flutter widget to interact with.
 *
 * @return An instance of GREYFlutterInteraction, initialized with a specified matcher.
 */
- (instancetype)initWithFlutterMatcher:(id<GREYFlutterMatcher>)matcher NS_DESIGNATED_INITIALIZER;

/**
 * Proxies the action to GREYFlutterInteraction::performAction:error: at the app side. Upon receving
 * error, it will fail tests with the error information.
 *
 * @params action The action to be performed on the target widget.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)performAction:(id<GREYFlutterAction>)action;

/**
 * Proxies the action to GREYFlutterInteraction::performAction:error: at the app side. Upon receving
 * error, it will fail tests with the error information.
 *
 * @params action          The action to be performed on the target widget.
 * @params[out] errorOrNil The error handle to be populated on failure.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)performAction:(id<GREYFlutterAction>)action
                        error:(__autoreleasing NSError **)errorOrNil;

/**
 * Proxies the assertion to GREYFlutterInteraction::assert:error: at the app side. Upon receiving
 * error, it will fail tests with the error information.
 *
 * @params assertion The assertion to be performed on the target widget.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)assert:(id<GREYFlutterAssertion>)assertion;

/**
 * Proxies the assertion to GREYFlutterInteraction::performAction:error: at the app side. Upon
 * receiving error, it will fail tests with the error information.
 *
 * @params assertion       The assertion to be performed on the target widget.
 * @params[out] errorOrNil The error handle to be populated on failure.
 *
 * @return The interaction handle with the same matching rule.
 */
- (instancetype)assert:(id<GREYFlutterAssertion>)assertion
                 error:(__autoreleasing NSError **)errorOrNil;

@end

NS_ASSUME_NONNULL_END
