#import "GREYFlutterActionsShorthand.h"

#import "GREYFlutterActions.h"

id<GREYFlutterAction> GFFTap(void) { return [GREYFlutterActions actionForTap]; }

id<GREYFlutterAction> GFFScroll(GREYDirection direction, CGFloat amount) {
  return [GREYFlutterActions actionForScrollInDirection:direction withAmount:amount];
}
