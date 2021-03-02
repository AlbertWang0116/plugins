#import "GREYFlutterBlockAssertion.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYFlutterBlockAssertion {
  NSString *_name;
  GREYFlutterAssertionBlock _assertionBlock;
}

@synthesize name = _name;

- (instancetype)initWithName:(NSString *)name withAssertionBlock:(GREYFlutterAssertionBlock)block {
  self = [super init];
  if (self) {
    _name = [name copy];
    _assertionBlock = [block copy];
  }
  return self;
}

- (BOOL)assert:(GREYFlutterMatchingRule *)matchingRule
    withTestingProtocol:(id<GREYFlutterTestingProtocol>)testingProtocol
                  error:(__strong NSError **)errorOrNil {
  return _assertionBlock(matchingRule, testingProtocol, errorOrNil);
}

@end

NS_ASSUME_NONNULL_END
