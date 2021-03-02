#import "GREYFlutterWidgetInfo.h"

#import "GREYJSONObjectUtil.h"
#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/** Constructs the bounding box of Flutter widget from @c widgetInfo. */
static CGRect ConstructRect(GREYJSONDictionary *widgetInfo) {
  CGFloat top = [GREYNumberFromJSONValue(widgetInfo[@"top"]) floatValue];
  CGFloat bottom = [GREYNumberFromJSONValue(widgetInfo[@"bottom"]) floatValue];
  CGFloat left = [GREYNumberFromJSONValue(widgetInfo[@"left"]) floatValue];
  CGFloat right = [GREYNumberFromJSONValue(widgetInfo[@"right"]) floatValue];
  if (bottom >= top && right >= left) {
    return CGRectMake(left, top, right - left, bottom - top);
  } else {
    return CGRectZero;
  }
}

@implementation GREYFlutterWidgetInfo

- (instancetype)initWithWidgetInfoJSONObject:(GREYJSONDictionary *)widgetInfo {
  self = [super init];
  if (self) {
    _key = GREYStringFromJSONValue(widgetInfo[@"key"]);
    _runtimeType = GREYStringFromJSONValue(widgetInfo[@"runtimeType"]);
    _tooltip = GREYStringFromJSONValue(widgetInfo[@"tooltip"]);
    _text = GREYStringFromJSONValue(widgetInfo[@"text"]);
    _rect = ConstructRect(widgetInfo);
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
