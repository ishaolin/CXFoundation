//
//  CXFoundationDefines.h
//  Pods
//
//  Created by wshaolin on 2017/6/15.
//
//

#ifndef CXFoundationDefines_h
#define CXFoundationDefines_h

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
#define CX_FOUNDATION_EXTERN   extern "C"
#else
#define CX_FOUNDATION_EXTERN   extern
#endif

#if defined(DEBUG) && !defined(NDEBUG)
#define keywordify autoreleasepool {}
#else
#define keywordify try {} @catch (...) {}
#endif

#define weakify(x)      keywordify               \
_Pragma("clang diagnostic push")                 \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__weak __typeof__(x) weak_##x = x;               \
_Pragma("clang diagnostic pop")

#define strongify(x)    keywordify               \
_Pragma("clang diagnostic push")                 \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(x) x = weak_##x;             \
_Pragma("clang diagnostic pop")

#define CXNotificationUserInfoKey0  @"INFO_KEY_0"
#define CXNotificationUserInfoKey1  @"INFO_KEY_1"
#define CXNotificationUserInfoKey2  @"INFO_KEY_2"

#define CX_BUNDLE_NAME_SUFFIX       @".bundle"
#define CX_FRAMEWORK_NAME_SUFFIX    @".framework"

typedef NSNotificationName CXNotificationName;

#endif /* CXFoundationDefines_h */
