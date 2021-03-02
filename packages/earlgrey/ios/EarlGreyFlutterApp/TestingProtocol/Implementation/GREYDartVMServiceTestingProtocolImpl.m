#import "GREYDartVMServiceTestingProtocolImpl.h"

#import "GREYDartVMService.h"
#import "GREYJSONObjectUtil.h"
#import "GREYJSONValue.h"
#import "GREYFlutterWidgetInfo.h"
#import "GREYError.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kSynchronizationCommand = @"waitUntilNoTransientCallback";
static NSString *const kFetchDiagnosticTreeNodeCommand = @"get_diagnostics_tree";
static NSString *const kFetchLocationCommand = @"get_offset";

/**
 * Adds new entry into @c widgetInfo with key @c fieldName if @c fieldValue is not nil.
 */
void GREYFillWidgetInfo(NSMutableDictionary<NSString *, GREYJSONValue> *widgetInfo,
                        NSString *fieldName, GREYJSONValue fieldValue);

@implementation GREYDartVMServiceTestingProtocolImpl {
  id<GREYDartVMService> _dartVMService;
  NSString *_isolateID;
}

- (instancetype)initWithDartVMService:(id<GREYDartVMService>)dartVMService
                        withIsolateID:(NSString *)isolateID {
  self = [super init];
  if (self) {
    _dartVMService = dartVMService;
    _isolateID = isolateID;
  }
  return self;
}

- (FBLPromise<NSNull *> *)synchronize {
  FBLPromise<GREYJSONValue> *promise =
      [_dartVMService invokeFlutterDriverCommand:kSynchronizationCommand
                                onFlutterIsolate:_isolateID
                                      withParams:@{}];
  return [promise then:^id(GREYJSONValue response) {
    return [NSNull null];
  }];
}

- (FBLPromise<GREYFlutterWidgetInfo *> *)matchWidget:(GREYFlutterMatchingRule *)matchingRule {
  NSArray<FBLPromise<GREYJSONDictionary *> *> *batchRequests = @[
    [self fetchWidgetDiagnosticsNode:matchingRule], [self fetchWidgetTopLeft:matchingRule],
    [self fetchWidgetBottomRight:matchingRule]
  ];
  FBLPromise<NSArray<GREYJSONDictionary *> *> *promise = [FBLPromise all:batchRequests];
  return [promise then:^id(NSArray<GREYJSONDictionary *> *results) {
    GREYJSONDictionary *widgetObject = GREYMergeJSONDictionaries(results);
    return [[GREYFlutterWidgetInfo alloc] initWithWidgetInfoJSONObject:widgetObject];
  }];
}

- (FBLPromise<NSNull *> *)performAction:(GREYFlutterSyntheticAction *)action
                       withMatchingRule:(GREYFlutterMatchingRule *)matchingRule {
  // TODO(b/138121992): Other than passing the [ara,eters directly to Dart VM service, testing
  // protocol should translate and validate the input.
  NSMutableDictionary<NSString *, GREYJSONValue> *mutableParams =
      [NSMutableDictionary dictionaryWithDictionary:action.params];
  [mutableParams addEntriesFromDictionary:matchingRule.rules];
  FBLPromise<GREYJSONValue> *promise =
      [_dartVMService invokeFlutterDriverCommand:action.name
                                onFlutterIsolate:_isolateID
                                      withParams:mutableParams];
  return [promise then:^id(GREYJSONValue response) {
    return [NSNull null];
  }];
}

#pragma mark - Private

- (FBLPromise<GREYJSONDictionary *> *)fetchWidgetDiagnosticsNode:(GREYFlutterMatchingRule *)rule {
  GREYJSONDictionary *diagnosticNodeParams =
      @{@"diagnosticsType" : @"widget", @"subtreeDepth" : @(0), @"includeProperties" : @(YES)};
  GREYJSONDictionary *params = GREYMergeJSONDictionaries(@[ diagnosticNodeParams, rule.rules ]);
  FBLPromise<GREYJSONValue> *promise =
      [_dartVMService invokeFlutterDriverCommand:kFetchDiagnosticTreeNodeCommand
                                onFlutterIsolate:_isolateID
                                      withParams:params];
  return [promise then:^id(GREYJSONValue response) {
    GREYJSONDictionary *diagnosticWidget = GREYDictionaryFromJSONValue(response);
    NSString *runtimeType = GREYStringFromJSONValue(diagnosticWidget[@"widgetRuntimeType"]);
    if (!runtimeType) {
      return GREYErrorMake(@"com.google.earlgrey.flutter", 0,
                           @"runtime type should appear in diagnositic node.");
    }
    NSMutableDictionary<NSString *, GREYJSONValue> *properties =
        [NSMutableDictionary dictionary];
    for (GREYJSONValue property in GREYArrayFromJSONValue(
             diagnosticWidget[@"properties"])) {
      GREYJSONDictionary *json = GREYDictionaryFromJSONValue(property);
      NSString *name = GREYStringFromJSONValue(json[@"name"]);
      GREYJSONValue value = json[@"value"];
      if (name && value && value != [NSNull null]) {
        properties[name] = value;
      }
    }
    NSMutableDictionary<NSString *, GREYJSONValue> *widgetObject =
        [NSMutableDictionary dictionary];
    widgetObject[@"runtime_type"] = runtimeType;
    if ([runtimeType isEqual:@"Text"]) {
      GREYFillWidgetInfo(widgetObject, @"text", GREYStringFromJSONValue(properties[@"data"]));
    }
    if ([runtimeType isEqual:@"RichText"]) {
      GREYFillWidgetInfo(widgetObject, @"text", GREYStringFromJSONValue(properties[@"text"]));
    }
    GREYFillWidgetInfo(widgetObject, @"tooltip", GREYStringFromJSONValue(properties[@"tooltip"]));
    return widgetObject;
  }];
}

- (FBLPromise<GREYJSONDictionary *> *)fetchWidgetTopLeft:(GREYFlutterMatchingRule *)rule {
  return [self fetchWidgetLocationWithMatchingRule:rule
                                    withOffsetType:@"topLeft"
                                   withDxFieldName:@"left"
                                   withDyFieldName:@"top"];
}

- (FBLPromise<GREYJSONDictionary *> *)fetchWidgetBottomRight:(GREYFlutterMatchingRule *)rule {
  return [self fetchWidgetLocationWithMatchingRule:rule
                                    withOffsetType:@"bottomRight"
                                   withDxFieldName:@"right"
                                   withDyFieldName:@"bottom"];
}

- (FBLPromise<GREYJSONDictionary *> *)fetchWidgetLocationWithMatchingRule:
                                          (GREYFlutterMatchingRule *)rule
                                                           withOffsetType:(NSString *)offsetType
                                                          withDxFieldName:(NSString *)dxFieldName
                                                          withDyFieldName:(NSString *)dyFieldName {
  GREYJSONDictionary *offsetTypeParams = @{@"offsetType" : offsetType};
  GREYJSONDictionary *params = GREYMergeJSONDictionaries(@[ offsetTypeParams, rule.rules ]);
  FBLPromise<GREYJSONValue> *promise =
      [_dartVMService invokeFlutterDriverCommand:kFetchLocationCommand
                                onFlutterIsolate:_isolateID
                                      withParams:params];
  return [promise then:^id(GREYJSONValue response) {
    GREYJSONDictionary *locationInfo = GREYDictionaryFromJSONValue(response);
    NSMutableDictionary<NSString *, GREYJSONValue> *widgetObject =
        [NSMutableDictionary dictionary];
    GREYFillWidgetInfo(widgetObject, dxFieldName, locationInfo[@"dx"]);
    GREYFillWidgetInfo(widgetObject, dyFieldName, locationInfo[@"dy"]);
    return widgetObject;
  }];
}

@end

void GREYFillWidgetInfo(NSMutableDictionary<NSString *, GREYJSONValue> *widgetInfo,
                        NSString *fieldName, GREYJSONValue fieldValue) {
  if (fieldName) {
    widgetInfo[fieldName] = fieldValue;
  }
}

NS_ASSUME_NONNULL_END
