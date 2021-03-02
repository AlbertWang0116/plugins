#import "GREYJSONRpcResponse.h"

#import "GREYJSONObjectUtil.h"

// TODO(b/135627523): clean up other EG2 files or remove this.
NS_ASSUME_NONNULL_BEGIN

@implementation GREYJSONRpcResponse

- (instancetype)initWithDictionary:(GREYJSONDictionary *)dictionary {
  self = [super init];
  if (self) {
    _error = dictionary[@"error"];
    _requestID = dictionary[@"id"];
    _result = dictionary[@"result"];
  }
  return self;
}

- (GREYJSONDictionary *)dictionaryValue {
  NSMutableDictionary<NSString *, GREYJSONValue> *dictionary = [@{} mutableCopy];
  dictionary[@"jsonrpc"] = @"2.0";
  GREYJSONValue error = self.error;
  GREYJSONValue requestID = self.requestID;
  GREYJSONValue result = self.result;
  if (error) {
    dictionary[@"error"] = error;
  }
  if (requestID) {
    dictionary[@"id"] = requestID;
  }
  if (result) {
    dictionary[@"result"] = result;
  }
  return [dictionary copy];
}

@end

NS_ASSUME_NONNULL_END
