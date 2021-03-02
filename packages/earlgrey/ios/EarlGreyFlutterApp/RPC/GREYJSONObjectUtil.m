#import "GREYJSONObjectUtil.h"

NS_ASSUME_NONNULL_BEGIN

NS_INLINE BOOL GREYIsJSONDictionary(id value) { return [value isKindOfClass:[NSDictionary class]]; }

NS_INLINE BOOL GREYIsJSONArray(id value) { return [value isKindOfClass:[NSArray class]]; }

NS_INLINE BOOL GREYIsJSONString(id value) { return [value isKindOfClass:[NSString class]]; }

NS_INLINE BOOL GREYIsJSONNumber(id value) { return [value isKindOfClass:[NSNumber class]]; }

NS_INLINE BOOL GREYIsJSONNull(id value) { return value == nil || value == [NSNull null]; }

NSNumber *GREYNumberFromJSONValue(GREYJSONValue jsonValue) {
  return GREYIsJSONNumber(jsonValue) ? (NSNumber *)jsonValue : nil;
}

NSString *GREYStringFromJSONValue(GREYJSONValue jsonValue) {
  return GREYIsJSONString(jsonValue) ? (NSString *)jsonValue : nil;
}

NSArray *GREYArrayFromJSONValue(GREYJSONValue jsonValue) {
  return GREYIsJSONArray(jsonValue) ? (NSArray *)jsonValue : nil;
}

NSDictionary *GREYDictionaryFromJSONValue(GREYJSONValue jsonValue) {
  return GREYIsJSONDictionary(jsonValue) ? (NSDictionary *)jsonValue : nil;
}

void GREYValidateJSONRpcRequest(GREYJSONRpcRequest *request) {
  // TODO(b/135562951): Replace NSCAssert with throwing customized exception.
  id requestID = request.requestID;
  NSCAssert(GREYIsJSONNull(requestID) || GREYIsJSONString(requestID) || GREYIsJSONNumber(requestID),
            @"requestID should be string, number or null, found %@", [requestID class]);
  NSString *method = request.method;
  NSCAssert(method, @"method should not be non null string");
  NSCAssert(![method hasPrefix:@"rpc."], @"method prefix \"rpc.\" is reserved");
  id params = request.params;
  NSCAssert(GREYIsJSONNull(params) || [NSJSONSerialization isValidJSONObject:params],
            @"params should be valid JSON object, found: %@", params);
}

void GREYValidateJSONRpcResponse(GREYJSONRpcResponse *response) {
  // TODO(b/135562951): Replace NSCAssert with throwing customized exception.
  id requestID = response.requestID;
  NSCAssert(GREYIsJSONNull(requestID) || GREYIsJSONString(requestID) || GREYIsJSONNumber(requestID),
            @"requestID should be string, number or null, found %@", [requestID class]);
  id result = response.result;
  id error = response.error;
  NSCAssert((result != nil) ^ (error != nil),
            @"Exactly the one of result and error can be non-null, found result:%@ error:%@",
            result, error);
}

GREYJSONDictionary *GREYMergeJSONDictionaries(NSArray<GREYJSONDictionary *> *jsonDictionaries) {
  NSMutableDictionary<NSString *, GREYJSONValue> *result;
  for (NSDictionary<NSString *, GREYJSONValue> *jsonDictionary in jsonDictionaries) {
    if (!result) {
      result = [jsonDictionary mutableCopy];
    } else {
      [result addEntriesFromDictionary:jsonDictionary];
    }
  }
  return result;
}

NS_ASSUME_NONNULL_END
