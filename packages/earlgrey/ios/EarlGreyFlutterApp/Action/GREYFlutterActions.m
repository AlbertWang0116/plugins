#import "GREYFlutterActions.h"

#import "GREYFlutterBlockAction.h"
#import "GREYFlutterMatchingRule.h"
#import "GREYFlutterSyntheticAction.h"
#import "GREYFlutterTestingProtocol.h"
#import "GREYFlutterWidgetInfo.h"
#import "GREYTapper.h"
#import "GREYSyncAPI.h"
#import <PromisesObjc/FBLPromise+Testing.h>
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

static const NSUInteger kGREYFlutterScrollDurationMicroSeconds = 1000000;
static const NSUInteger kGREYFlutterScrollFrequency = 60;
static const NSUInteger kGREYFlutterActionNativeTimeoutSeconds = 600;

@implementation GREYFlutterActions

+ (id<GREYFlutterAction>)actionForTap {
  return [[GREYFlutterBlockAction alloc]
         initWithName:@"synthetic click action"
      withActionBlock:^BOOL(GREYFlutterMatchingRule *matchingRule,
                            id<GREYFlutterTestingProtocol> testingProtocol,
                            UIView *containerView,
                            __strong NSError **errorOrNil) {
        NSError *error = nil;
        FBLPromise *matchingPromise = [testingProtocol matchWidget:matchingRule];
        grey_check_condition_until_timeout(
            ^BOOL {
              return !matchingPromise.isPending;
            },
            kGREYFlutterActionNativeTimeoutSeconds);
        GREYFlutterWidgetInfo *widgetInfo = FBLPromiseAwait(matchingPromise, &error);
        if (error) {
          if (errorOrNil) {
            *errorOrNil = error;
          }
          return NO;
        }
        __block UIWindow *window;
        grey_dispatch_sync_on_main_thread(^{
          window = containerView.window;
        });
        CGRect widgetRect = widgetInfo.rect;
        CGPoint widgetCenter = CGPointMake(CGRectGetMidX(widgetRect), CGRectGetMidY(widgetRect));
        return [GREYTapper tapOnWindow:window
                          numberOfTaps:1
                              location:widgetCenter
                                 error:errorOrNil];
      }];
}

+ (id<GREYFlutterAction>)actionForScrollInDirection:(GREYDirection)direction
                                         withAmount:(CGFloat)amount {
  return [[GREYFlutterBlockAction alloc]
         initWithName:@"synthetic scroll action"
      withActionBlock:^BOOL(GREYFlutterMatchingRule *matchingRule,
                            id<GREYFlutterTestingProtocol> testingProtocol,
                            UIView *containerView,
                            __strong NSError **errorOrNil) {
        NSError *error;
        CGFloat dx = 0.f, dy = 0.f;
        switch (direction) {
          case kGREYDirectionLeft:
            dx = -amount;
            break;
          case kGREYDirectionRight:
            dx = amount;
            break;
          case kGREYDirectionUp:
            dy = -amount;
            break;
          case kGREYDirectionDown:
            dy = amount;
            break;
        }
        GREYFlutterSyntheticAction *syntheticAction = [[GREYFlutterSyntheticAction alloc]
            initWithName:@"scroll"
              withParams:@{
                @"dx" : [NSNumber numberWithFloat:dx],
                @"dy" : [NSNumber numberWithFloat:dy],
                @"duration" : @(kGREYFlutterScrollDurationMicroSeconds),
                @"frequency" : @(kGREYFlutterScrollFrequency)
              }];
        FBLPromise *scrollPromise = [testingProtocol performAction:syntheticAction
                                                  withMatchingRule:matchingRule];
        grey_check_condition_until_timeout(
            ^BOOL {
              return !scrollPromise.isPending;
            },
            kGREYFlutterActionNativeTimeoutSeconds);
        FBLPromiseAwait(scrollPromise, &error);
        if (error && errorOrNil) {
          *errorOrNil = error;
        }
        return error == nil;
      }];
}

@end

NS_ASSUME_NONNULL_END
