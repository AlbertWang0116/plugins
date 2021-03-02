#import <Foundation/Foundation.h>

#import "GREYFlutterAction.h"
#import "GREYConstants.h"
#import "GREYDefines.h"

NS_ASSUME_NONNULL_BEGIN

/** Shorthand macro for GREYFlutterActions::actionForTap. */
GREY_EXPORT id<GREYFlutterAction> GFFTap(void);

/** Shorthand macro for GREYFlutterActioons::actionForScrollInDrection:withAmount:. */
GREY_EXPORT id<GREYFlutterAction> GFFScroll(GREYDirection direction, CGFloat amount);

NS_ASSUME_NONNULL_END
