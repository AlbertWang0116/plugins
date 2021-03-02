#import "GREYFlutterAssertionsShorthand.h"

#import "GREYFlutterAssertions.h"

NS_ASSUME_NONNULL_BEGIN

id<GREYFlutterAssertion> GFFNotNil(void) {
  return [GREYFlutterAssertions assertionForNotNil];
}

id<GREYFlutterAssertion> GFFInScreen(void) { return [GREYFlutterAssertions assertionForInScreen]; }

NS_ASSUME_NONNULL_END
