#import "GREYFlutterSyntheticAction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYFlutterSyntheticAction

- (instancetype)initWithName:(NSString *)name withParams:(GREYJSONDictionary *)params {
  self = [super init];
  if (self) {
    _name = [name copy];
    _params = [params copy];
  }
  return self;
}

- (BOOL)isEqual:(GREYFlutterSyntheticAction *)anotherAction {
  if (![anotherAction isKindOfClass:[GREYFlutterSyntheticAction class]]) {
    return NO;
  }
  return [self.name isEqual:anotherAction.name] && [self.params isEqual:anotherAction.params];
}

@end

NS_ASSUME_NONNULL_END
