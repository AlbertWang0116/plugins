#import <Foundation/Foundation.h>

#import "GREYFlutterMatcher.h"
#import "GREYFlutterInteractionProxy.h"
#import <EarlGreyTest/EarlGrey.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * EarlGrey extension for adding entrypoints of Flutter interaction.
 */
@interface EarlGreyImpl (Flutter)

/**
 * Creates a handle of Flutter UI interaction.
 *
 * @param matcher A Flutter widget matcher being used to find the target widget
 *                for this interaction.
 *
 * @return An instance of GERYFlutterInteraction which can be used to start
 *         an interaction.
 */
- (GREYFlutterInteractionProxy *)onFlutterWidget:(id<GREYFlutterMatcher>)matcher;

@end

NS_ASSUME_NONNULL_END
