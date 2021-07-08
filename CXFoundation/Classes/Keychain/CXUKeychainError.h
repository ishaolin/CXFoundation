//
//  CXUKeychainError.h
//  Pods
//
//  Created by wshaolin on 2017/8/30.
//
//

#ifndef CXUKeychainError_h
#define CXUKeychainError_h

#import <Security/Security.h>

typedef NS_ENUM(OSStatus, CXUKeychainError){
    CXUKeychainBadArguments          = errSecParam,
    CXUKeychainAllocateFailed        = errSecAllocate,
    CXUKeychainNotAvailable          = errSecNotAvailable,
    CXUKeychainAuthFailed            = errSecAuthFailed,
    CXUKeychainDuplicateItem         = errSecDuplicateItem,
    CXUKeychainItemNotFound          = errSecItemNotFound,
    CXUKeychainInteractionNotAllowed = errSecInteractionNotAllowed,
    CXUKeychainDecodeFailed          = errSecDecode,
    CXUKeychainUnimplemented         = errSecUnimplemented
};

#endif /* CXUKeychainError_h */
