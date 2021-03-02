#import "GREYDartVMStatusResponse.h"

#import "GREYJSONObjectUtil.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GREYDartVMStatusResponse

- (instancetype)initWithDictionary:(GREYJSONDictionary *)params {
  self = [super init];
  if (self) {
    _name = [GREYStringFromJSONValue(params[@"name"]) copy];
    NSArray<GREYJSONDictionary *> *isolates = [GREYArrayFromJSONValue(params[@"isolates"]) copy];
    NSMutableArray<NSString *> *isolateIDs = [NSMutableArray arrayWithCapacity:isolates.count];
    for (GREYJSONDictionary *isolate in isolates) {
      NSString *isolateID = GREYStringFromJSONValue(isolate[@"id"]);
      if (!isolateID) {
        // isolateID should always be a string type, so any invalid field being passed here will
        // make self.isolateIDs revoled as nil.
        isolateIDs = nil;
        break;
      }
      [isolateIDs addObject:isolateID];
    }
    _isolateIDs = [isolateIDs copy];
  }
  return self;
}

@end

NS_ASSUME_NONNULL_END
