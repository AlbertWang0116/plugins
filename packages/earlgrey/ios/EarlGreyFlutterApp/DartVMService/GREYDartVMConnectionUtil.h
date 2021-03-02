#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * This class contains the connection arguments to the only Dart VM that runs on the iOS app. The
 * value we need, observatory URL, is exposed by active FlutterEngine instance and there is only
 * one such value per iOS application. As the result, this class listenes on the initialization
 * of FlutterEngine and weakly holds each instance. Once the information is exposed by any
 * FlutterEngine, it holds the value and releases all the weak holds on FlutterEngine.
 */
@interface GREYDartVMConnectionUtil : NSObject

/**
 * The URL that the Dart VM service is listening on.
 */
@property(nonatomic, readonly, nullable) NSURL *observatoryURL;

/**
 * Gets the singleton instance of this class.
 */
+ (GREYDartVMConnectionUtil *)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
