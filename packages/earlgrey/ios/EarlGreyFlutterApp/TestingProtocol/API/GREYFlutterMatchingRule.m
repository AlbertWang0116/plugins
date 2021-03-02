#import "GREYFlutterMatchingRule.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYFlutterMatchingRule

- (instancetype)initWithRules:(GREYJSONDictionary *)rules {
  self = [super init];
  if (self) {
    _rules = [rules copy];
  }
  return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
  id copiedRule = [[[self class] alloc] initWithRules:_rules];
  return copiedRule;
}

- (BOOL)isEqual:(GREYFlutterMatchingRule *)anotherRule {
  if (![anotherRule isKindOfClass:[GREYFlutterMatchingRule class]]) {
    return NO;
  }
  return [self.rules isEqual:anotherRule.rules];
}

- (NSUInteger)hash {
  return [self.rules hash];
}

@end

NS_ASSUME_NONNULL_END
