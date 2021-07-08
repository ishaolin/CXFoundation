//
//  CXUKeychain.h
//  Pods
//
//  Created by wshaolin on 2017/8/30.
//

#import <Foundation/Foundation.h>
#import "CXUKeychainError.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXUKeychain : NSObject

/**
 * Returns a string containing the value(password) for a given key(account) and service(group), or `nil` if the Keychain doesn't have a value(password) for the given parameters.
 *
 * @param key The key(account) for which to return the corresponding value(password).
 * @param service The service(group) for which to return the corresponding value(password).
 *
 * @return Returns a string containing the value(password) for a given key(account) and service(group), or `nil` if the Keychain doesn't have a value(password) for the given parameters.
 */
+ (nullable NSString *)stringForKey:(NSString *)key service:(NSString *)service;
+ (nullable NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(CXUKeychainError * _Nullable)error;

/**
 * Returns a data containing the value(password) for a given key(account) and service(group), or `nil` if the Keychain doesn't have a value(password) for the given parameters.
 *
 * @param key The key(account) for which to return the corresponding value(password).
 * @param service The service(group) for which to return the corresponding value(password).
 *
 * @return Returns a data containing the value(password) for a given key(account) and service(group), or `nil` if the Keychain doesn't have a value(password) for the given parameters.
 */
+ (nullable NSData *)dataForKey:(NSString *)key service:(NSString *)service;
+ (nullable NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(CXUKeychainError * _Nullable)error;

/**
 * Removes a value(password) from the Keychain.
 *
 * @param key The key(account) for which to delete the corresponding value(password).
 * @param service The service(group) for which to delete the corresponding value(password).
 *
 * @return Returns `YES` on success, or `NO` on failure.
 */
+ (BOOL)removeForKey:(NSString *)key service:(NSString *)service;
+ (BOOL)removeForKey:(NSString *)key service:(NSString *)service error:(CXUKeychainError * _Nullable)error;

/**
 * Sets a string value(password) in the Keychain.
 *
 * @param value The value(password)  to store in the Keychain.
 * @param key The key(account) for which to set the corresponding value(password).
 * @param service The service(group) for which to set the corresponding value(password).
 *
 * @return Returns `YES` on success, or `NO` on failure.
 */
+ (BOOL)setValue:(NSString *)value forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setValue:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(CXUKeychainError * _Nullable)error;

/**
 * Sets a data value(password) in the Keychain.
 *
 * @param data The value(password)  to store in the Keychain.
 * @param key The key(account) for which to set the corresponding value(password).
 * @param service The service(group) for which to set the corresponding value(password).
 *
 * @return Returns `YES` on success, or `NO` on failure.
 */
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(CXUKeychainError * _Nullable)error;

/**
 * Returns an array containing the Keychain's keys(accounts), or `nil` if the Keychain has no keys(accounts).
 *
 * @return An array of dictionaries containing the Keychain's keys(accounts), or `nil` if the Keychain doesn't have any keys(accounts). The order of the objects in the array isn't defined.
 */
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts;
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(CXUKeychainError * _Nullable)error;

/**
 * Returns an array containing the Keychain's keys(accounts) for a given service(group), or `nil` if the Keychain doesn't have any keys(accounts) for the given service(group).
 *
 * @param service The service(group) for which to return the corresponding accounts.
 
 * @return An array of dictionaries containing the Keychain's keys(accounts) for a given `service`, or `nil` if the Keychain doesn't have any keys(accounts) for the given `service`. The order of the objects in the array isn't defined.
 */
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)service;
+ (nullable NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(nullable NSString *)service error:(CXUKeychainError * _Nullable)error;

#if __IPHONE_4_0 && TARGET_OS_IPHONE

/**
 * Returns the accessibility type for all future passwords saved to the Keychain.
 *
 * @return Returns the accessibility type. The return value will be `NULL` or one of the "Keychain Item Accessibility Constants" used for determining when a keychain item should be readable.
 *
 * @see setAccessibilityType
 */
+ (CFTypeRef _Nullable)accessibilityType;

/**
 * Sets the accessibility type for all future passwords saved to the Keychain.
 *
 * @param accessibilityType One of the "Keychain Item Accessibility Constants" used for determining when a keychain item should be readable. If the value is `NULL` (the default), the Keychain default will be used.
 *
 * @see accessibilityType
 */
+ (void)setAccessibilityType:(CFTypeRef _Nullable)accessibilityType;

#endif

@end

NS_ASSUME_NONNULL_END
