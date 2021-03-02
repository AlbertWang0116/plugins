#import "GREYDartVMConnectionUtil.h"

#import <Flutter/Flutter.h>

#include <objc/runtime.h>

#import "GREYSwizzler.h"

@interface GREYDartVMConnectionUtil ()

/** Private initializler of this class. */
- (instancetype)initPrivate;

/** Swizzled FlutterEngine::initWithName:project:allowHeadlessExecution implementation. */
- (instancetype)greySwizzledInitWithName:(NSString *)labelPrefix
                                 project:(FlutterDartProject *)projectOrNil
                  allowHeadlessExecution:(BOOL)allowHeadlessExecution
                      restorationEnabled:(BOOL)restorationEnabled;

/** Exposes FlutterView's private designated initializer initWithDelegate:opaque:. */
- (instancetype)initWithDelegate:(FlutterEngine *)delegate opaque:(BOOL)opaque;

/** Swizzled FlutterView::initWithDelegate:opaque: implementation. */
- (instancetype)greySwizzledInitWithDelegate:(FlutterEngine *)delegate opaque:(BOOL)opaque;

@end

@implementation GREYDartVMConnectionUtil {
  NSHashTable<FlutterEngine *> *_weakFlutterEngines;
  NSURL *_observatoryURL;
}

+ (GREYDartVMConnectionUtil *)sharedInstance {
  static GREYDartVMConnectionUtil *singleton;
  static dispatch_once_t once_token;
  dispatch_once(&once_token, ^{
    singleton = [[GREYDartVMConnectionUtil alloc] initPrivate];
  });
  return singleton;
}

- (instancetype)initPrivate {
  self = [super init];
  if (self) {
    _weakFlutterEngines = [NSHashTable weakObjectsHashTable];
  }
  return self;
}

- (NSURL *)observatoryURL {
  if (_observatoryURL) {
    return _observatoryURL;
  }
  @synchronized(self) {
    for (FlutterEngine *engine in _weakFlutterEngines) {
      _observatoryURL = [engine.observatoryUrl copy];
      if (_observatoryURL) {
        break;
      }
    }
    if (_observatoryURL) {
      [_weakFlutterEngines removeAllObjects];
    }
  }
  return _observatoryURL;
}

- (instancetype)greySwizzledInitWithName:(NSString *)labelPrefix
                                 project:(FlutterDartProject *)projectOrNil
                  allowHeadlessExecution:(BOOL)allowHeadlessExecution
                      restorationEnabled:(BOOL)restorationEnabled {
  FlutterEngine *engine = INVOKE_ORIGINAL_IMP4(
      FlutterEngine *,
      @selector(greySwizzledInitWithName:project:allowHeadlessExecution:restorationEnabled:),
      labelPrefix, projectOrNil, allowHeadlessExecution, restorationEnabled);
  GREYDartVMConnectionUtil *context = [GREYDartVMConnectionUtil sharedInstance];
  @synchronized(context) {
    if (!context.observatoryURL) {
      [context->_weakFlutterEngines addObject:engine];
    }
  }
  return (id)engine;
}

- (instancetype)greySwizzledInitWithDelegate:(FlutterEngine *)delegate opaque:(BOOL)opaque {
  id flutterView =
      INVOKE_ORIGINAL_IMP2(id, @selector(greySwizzledInitWithDelegate:opaque:), delegate, opaque);
  objc_setAssociatedObject(flutterView, @selector(engine), delegate,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  return flutterView;
}

- (instancetype)initWithDelegate:(FlutterEngine *)delegate opaque:(BOOL)opaque {
  return nil;
}

__attribute__((constructor)) static void InitFlutterObservatoryFetcher() {
  @autoreleasepool {
    // This swizzling aims to capture each FlutterEngine instance to later query the observatory
    // URL exposed by it. FlutterEngines are weakly held inside this class. Once this class
    // fetches observatory URL from any of the instances, it releases all the weak references to
    // engines, and always exposes that URL to users of this class. This observatory is used by all
    // the Flutter applications in this iOS application by design.
    //
    // The current way is hacky because Flutter framework doesn't provide a graceful way to fetch
    // the observatory URL without getting the reference of a Flutter engine. But we can put a
    // feature request in the future to make the URL being broadcasted by the framework.
    SEL designatedInitializerSel =
        @selector(initWithName:project:allowHeadlessExecution:restorationEnabled:);
    SEL swizzledDesignatedInitializerSel =
        @selector(greySwizzledInitWithName:project:allowHeadlessExecution:restorationEnabled:);
    Method swizzledMethod = class_getInstanceMethod(
        [GREYDartVMConnectionUtil class], swizzledDesignatedInitializerSel);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);

    GREYSwizzler *swizzler = [[GREYSwizzler alloc] init];
    BOOL swizzleSuccess = [swizzler swizzleClass:[FlutterEngine class]
                               addInstanceMethod:swizzledDesignatedInitializerSel
                              withImplementation:swizzledIMP
                    andReplaceWithInstanceMethod:designatedInitializerSel];
    NSCAssert(swizzleSuccess, @"Could not swizzle [FlutterEngine "
                              @"initWithName:project:allowHeadlessExecution:restorationEnabled:]");

    // This swizzle captures the Flutter engine being used to initialize FlutterView, and exposes
    // it through association object. This allows EarlGrey to fetch the underline Flutter isolate
    // by matched FlutterView.
    Class flutterViewClass = NSClassFromString(@"FlutterView");
    SEL originalSelector = @selector(initWithDelegate:opaque:);
    if (!class_getInstanceMethod(flutterViewClass, originalSelector)) {
      NSLog(@"WARNING!!!! FlutterView no longer has initWithDelegate:opaque:");
      Method placeholderMethod =
          class_getInstanceMethod([GREYDartVMConnectionUtil class], originalSelector);
      IMP placeholderIMP = method_getImplementation(placeholderMethod);
      class_addMethod(flutterViewClass, originalSelector, placeholderIMP, "@");
    }

    SEL swizzledSelector = @selector(greySwizzledInitWithDelegate:opaque:);
    swizzledMethod = class_getInstanceMethod([GREYDartVMConnectionUtil class], swizzledSelector);
    swizzledIMP = method_getImplementation(swizzledMethod);
    swizzleSuccess = [swizzler swizzleClass:flutterViewClass
                          addInstanceMethod:swizzledSelector
                         withImplementation:swizzledIMP
               andReplaceWithInstanceMethod:originalSelector];
    NSCAssert(swizzleSuccess, @"Could not swizzle [FlutterView initWithDelegate:opaque:]");
  }
}

@end
