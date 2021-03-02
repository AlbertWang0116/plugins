#import "EarlGreyImpl+Flutter.h"

NS_ASSUME_NONNULL_BEGIN

@implementation EarlGreyImpl (Flutter)

- (GREYFlutterInteractionProxy *)onFlutterWidget:(id<GREYFlutterMatcher>)matcher {
  return [[GREYFlutterInteractionProxy alloc] initWithFlutterMatcher:matcher];
}

@end

NS_ASSUME_NONNULL_END
