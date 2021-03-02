#import <Foundation/Foundation.h>

/**
 * The type of deserialized JSON data, it will be the one of NSNull, NSNumber, NSString, NSArray or
 * NSDictionary.
 */
typedef id<NSCoding, NSCopying> GREYJSONValue;

/** The type of deserialized JSON dictionary-data, represented as NSDictionary in Objective-C. */
typedef NSDictionary<NSString *, GREYJSONValue> GREYJSONDictionary;
