#import <Foundation/Foundation.h>

#import "GREYFlutterMatcher.h"
#import "GREYDefines.h"

NS_ASSUME_NONNULL_BEGIN

/** Shortcuts macro for GREYFlutterMatchers::matcherForValueKey. */
GREY_EXPORT id<GREYFlutterMatcher> GFFWithValueKey(NSString *key);

/** Shortcuts macro for GREYFlutterMatchers::matcherForTypeName. */
GREY_EXPORT id<GREYFlutterMatcher> GFFWithTypeName(NSString *typeName);

/** Shortcuts macro for GREYFlutterMatchers::matcherWithTooltip. */
GREY_EXPORT id<GREYFlutterMatcher> GFFWithTooltip(NSString *tooltip);

/** Shortcuts macro for GREYFlutterMatchers::matcherWithText. */
GREY_EXPORT id<GREYFlutterMatcher> GFFWithText(NSString *text);

NS_ASSUME_NONNULL_END
