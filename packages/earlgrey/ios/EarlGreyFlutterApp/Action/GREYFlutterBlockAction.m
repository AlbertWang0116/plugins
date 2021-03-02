#import "GREYFlutterBlockAction.h"

@implementation GREYFlutterBlockAction {
  // The value for GREYFlutterAction::name property.
  NSString *_name;
  // A block that contains the action to execute.
  GREYFlutterActionBlock _actionBlock;
}

@synthesize name = _name;

- (instancetype)initWithName:(NSString *)name withActionBlock:(GREYFlutterActionBlock)block {
  self = [super init];
  if (self) {
    _name = [name copy];
    _actionBlock = [block copy];
  }
  return self;
}

- (BOOL)performAction:(GREYFlutterMatchingRule *)matchingRule
    withTestingProtocol:(id<GREYFlutterTestingProtocol>)testingProtocol
      withContainerView:(UIView *)containerView
                  error:(__strong NSError **)errorOrNil {
  return _actionBlock(matchingRule, testingProtocol, containerView, errorOrNil);
}

@end
