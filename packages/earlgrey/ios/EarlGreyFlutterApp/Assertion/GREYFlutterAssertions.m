#import "GREYFlutterAssertions.h"

#import "GREYFlutterBlockAssertion.h"
#import "GREYFlutterMatchingRule.h"
#import "GREYFlutterTestingProtocol.h"
#import "GREYFlutterWidgetInfo.h"
#import "GREYSyncAPI.h"
#import "GREYError.h"
#import <PromisesObjc/FBLPromise+Testing.h>
#import <PromisesObjc/FBLPromises.h>

static const NSUInteger kGREYFlutterAssertionNativeTimeoutSeconds = 600;

NS_ASSUME_NONNULL_BEGIN

/** Creates an assertion block that only checks the widget info of matched Flutter widget. */
GREYFlutterAssertionBlock static WidgetInfoAssertionBlock(
    BOOL (^assertionBlock)(GREYFlutterWidgetInfo *widgetInfo, NSError **error)) {
  return ^BOOL(GREYFlutterMatchingRule *matchingRule,
               id<GREYFlutterTestingProtocol> testingProtocol, __strong NSError **errorOrNil) {
    NSError *error = nil;
    FBLPromise *matchingPromise = [testingProtocol matchWidget:matchingRule];
    grey_check_condition_until_timeout(
        ^BOOL {
          return !matchingPromise.isPending;
        },
        kGREYFlutterAssertionNativeTimeoutSeconds);
    GREYFlutterWidgetInfo *widgetInfo = FBLPromiseAwait(matchingPromise, &error);
    if (error && errorOrNil) {
      *errorOrNil = error;
      return NO;
    }
    NSError *assertionError;
    BOOL success = assertionBlock(widgetInfo, &assertionError);
    if (errorOrNil && assertionError) {
      *errorOrNil = assertionError;
    }
    return success;
  };
}

@implementation GREYFlutterAssertions

+ (id<GREYFlutterAssertion>)assertionForNotNil {
  return [[GREYFlutterBlockAssertion alloc]
            initWithName:@"Flutter widget is not nil"
      withAssertionBlock:WidgetInfoAssertionBlock(
                             ^BOOL(GREYFlutterWidgetInfo *widgetInfo, NSError **error) {
                               return widgetInfo != nil;
                             })];
}

+ (id<GREYFlutterAssertion>)assertionForInScreen {
  return [[GREYFlutterBlockAssertion alloc]
            initWithName:@"Flutter widget is in screen"
      withAssertionBlock:WidgetInfoAssertionBlock(^BOOL(GREYFlutterWidgetInfo *widgetInfo,
                                                        NSError **error) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        BOOL result = CGRectContainsRect(screen, widgetInfo.rect);
        if (!result) {
          NSString *reason = [NSString
              stringWithFormat:@"Target widget's bounding rect (%@) is not inside the screen (%@).",
                               NSStringFromCGRect(widgetInfo.rect), NSStringFromCGRect(screen)];
          *error = GREYErrorMake(kGREYInteractionErrorDomain,
                                 kGREYInteractionAssertionFailedErrorCode, reason);
        }
        return result;
      })];
}

@end

NS_ASSUME_NONNULL_END
