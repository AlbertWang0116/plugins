#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>

#import "GREYIdlingResource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * GREYIdlingResource that ensures all the tacked FlutterViewController has
 * updated semantic objects through accessibility API, which also indicates the
 * first rendering of flutter views has completed.
 */
@interface GREYFlutterViewControllerIdlingResource : NSObject <GREYIdlingResource>

/** Disables default initilizer. */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates an idling resource that tracks @c flutterViewController.
 * A weak reference is held to @c flutterViewController. If @c flutterViewController is
 * deallocated, then the idling resource will deregister itself from the UI thread executor.
 *
 * @param flutterViewController The FlutterViewController instance that will be tracked by the
 *                              idling resource.
 *
 * @return A new and initialized GREYFlutterViewControllerIdlingResource instance.
 */
- (instancetype)initWithFlutterViewController:(FlutterViewController *)flutterViewController;

@end

NS_ASSUME_NONNULL_END
