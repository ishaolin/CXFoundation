//
//  CXUCryptor.m
//  Pods
//
//  Created by wshaolin on 2017/7/12.
//
//

#import "CXUCryptor.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation CXUCryptor

+ (NSString *)SHA1:(NSString *)string{
    if(!string){
        return nil;
    }
    
    const char *cString = [string UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cString, (CC_LONG)strlen(cString), result);
    
    NSMutableString *sha1String = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(NSInteger index = 0; index < CC_SHA1_DIGEST_LENGTH; index ++){
        [sha1String appendFormat:@"%02x", result[index]];
    }
    
    return [sha1String copy];
}

+ (NSString *)MD5:(NSString *)string{
    if(!string){
        return nil;
    }
    
    const char *cString = string.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger index = 0; index < CC_MD5_DIGEST_LENGTH; index ++){
        [mutableString appendFormat:@"%02x", result[index]];
    }
    
    return [mutableString copy];
}

+ (NSData *)encryptDataByAES128:(NSData *)data privateKey:(NSString *)key{
    return [self cryptDataByAES128:data operation:kCCEncrypt privateKey:key];
}

+ (NSData *)decryptDataByAES128:(NSData *)data privateKey:(NSString *)key{
    return [self cryptDataByAES128:data operation:kCCDecrypt privateKey:key];
}

+ (NSData *)cryptDataByAES128:(NSData *)data
                    operation:(CCOperation)operation
                   privateKey:(NSString *)key{
    if(!data || !key){
        return nil;
    }
    
    size_t dataOutAvailable = data.length + kCCBlockSizeAES128;
    void *dataOut = malloc(dataOutAvailable);
    size_t dataOutMoved = 0;
    
    if(CCCrypt(operation,
               kCCAlgorithmAES128,
               kCCOptionPKCS7Padding | kCCOptionECBMode,
               key.UTF8String,
               kCCBlockSizeAES128,
               NULL,
               data.bytes,
               data.length,
               dataOut,
               dataOutAvailable,
               &dataOutMoved) == kCCSuccess){
        // 自动free dataOut
        return [NSData dataWithBytesNoCopy:dataOut length:dataOutMoved];
    }
    
    free(dataOut);
    
    return nil;
}

+ (nullable NSData *)encryptDataBy3DES:(NSData *)data privateKey:(NSString *)key{
    return [self cryptDataBy3DES:data operation:kCCEncrypt privateKey:key];
}

+ (nullable NSData *)decryptDataBy3DES:(NSData *)data privateKey:(NSString *)key{
    return [self cryptDataBy3DES:data operation:kCCDecrypt privateKey:key];
}

+ (NSData *)cryptDataBy3DES:(NSData *)data
                  operation:(CCOperation)operation
                 privateKey:(NSString *)key{
    if(!data || !key){
        return nil;
    }
    
    size_t dataOutAvailable = (data.length + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    void *dataOut = malloc(dataOutAvailable);
    size_t dataOutMoved = 0;
    
    if(CCCrypt(operation,
               kCCAlgorithm3DES,
               kCCOptionPKCS7Padding | kCCOptionECBMode,
               key.UTF8String,
               kCCKeySize3DES,
               NULL,
               data.bytes,
               data.length,
               dataOut,
               dataOutAvailable,
               &dataOutMoved) == kCCSuccess){
        // 自动free dataOut
        return [NSData dataWithBytesNoCopy:dataOut length:dataOutMoved];
    }
    
    free(dataOut);
    
    return nil;
}

+ (nullable NSData *)encryptDataByRSA:(NSData *)data publicKey:(NSString *)key{
    if(!data){
        return nil;
    }
    
    SecKeyRef keyRef = CXGetRSAPublicKeyRef(key);
    if(keyRef == NULL){
        return nil;
    }
    
    size_t bufferSize = SecKeyGetBlockSize(keyRef);
    uint8_t *buffer = malloc(bufferSize * sizeof(uint8_t));
    size_t blockSize = bufferSize - 11;
    size_t blockCount = (size_t)ceil(data.length / (double)blockSize);
    
    NSMutableData *mutableData = [NSMutableData data];
    for(NSUInteger index = 0; index < blockCount; index ++){
        NSUInteger location = blockSize * index;
        NSUInteger length = MIN(blockSize, data.length - location);
        NSData *subData = [data subdataWithRange:NSMakeRange(location, length)];
        
        OSStatus status = SecKeyEncrypt(keyRef,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)subData.bytes,
                                        length,
                                        buffer,
                                        &bufferSize);
        
        if(status != noErr){
            CFRelease(keyRef);
            free(buffer);
            return nil;
        }
        
        NSData *bufferData = [[NSData alloc] initWithBytes:(const void *)buffer length:bufferSize];
        [mutableData appendData:bufferData];
    }
    
    CFRelease(keyRef);
    free(buffer);
    
    return [mutableData copy];
}

+ (nullable NSData *)decryptDataByRSA:(NSData *)data privateKey:(NSString *)key{
    if(!data){
        return nil;
    }
    
    SecKeyRef keyRef = CXGetRSAPrivateKeyRef(key);
    if(keyRef == NULL){
        return nil;
    }
    
    size_t bufferSize = SecKeyGetBlockSize(keyRef);
    size_t blockSize = bufferSize;
    size_t blockCount = (size_t)ceil(data.length / (double)blockSize);
    
    NSMutableData *mutableData = [NSMutableData data];
    for(NSUInteger index = 0; index < blockCount; index ++){
        NSUInteger location = blockSize * index;
        NSUInteger length = MIN(blockSize, data.length - location);
        
        void *bytes = malloc(length);
        [data getBytes:bytes range:NSMakeRange(location, length)];
        
        bufferSize = SecKeyGetBlockSize(keyRef);
        void *buffer = malloc(bufferSize);
        
        OSStatus status = SecKeyDecrypt(keyRef,
                                        kSecPaddingPKCS1,
                                        bytes,
                                        length,
                                        buffer,
                                        &bufferSize);
        free(bytes);
        if(status != noErr){
            free(buffer);
            CFRelease(keyRef);
            return nil;
        }
        
        // 自动free buffer
        NSData *bufferData = [[NSData alloc] initWithBytesNoCopy:(void *)buffer length:bufferSize];
        [mutableData appendData:bufferData];
    }
    
    CFRelease(keyRef);
    return [mutableData copy];
}

@end

SecKeyRef CXGetRSAPublicKeyRef(NSString *publicKey){
    if(!publicKey){
        return NULL;
    }
    
    NSData *tag = [[CXUCryptor MD5:publicKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{(__bridge id)kSecClass : (__bridge id)kSecClassKey,
                              (__bridge id)kSecAttrKeyType : (__bridge id)kSecAttrKeyTypeRSA,
                              (__bridge id)kSecAttrApplicationTag : tag,
                              (__bridge id)kSecReturnRef : @(YES)};
    
    SecKeyRef keyRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)options, (CFTypeRef *)&keyRef);
    if(status == noErr && keyRef != NULL){
        return keyRef;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:publicKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = CXRSAStripPublicKeyHeader(data);
    if(!data){
        return NULL;
    }
    
    options = @{(__bridge id)kSecClass : (__bridge id)kSecClassKey,
                (__bridge id)kSecAttrKeyType : (__bridge id)kSecAttrKeyTypeRSA,
                (__bridge id)kSecAttrApplicationTag : tag,
                (__bridge id)kSecAttrKeyClass : (__bridge id)kSecAttrKeyClassPublic,
                (__bridge id)kSecReturnPersistentRef : @(YES),
                (__bridge id)kSecValueData : data};
    
    status = SecItemAdd((__bridge CFDictionaryRef)options, NULL);
    if(status == noErr){
        return CXGetRSAPublicKeyRef(publicKey);
    }
    
    return NULL;
}

SecKeyRef CXGetRSAPrivateKeyRef(NSString *privateKey){
    if(!privateKey){
        return NULL;
    }
    
    NSData *tag = [[CXUCryptor MD5:privateKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{(__bridge id)kSecClass : (__bridge id)kSecClassKey,
                              (__bridge id)kSecAttrKeyType : (__bridge id)kSecAttrKeyTypeRSA,
                              (__bridge id)kSecAttrApplicationTag : tag,
                              (__bridge id)kSecReturnRef : @(YES)};
    SecKeyRef keyRef = NULL;
    if(SecItemCopyMatching((__bridge CFDictionaryRef)options, (CFTypeRef *)&keyRef) == noErr
       && keyRef != NULL){
        return keyRef;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:privateKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = CXRSAStripPrivateKeyHeader(data);
    if(!data){
        return NULL;
    }
    
    options = @{(__bridge id)kSecClass : (__bridge id)kSecClassKey,
                (__bridge id)kSecAttrKeyType : (__bridge id)kSecAttrKeyTypeRSA,
                (__bridge id)kSecReturnPersistentRef : @(YES),
                (__bridge id)kSecAttrApplicationTag : tag,
                (__bridge id)kSecAttrKeyClass : (__bridge id)kSecAttrKeyClassPrivate,
                (__bridge id)kSecValueData : data};
    
    if(SecItemAdd((__bridge CFDictionaryRef)options, NULL) == noErr){
        return CXGetRSAPrivateKeyRef(privateKey);
    }
    
    return NULL;
}

NSData *CXRSAStripPublicKeyHeader(NSData *data){
    if(!data || data.length == 0){
        return nil;
    }
    
    unsigned char *bytes = (unsigned char *)data.bytes;
    unsigned int idx = 0;
    
    if(bytes[idx ++] != 0x30){
        return nil;
    }
    
    if(bytes[idx] > 0x80){
        idx += bytes[idx] - 0x80 + 1;
    }else{
        idx ++;
    }
    
    static unsigned char seqiod[] = {0x30, 0x0D, 0x06, 0x09, 0x2A,
        0x86, 0x48, 0x86, 0xF7, 0x0D,
        0x01, 0x01, 0x01, 0x05, 0x00};
    if(memcmp(&bytes[idx], seqiod, 15)){
        return nil;
    }
    
    idx += 15;
    
    if(bytes[idx ++] != 0x03){
        return nil;
    }
    
    if(bytes[idx] > 0x80){
        idx += bytes[idx] - 0x80 + 1;
    }else{
        idx++;
    }
    
    if(bytes[idx ++] != '\0'){
        return nil;
    }
    
    return [NSData dataWithBytes:&bytes[idx] length:data.length - idx];
}

NSData *CXRSAStripPrivateKeyHeader(NSData *data){
    if(!data || data.length == 0){
        return nil;
    }
    
    unsigned char *bytes = (unsigned char *)data.bytes;
    unsigned int idx = 22;
    
    if(bytes[idx ++] != 0x04){
        return nil;
    }
    
    unsigned int length = bytes[idx++];
    if(!(length & 0x80)){
        length = length & 0x7F;
    }else{
        int count = length & 0x7F;
        if(count + idx > length){
            return nil;
        }
        
        unsigned int accum = 0;
        unsigned char *p = &bytes[idx];
        idx += count;
        while(count > 0){
            accum = (accum << 8) + *p;
            p ++;
            count --;
        }
        
        length = accum;
    }
    
    return [data subdataWithRange:NSMakeRange(idx, length)];
}
