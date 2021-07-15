//
//  CXKeychainError.h
//  Pods
//
//  Created by wshaolin on 2017/8/30.
//
//

#ifndef CXKeychainError_h
#define CXKeychainError_h

#import <Security/Security.h>

typedef NS_ENUM(OSStatus, CXKeychainError){
    CXKeychainBadArguments          = errSecParam,
    CXKeychainAllocateFailed        = errSecAllocate,
    CXKeychainNotAvailable          = errSecNotAvailable,
    CXKeychainAuthFailed            = errSecAuthFailed,
    CXKeychainDuplicateItem         = errSecDuplicateItem,
    CXKeychainItemNotFound          = errSecItemNotFound,
    CXKeychainInteractionNotAllowed = errSecInteractionNotAllowed,
    CXKeychainDecodeFailed          = errSecDecode,
    CXKeychainUnimplemented         = errSecUnimplemented
};

#endif /* CXKeychainError_h */
