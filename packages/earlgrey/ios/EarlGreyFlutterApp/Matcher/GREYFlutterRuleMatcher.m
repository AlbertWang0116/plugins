#import "GREYFlutterRuleMatcher.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYFlutterRuleMatcher {
  GREYFlutterMatchingRule *_matchingRule;
}

@synthesize matchingRule = _matchingRule;

- (instancetype)initWithRules:(GREYJSONDictionary *)rules {
  self = [super init];
  if (self) {
    _matchingRule = [[GREYFlutterMatchingRule alloc] initWithRules:rules];
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
