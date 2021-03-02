#import "GREYFlutterTestingProtocol.h"

#import "GREYDartVMService.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An implementation of GREYFlutterTestingProtocol which uses Dart VM service to interact with
 * Flutter application.
 */
@interface GREYDartVMServiceTestingProtocolImpl : NSObject <GREYFlutterTestingProtocol>

- (instancetype)init NS_UNAVAILABLE;

/**
 * Creates the instance with Dart VM service client @c dartVMService and @c isolateID which
 * idcates the Flutter app to communicate with.
 *
 * @param dartVMService The GREYDartVMService instance to interact with Dart VM.
 * @param isolateID The unique identifier of a Dart isolate.
 *
 * @return A GREYDartVMServiceTestingProtocolImpl instance.
 */
- (instancetype)initWithDartVMService:(id<GREYDartVMService>)dartVMService
                        withIsolateID:(NSString *)isolateID NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
