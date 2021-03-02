#import "GREYDartIsolateStatusResponse.h"

#import "GREYJSONObjectUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYDartIsolateStatusResponse

- (instancetype)initWithDictionary:(GREYJSONDictionary *)params {
  self = [super init];
  if (self) {
    _name = [GREYStringFromJSONValue(params[@"name"]) copy];
    _isolateID = [GREYStringFromJSONValue(params[@"id"]) copy];
    NSArray<NSString *> *extensionRPCs = GREYArrayFromJSONValue(params[@"extensionRPCs"]);
    _extensionRPCs = [NSSet setWithArray:extensionRPCs];
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
