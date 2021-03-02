#import <Foundation/Foundation.h>
#include <objc/runtime.h>

#import "GREYFlutterViewControllerIdlingResource.h"
#import "GREYUIThreadExecutor+Private.h"
#import "GREYFatalAsserts.h"
#import "GREYSwizzler.h"

/**
 * Injects additional operation to FlutterViewController to track its first rendering status
 * in GREYFlutterViewControllerIdlingResource.
 */
@interface FlutterViewController (GREYSynchronization)

@end

@implementation FlutterViewController (GREYSynchronization)

__attribute__((constructor)) static void InitFlutterViewControllerSyncInjection() {
  @autoreleasepool {
    Class swizzledClass = [FlutterViewController class];
    GREYSwizzler *swizzler = [[GREYSwizzler alloc] init];
    BOOL swizzleSuccess = [swizzler swizzleClass:swizzledClass
                           replaceInstanceMethod:@selector(viewDidAppear:)
                                      withMethod:@selector(greySwizzledFlutterViewDidAppear:)];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Could not swizzle [FlutterViewController viewDidAppear:]");

    swizzleSuccess = [swizzler swizzleClass:swizzledClass
                      replaceInstanceMethod:@selector(viewDidDisappear:)
                                 withMethod:@selector(greySwizzledFlutterViewDidDisappear:)];
    GREYFatalAssertWithMessage(swizzleSuccess,
                               @"Could not swizzle [FlutterViewController viewDidDisappear:]");
  }
}

- (void)greySwizzledFlutterViewDidAppear:(BOOL)animated {
  GREYFlutterViewControllerIdlingResource *idlingResource =
      [[GREYFlutterViewControllerIdlingResource alloc] initWithFlutterViewController:self];
  objc_setAssociatedObject(self, @selector(greySwizzledFlutterViewDidAppear:), idlingResource,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [[GREYUIThreadExecutor sharedInstance] registerIdlingResource:idlingResource];
  INVOKE_ORIGINAL_IMP1(void, @selector(greySwizzledFlutterViewDidAppear:), animated);
  // This method only takes effect after original viewDidAppear: completed.
  [self.engine ensureSemanticsEnabled];
}

- (void)greySwizzledFlutterViewDidDisappear:(BOOL)animated {
  GREYFlutterViewControllerIdlingResource *idlingResource =
      objc_getAssociatedObject(self, @selector(greySwizzledFlutterViewDidAppear:));
  [[GREYUIThreadExecutor sharedInstance] deregisterIdlingResource:idlingResource];
  INVOKE_ORIGINAL_IMP1(void, @selector(greySwizzledFlutterViewDidDisappear:), animated);
}

@end
