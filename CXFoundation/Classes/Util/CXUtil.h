//
//  CXUtil.h
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

@interface CXUtil : NSObject

@end

CX_FOUNDATION_EXTERN BOOL CXArrayIsEmpty(NSArray *array);

CX_FOUNDATION_EXTERN BOOL CXDictionaryIsEmpty(NSDictionary *dictionary);

CX_FOUNDATION_EXTERN BOOL CXSwizzleClassMethod(Class clazz,
                                               SEL originalSelector,
                                               SEL swizzledSelector);

CX_FOUNDATION_EXTERN BOOL CXSwizzleInstanceMethod(Class clazz,
                                                  SEL originalSelector,
                                                  SEL swizzledSelector);
