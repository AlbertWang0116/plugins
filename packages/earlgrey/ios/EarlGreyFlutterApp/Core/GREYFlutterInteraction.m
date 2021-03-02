#import "GREYFlutterInteraction.h"

#import <Flutter/Flutter.h>

#include <objc/runtime.h>

#import "GREYFlutterAction+Private.h"
#import "GREYFlutterAssertion+Private.h"
#import "GREYDartVMConnectionUtil.h"
#import "GREYDartVMService.h"
#import "GREYDartVMServiceImpl.h"
#import "GREYFlutterMatcher+Private.h"
#import "GREYJSONRpcClientImpl.h"
#import "GREYFlutterTestingProtocol.h"
#import "GREYDartVMServiceTestingProtocolImpl.h"
#import "GREYActionBlock.h"
#import "GREYElementInteraction.h"
#import "GREYAppError.h"
#import "GREYMatchers.h"
#import "GREYSyncAPI.h"
#import <PromisesObjc/FBLPromise+Testing.h>
#import <PromisesObjc/FBLPromises.h>

NS_ASSUME_NONNULL_BEGIN

static const NSUInteger kGREYFlutterAssertionNativeTimeout = 600;

NSURL *GREYWebSocketURLFromURL(NSURL *url);

@implementation GREYFlutterInteraction {
  id<GREYFlutterMatcher> _flutterMatcher;
}

#pragma mark - public

- (instancetype)initWithFlutterMatcher:(id<GREYFlutterMatcher>)matcher {
  NSAssert(matcher, @"matcher should not be nil.");
  self = [super init];
  if (self) {
    _flutterMatcher = matcher;
  }
  return self;
}

- (instancetype)performAction:(id<GREYFlutterAction>)action
                        error:(__autoreleasing NSError **)error {
  GREYElementInteraction *nativeInteraction =
      [[GREYElementInteraction alloc] initWithElementMatcher:[self matcherForFlutterView]];
  GREYActionBlock *flutterInteractionBlock = [GREYActionBlock
      actionWithName:@"FlutterInteractionPlaceholder"
         constraints:nil
        performBlock:^BOOL(UIView *flutterView, __strong NSError **errorOrNil) {
          GREYError *error;
          id<GREYFlutterTestingProtocol> testingProtocol =
              [self fetchTestingProtocolOnFlutterView:flutterView error:&error];
          if (error) {
            I_GREYPopulateError(errorOrNil, kGREYInteractionErrorDomain, error.code, error.domain);
            return NO;
          }

          return [action performAction:_flutterMatcher.matchingRule
                   withTestingProtocol:testingProtocol
                     withContainerView:flutterView
                                 error:errorOrNil];
        }];
  GREYError *interactionError;
  [nativeInteraction performAction:flutterInteractionBlock error:&interactionError];
  *error = interactionError;
  return self;
}

- (instancetype)assert:(id<GREYFlutterAssertion>)assertion error:(__autoreleasing NSError **)error {
  GREYElementInteraction *nativeInteraction =
      [[GREYElementInteraction alloc] initWithElementMatcher:[self matcherForFlutterView]];
  GREYActionBlock *flutterInteractionBlock = [GREYActionBlock
      actionWithName:@"FlutterInteractionPlaceholder"
         constraints:nil
        performBlock:^BOOL(UIView *flutterView, __strong NSError **errorOrNil) {
          GREYError *error;
          id<GREYFlutterTestingProtocol> testingProtocol =
              [self fetchTestingProtocolOnFlutterView:flutterView error:&error];
          if (error) {
            I_GREYPopulateError(errorOrNil, kGREYInteractionErrorDomain, error.code, error.domain);
            return NO;
          }

          return [assertion assert:_flutterMatcher.matchingRule
               withTestingProtocol:testingProtocol
                             error:errorOrNil];
        }];
  GREYError *interactionError;
  [nativeInteraction performAction:flutterInteractionBlock error:&interactionError];
  *error = interactionError;
  return self;
}

#pragma mark - private

- (id<GREYFlutterTestingProtocol>)fetchTestingProtocolOnFlutterView:(UIView *)flutterView
                                                              error:(NSError **)error {
  GREYError *flutterError;
  id<GREYDartVMService> dartVMService = [self fetchDartVMServiceWithError:&flutterError];
  if (flutterError) {
    *error = flutterError;
    return nil;
  }
  FBLPromise<NSArray<GREYDartIsolateStatusResponse *> *> *dartIsolatesPromise =
      [dartVMService fetchDartIsolatesStatus];
  grey_check_condition_until_timeout(
      ^BOOL {
        return !dartIsolatesPromise.isPending;
      },
      kGREYFlutterAssertionNativeTimeout);
  NSArray<GREYDartIsolateStatusResponse *> *dartIsolates =
      FBLPromiseAwait(dartIsolatesPromise, &flutterError);
  if (flutterError) {
    *error = flutterError;
    return nil;
  }

  NSMutableDictionary<NSString *, GREYDartIsolateStatusResponse *> *flutterIsolates =
      [NSMutableDictionary dictionary];
  for (GREYDartIsolateStatusResponse *dartIsolate in dartIsolates) {
    if ([self driverExistInIsolate:dartIsolate]) {
      flutterIsolates[dartIsolate.isolateID] = dartIsolate;
    }
  }
  if (flutterIsolates.count == 0) {
    *error = [NSError errorWithDomain:@"Flutter app doesn't listen to Flutter driver extension "
                                      @"request, which is mandatory for UI test."
                                 code:-1
                             userInfo:nil];
    return nil;
  }

  FlutterEngine *engine = objc_getAssociatedObject(flutterView, @selector(engine));
  NSString *isolateID = engine.isolateId;
  GREYDartVMServiceTestingProtocolImpl *testingProtocol =
      [[GREYDartVMServiceTestingProtocolImpl alloc] initWithDartVMService:dartVMService
                                                            withIsolateID:isolateID];
  return testingProtocol;
}

- (id<GREYDartVMService>)fetchDartVMServiceWithError:(NSError **)error {
  NSURL *observatoryURL = [GREYDartVMConnectionUtil sharedInstance].observatoryURL;
  if (!observatoryURL) {
    *error = [NSError errorWithDomain:@"There is no active Flutter in this app."
                                 code:-1
                             userInfo:nil];
    return nil;
  }

  GREYJSONRpcClientImpl *jsonRpcClient =
      [[GREYJSONRpcClientImpl alloc] initWithURL:GREYWebSocketURLFromURL(observatoryURL)];
  [jsonRpcClient open];

  return [[GREYDartVMServiceImpl alloc] initWithJSONRpcClient:jsonRpcClient];
}

- (BOOL)driverExistInIsolate:(GREYDartIsolateStatusResponse *)isolate {
  return [isolate.extensionRPCs containsObject:@"ext.flutter.driver"];
}

- (id<GREYMatcher>)matcherForFlutterView {
  return [GREYMatchers matcherForKindOfClassName:@"FlutterView"];
}

@end

NS_ASSUME_NONNULL_END
