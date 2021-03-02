#import "GREYFlutterInteractionProxy.h"

#import "GREYFlutterInteraction.h"
#import "GREYThrowDefines.h"
#import "GREYError.h"
#import "GREYElementInteractionErrorHandler.h"
#import "GREYRemoteExecutor.h"

@implementation GREYFlutterInteractionProxy {
  GREYFlutterInteraction *_remoteFlutterInteraction;
}

- (instancetype)initWithFlutterMatcher:(id<GREYFlutterMatcher>)matcher {
  GREYThrowOnNilParameterWithMessage(matcher, @"matcher can't be nil.");
  self = [super init];
  if (self) {
    _remoteFlutterInteraction = [[GREYFlutterInteraction alloc] initWithFlutterMatcher:matcher];
  }
  return self;
}

- (instancetype)performAction:(id<GREYFlutterAction>)action {
  return [self performAction:action error:nil];
}

- (instancetype)performAction:(id<GREYFlutterAction>)action
                        error:(__autoreleasing NSError **)errorOrNil {
  GREYThrowOnNilParameterWithMessage(action, @"Action can't be nil.");
  __block __strong GREYError *interactionError = nil;
  GREYExecuteSyncBlockInBackgroundQueue(^{
    [self->_remoteFlutterInteraction performAction:action error:&interactionError];
  });
  GREYHandleInteractionError(interactionError, errorOrNil);
  return self;
}

- (instancetype)assert:(id<GREYFlutterAssertion>)assertion {
  return [self assert:assertion error:nil];
}

- (instancetype)assert:(id<GREYFlutterAssertion>)assertion
                 error:(__autoreleasing NSError **)errorOrNil {
  GREYThrowOnNilParameterWithMessage(assertion, @"Assertion can't be nil.");
  __block __strong GREYError *interactionError = nil;
  GREYExecuteSyncBlockInBackgroundQueue(^{
    [self->_remoteFlutterInteraction assert:assertion error:&interactionError];
  });
  GREYHandleInteractionError(interactionError, errorOrNil);
  return self;
}

@end
