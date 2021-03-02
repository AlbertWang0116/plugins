#import "GREYDartVMServiceResponseParsingUtil.h"

#import "GREYJSONObjectUtil.h"

// TODO(b/135562951): All the NSCAssert in this file are model validation check. We should propagate
// them as error and handle (crash the app) at a single place.
NS_ASSUME_NONNULL_BEGIN

FBLPromise<GREYJSONValue> *GREYCheckIfJSONRpcResponseHasError(GREYJSONRpcResponse *response) {
  return [FBLPromise do:^id {
    GREYJSONDictionary *errorInfo = GREYDictionaryFromJSONValue(response.error);
    return !errorInfo ? response.result
                      : [NSError errorWithDomain:@"JSON-RPC completed with failure message."
                                            code:-1
                                        userInfo:errorInfo];
  }];
}

FBLPromise<GREYDartVMStatusResponse *> *GREYParseDartVMStatusResponse(
    GREYJSONRpcResponse *response) {
  return [GREYCheckIfJSONRpcResponseHasError(response) then:^id(GREYJSONValue jsonRpcResult) {
    GREYJSONDictionary *result = GREYDictionaryFromJSONValue(jsonRpcResult);
    NSCAssert([GREYStringFromJSONValue(result[@"type"]) isEqual:@"VM"],
              @"result is not VM type - %@", result.description);
    GREYDartVMStatusResponse *dartVMStatus =
        [[GREYDartVMStatusResponse alloc] initWithDictionary:result];
    NSCAssert(dartVMStatus.name, @"dartVMStatus doesn't have name, check result - %@",
              result.description);
    NSCAssert(dartVMStatus.isolateIDs,
              @"dartVMStatus has nil or empty isolateIDs, which is caused by invalid 'isolates'"
              @"field. check result - %@", result.description);

    return dartVMStatus;
  }];
}

FBLPromise<GREYDartIsolateStatusResponse *> *GREYParseDartIsolateStatusResponse(
    GREYJSONRpcResponse *response) {
  return
      [GREYCheckIfJSONRpcResponseHasError(response) then:^id(GREYJSONValue jsonRpcResult) {
        GREYJSONDictionary *result = GREYDictionaryFromJSONValue(jsonRpcResult);
        NSCAssert([GREYStringFromJSONValue(result[@"type"]) isEqual:@"Isolate"],
                  @"result is not Isolate type - %@", result.description);

        GREYDartIsolateStatusResponse *isolateStatus =
            [[GREYDartIsolateStatusResponse alloc] initWithDictionary:result];
        NSCAssert(isolateStatus.name, @"isolateStatus doesn't have name, check result - %@",
                  result.description);
        NSCAssert(isolateStatus.isolateID,
                  @"isolateStatus doesn't have isolateID, check result - %@", result.description);
        NSCAssert(isolateStatus.extensionRPCs,
                  @"isolateStatus has nil or empty extensionRPCs, check result - %@",
                  result.description);

        return isolateStatus;
      }];
}

FBLPromise<GREYJSONValue> *GREYCheckIfFlutterDriverResponseHasError(GREYJSONRpcResponse *response) {
  return
      [GREYCheckIfJSONRpcResponseHasError(response) then:^id(GREYJSONValue jsonRpcResult) {
        GREYJSONDictionary *result = GREYDictionaryFromJSONValue(jsonRpcResult);
        NSCAssert([GREYStringFromJSONValue(result[@"type"]) isEqual:@"_extensionType"],
                  @"result is not _extensionType type - %@", result.description);
        NSNumber *isError = GREYNumberFromJSONValue(result[@"isError"]);
        NSCAssert(isError, @"result doesn't have 'isError' field - %@", result.description);
        BOOL isErrorValue = [isError boolValue];
        GREYJSONValue driverResponse = result[@"response"];
        NSCAssert(driverResponse != nil, @"result doesn't have 'response' field - %@",
                  result.description);

        return !isErrorValue
                   ? driverResponse
                   : [NSError
                         errorWithDomain:@"Flutter Driver extension completed with failure message."
                                    code:-1
                                userInfo:@{@"message" : driverResponse}];
      }];
}

FBLPromise<NSNull *> *GREYParseFlutterDriverTapResponse(GREYJSONRpcResponse *response) {
  return [GREYCheckIfFlutterDriverResponseHasError(response) then:^id(GREYJSONValue jsonRpcResult) {
    return [NSNull null];
  }];
}

FBLPromise<NSNull *> *GREYParseFlutterDriverWaitResponse(GREYJSONRpcResponse *response) {
  return [GREYCheckIfFlutterDriverResponseHasError(response) then:^id(GREYJSONValue jsonRpcResult) {
    return [NSNull null];
  }];
}

NS_ASSUME_NONNULL_END
