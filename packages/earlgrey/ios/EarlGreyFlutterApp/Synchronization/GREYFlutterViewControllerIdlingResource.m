#import "GREYFlutterViewControllerIdlingResource.h"

#import <Flutter/Flutter.h>

#import "GREYUIThreadExecutor+Private.h"

static NSString *const kFirstFrameRenderingStateKey = @"displayingFlutterUI";

@implementation GREYFlutterViewControllerIdlingResource {
  __weak FlutterViewController *_weakFlutterViewController;
  BOOL _isSemanticsReady;
  BOOL _isFirstFrameRendered;
}

- (instancetype)initWithFlutterViewController:(FlutterViewController *)flutterViewController {
  self = [super init];
  if (self) {
    _weakFlutterViewController = flutterViewController;
    _isSemanticsReady = NO;
    _isFirstFrameRendered = flutterViewController.displayingFlutterUI;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSemanticsUpdateNotification:)
                                                 name:FlutterSemanticsUpdateNotification
                                               object:nil];
    [flutterViewController addObserver:self
                            forKeyPath:kFirstFrameRenderingStateKey
                               options:NSKeyValueObservingOptionNew
                               context:nil];
  }
  return self;
}

- (void)dealloc {
  [_weakFlutterViewController removeObserver:self forKeyPath:kFirstFrameRenderingStateKey];
}

- (BOOL)isIdleNow {
  FlutterViewController *flutterViewController = _weakFlutterViewController;
  if (!flutterViewController) {
    [[GREYUIThreadExecutor sharedInstance] deregisterIdlingResource:self];
    return YES;
  }
  return _isSemanticsReady && _isFirstFrameRendered;
}

- (NSString *)idlingResourceName {
  return @"FlutterViewControllerIdlingResource";
}

- (NSString *)idlingResourceDescription {
  NSMutableArray<NSString *> *descriptionArray = [NSMutableArray array];
  NSString *summary = [NSString
      stringWithFormat:@"Waiting for FlutterViewController <%@>:", _weakFlutterViewController];
  [descriptionArray addObject:summary];
  if (!_isSemanticsReady) {
    [descriptionArray addObject:@"-   Flutter semantics objects to be exposed."];
  }
  if (!_isFirstFrameRendered) {
    [descriptionArray addObject:@"-   Flutter first frame to be rendered."];
  }
  NSString *description = [descriptionArray componentsJoinedByString:@"\n"];
  return description;
}

- (void)handleSemanticsUpdateNotification:(NSNotification *)notification {
  if (notification.object == _weakFlutterViewController) {
    _isSemanticsReady = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FlutterSemanticsUpdateNotification
                                                  object:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
  if (object == _weakFlutterViewController) {
    _isFirstFrameRendered = _weakFlutterViewController.displayingFlutterUI;
  }
}

@end
