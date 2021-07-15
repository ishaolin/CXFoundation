//
//  CXKeychainQuery.h
//  Pods
//  
//  Created by wshaolin on 2017/8/30.
//

#import <Foundation/Foundation.h>
#import "CXKeychainError.h"

typedef NS_ENUM(NSUInteger, CXKeychainSyncMode) {
    CXKeychainSyncModeAny    = 0,
    CXKeychainSyncModeFalse  = 1,
    CXKeychainSyncModeTrue   = 2
};

@interface CXKeychainQuery : NSObject

@property (nonatomic, copy) NSString *key; // kSecAttrAccount
@property (nonatomic, copy) NSString *service; // kSecAttrService
@property (nonatomic, copy) NSString *label; // kSecAttrLabel

#if TARGET_OS_IPHONE
@property (nonatomic, copy) NSString *accessGroup; // kSecAttrAccessGroup
#endif

@property (nonatomic, assign) CXKeychainSyncMode syncMode; // kSecAttrSynchronizable

/**
 * Root storage for value data.
 */
@property (nonatomic, copy) NSData *data;

/**
 * This property automatically transitions between an object and the value of `data` using NSKeyedArchiver and NSKeyedUnarchiver.
 */
@property (nonatomic, copy) id<NSCoding> object;

/**
 * Convenience accessor for setting and getting a value string. Passes through to `data` using UTF-8 string encoding.
 */
@property (nonatomic, copy) NSString *value;

/**
 * Save the receiver's attributes as a keychain item. Existing items with the
 * given key(account), service(group), and access group will first be deleted.
 *
 * @param error Populated should an error occur.
 *
 * @return `YES` if saving was successful, `NO` otherwise.
 */
- (BOOL)save:(CXKeychainError *)error;

/**
 * Remove keychain items that match the given key(account), service(group), and access group.
 *
 * @param error Populated should an error occur.
 *
 * @return `YES` if saving was successful, `NO` otherwise.
 */
- (BOOL)remove:(CXKeychainError *)error;

/**
 * Fetch all keychain items that match the given key(account), service(group), and access
 * group. The values of `value` and `data` are ignored when fetching.
 *
 * @param error Populated should an error occur.
 *
 * @return An array of dictionaries that represent all matching keychain items or `nil` should an error occur.
 *
 * The order of the items is not determined.
 */
- (NSArray<NSDictionary<NSString *, id> *> *)fetchAll:(CXKeychainError *)error;

/**
 * Fetch the keychain item that matches the given key(account), service(group), and access group. The `value` and `data` properties will be populated unless an error occurs. The values of `value` and `data` are ignored when fetching.
 *
 * @param error Populated should an error occur.
 *
 * @return `YES` if fetching was successful, `NO` otherwise.
 */
- (BOOL)fetch:(CXKeychainError *)error;

#if __IPHONE_4_0 && TARGET_OS_IPHONE

/**
 * Returns the accessibility type for all future values saved to the Keychain.
 *
 * @return Returns the accessibility type. The return value will be `NULL` or one of the "Keychain Item Accessibility Constants" used for determining when a keychain item should be readable.
 *
 * @see setAccessibilityType
 */
+ (CFTypeRef)accessibilityType;

/**
 * Sets the accessibility type for all future values saved to the Keychain.
 *
 * @param accessibilityType One of the "Keychain Item Accessibility Constants" used for determining when a keychain item should be readable. If the value is `NULL` (the default), the Keychain default will be used.
 *
 * @see accessibilityType
 */
+ (void)setAccessibilityType:(CFTypeRef)accessibilityType;

#endif

@end
