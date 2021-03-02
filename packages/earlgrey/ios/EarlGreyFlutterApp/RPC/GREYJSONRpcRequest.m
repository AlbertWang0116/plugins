#import "GREYJSONRpcRequest.h"

#import "GREYJSONObjectUtil.h"

@implementation GREYJSONRpcRequest

#pragma mark - Public

- (instancetype)initWithRequestID:(nullable GREYJSONValue)requestID
                       withMethod:(NSString *)method
                       withParams:(nullable GREYJSONValue)params {
  self = [super init];
  if (self) {
    _requestID = [(NSObject *)requestID copy];
    _method = [method copy];
    _params = [(NSObject *)params copy];
  }
  return self;
}

- (GREYJSONDictionary *)dictionaryValue {
  NSMutableDictionary<NSString *, GREYJSONValue> *dictionary = [@{} mutableCopy];
  dictionary[@"jsonrpc"] = @"2.0";
  NSString *method = self.method;
  GREYJSONValue params = self.params;
  GREYJSONValue requestID = self.requestID;
  if (requestID != nil) {
    dictionary[@"id"] = requestID;
  }
  dictionary[@"method"] = method;
  if (params != nil) {
    dictionary[@"params"] = params;
  }
  return [dictionary copy];
}

@end
