#import "GREYFlutterMatchers.h"

#import "GREYFlutterMatcher+Private.h"
#import "GREYFlutterRuleMatcher.h"
#import "GREYThrowDefines.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kGREYFlutterMatcherFinderTypeKey = @"finderType";

@implementation GREYFlutterMatchers

+ (id<GREYFlutterMatcher>)matcherWithValueKey:(NSString *)key {
  GREYThrowOnFailedConditionWithMessage(key != nil, @"key should not be nil.");
  NSDictionary<NSString *, NSString *> *byValueKeyRules = @{
    kGREYFlutterMatcherFinderTypeKey : @"ByValueKey",
    @"keyValueType" : @"String",
    @"keyValueString" : key
  };
  return [[GREYFlutterRuleMatcher alloc] initWithRules:byValueKeyRules];
}

+ (id<GREYFlutterMatcher>)matcherWithTypeName:(NSString *)typeName {
  GREYThrowOnFailedConditionWithMessage(typeName, @"typeName should not be nil or empty.");
  NSDictionary<NSString *, NSString *> *byTypeNameRules =
      @{kGREYFlutterMatcherFinderTypeKey : @"ByType", @"type" : typeName};
  return [[GREYFlutterRuleMatcher alloc] initWithRules:byTypeNameRules];
}

+ (id<GREYFlutterMatcher>)matcherWithTooltip:(NSString *)tooltip {
  GREYThrowOnFailedConditionWithMessage(tooltip != nil, @"tooltip should not be nil.");
  NSDictionary<NSString *, NSString *> *byTooltipRules =
      @{kGREYFlutterMatcherFinderTypeKey : @"ByTooltipMessage", @"text" : tooltip};
  return [[GREYFlutterRuleMatcher alloc] initWithRules:byTooltipRules];
}

+ (id<GREYFlutterMatcher>)matcherWithText:(NSString *)text {
  GREYThrowOnFailedConditionWithMessage(text != nil, @"text should not be nil.");
  NSDictionary<NSString *, NSString *> *byTextRules =
      @{kGREYFlutterMatcherFinderTypeKey : @"ByText", @"text" : text};
  return [[GREYFlutterRuleMatcher alloc] initWithRules:byTextRules];
}

@end

NS_ASSUME_NONNULL_END
