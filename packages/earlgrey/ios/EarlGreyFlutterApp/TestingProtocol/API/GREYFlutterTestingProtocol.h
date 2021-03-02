#import <Foundation/Foundation.h>

#import "GREYFlutterMatchingRule.h"
#import "GREYFlutterSyntheticAction.h"
#import "GREYFlutterWidgetInfo.h"
#import <PromisesObjc/FBLPromises.h>

/**
 * This service provides communication protocols between EarlGrey and Flutter. An instance
 * of this service can perform UI testing interaction with a specific Flutter app.
 */
@protocol GREYFlutterTestingProtocol

/**
 * Sends a syncrhonization request to the Flutter app.
 *
 * @return A FBLPromise instance which will be resolved as NSNull instance at the first time that
 *         the Flutter app becomes idle after the request being sent. On error, the promise will
 *         be resolved with an NSError instance.
 */
- (FBLPromise<NSNull *> *)synchronize;

/**
 * Fetches a semantics widget info object that lives in Flutter widget tree.
 *
 * @param matchingRule The definition of the matching condition which can be interpreted in the
 *                     Flutter app as a Flutter widget matcher.
 *
 * @return A FBLPromise instance which will be resolved as a GREYFlutterWidgetInfo instance. The
 *         instance contains the properties and location information of the matched widget. On
 *         error, the promise will be resolved with an NSError instance.
 */
@optional
- (FBLPromise<GREYFlutterWidgetInfo *> *)matchWidget:(GREYFlutterMatchingRule *)matchingRule;

/**
 * Performs a synthetic action on a Flutter widget.
 *
 * @param action The definition of the action which can be interpreted in the Flutter app as
 *               type of the action and additional parameters to that type of the action.
 * @param matchingRule The definition of the matching condition which can be interpreted in the
 *                     Flutter app as a Flutter widget matcher.
 *
 * @return A FBLPromise instance which will be resolved as NSNull when the synthetic action is
 *         successfully performed. On error, the promise will be resolved with an NSError instance.
 */
- (FBLPromise<NSNull *> *)performAction:(GREYFlutterSyntheticAction *)action
                       withMatchingRule:(GREYFlutterMatchingRule *)matchingRule;

@end
