#import <UIKit/UIKit.h>

#import "GREYJSONValue.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An entity class that contains the serializable properties of a Flutter widget.
 */
@interface GREYFlutterWidgetInfo : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates a GREYFlutterWidgetInfo with @c widgetInfo.
 *
 * @param widgetInfo A JSON object that contains the properties' name/value pair of a widget.
 * @return A GREYFlutterWidgetInfo instance.
 *
 * @note This initializer expects @c widgetInfo optionally containing the following keys:
 *       @"key": Will be parsed to GREYFlutterWidgetInfo::key.
 *       @"runtimeType": Will be parsed to GREYFlutterWidgetInfo::runtimeType.
 *       @"tooltip": Will be parsed to GREYFlutterWidgetInfo::tooltip.
 *       @"text": Will be parsed to GREYFlutterWidgetInfo::text.
 *       @"left", @"right", @"top", @"bottom": Will be parsed to GREYFlutterWidgetInfo::rect.
 */
- (instancetype)initWithWidgetInfoJSONObject:(GREYJSONDictionary *)widgetInfo
    NS_DESIGNATED_INITIALIZER;

/**
 * The key property of a Flutter widget.
 */
@property(nonatomic, readonly, nullable) NSString *key;

/**
 * The name of Dart runtime type of a Flutter widget.
 */
@property(nonatomic, readonly, nullable) NSString *runtimeType;

/**
 * The tooltip property of a Flutter widget.
 */
@property(nonatomic, readonly, nullable) NSString *tooltip;

/**
 * The data property of a text Flutter widget.
 */
@property(nonatomic, readonly, nullable) NSString *text;

/**
 * The frame of the Flutter widget in screen coordinate.
 */
@property(nonatomic, readonly) CGRect rect;

@end

NS_ASSUME_NONNULL_END
