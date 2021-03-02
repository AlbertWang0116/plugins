#import <Foundation/Foundation.h>

#import "GREYFlutterAction.h"
#import "GREYConstants.h"

NS_ASSUME_NONNULL_BEGIN

/*
 * A factory class that exposes Flutter actions.
 */
@interface GREYFlutterActions : NSObject

/**
 * @return A GREYFlutterAction which performs a tap on target widget.
 */
+ (id<GREYFlutterAction>)actionForTap;

/**
 * @param direction The direction that scrolling gesture performs toward.
 * @param amount    The amount of screen pixels of the scrolling action.
 *
 * @return a GREYFlutterAction which performs scrolling on target widget.
 */
+ (id<GREYFlutterAction>)actionForScrollInDirection:(GREYDirection)direction
                                         withAmount:(CGFloat)amount;

@end

NS_ASSUME_NONNULL_END
