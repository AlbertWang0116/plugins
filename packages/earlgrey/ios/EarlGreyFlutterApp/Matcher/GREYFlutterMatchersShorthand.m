#import "GREYFlutterMatchersShorthand.h"

#import "GREYFlutterMatchers.h"

NS_ASSUME_NONNULL_BEGIN

id<GREYFlutterMatcher> GFFWithValueKey(NSString *key) {
  return [GREYFlutterMatchers matcherWithValueKey:key];
}

id<GREYFlutterMatcher> GFFWithTypeName(NSString *typeName) {
  return [GREYFlutterMatchers matcherWithTypeName:typeName];
}

id<GREYFlutterMatcher> GFFWithTooltip(NSString *tooltip) {
  return [GREYFlutterMatchers matcherWithTooltip:tooltip];
}

id<GREYFlutterMatcher> GFFWithText(NSString *text) {
  return [GREYFlutterMatchers matcherWithText:text];
}

NS_ASSUME_NONNULL_END
