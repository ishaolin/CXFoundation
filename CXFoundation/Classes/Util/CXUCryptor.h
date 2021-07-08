//
//  CXUCryptor.h
//  Pods
//
//  Created by wshaolin on 2017/7/12.
//
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXUCryptor : NSObject

+ (NSString *)SHA1:(NSString *)string;

+ (NSString *)MD5:(NSString *)string;

+ (nullable NSData *)encryptDataByAES128:(NSData *)data privateKey:(NSString *)key;

+ (nullable NSData *)decryptDataByAES128:(NSData *)data privateKey:(NSString *)key;

+ (nullable NSData *)encryptDataBy3DES:(NSData *)data privateKey:(NSString *)key;

+ (nullable NSData *)decryptDataBy3DES:(NSData *)data privateKey:(NSString *)key;

+ (nullable NSData *)encryptDataByRSA:(NSData *)data publicKey:(NSString *)key;

+ (nullable NSData *)decryptDataByRSA:(NSData *)data privateKey:(NSString *)key;

@end

SecKeyRef _Nullable CXGetRSAPublicKeyRef(NSString *publicKey);
SecKeyRef _Nullable CXGetRSAPrivateKeyRef(NSString *privateKey);

NSData * _Nullable CXRSAStripPublicKeyHeader(NSData *data);
NSData * _Nullable CXRSAStripPrivateKeyHeader(NSData *data);

NS_ASSUME_NONNULL_END
