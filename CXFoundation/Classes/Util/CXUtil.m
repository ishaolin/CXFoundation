//
//  CXUtil.m
//  Pods
//
//  Created by wshaolin on 2019/1/25.
//

#import "CXUtil.h"
#import <objc/message.h>

@implementation CXUtil

@end

BOOL CXArrayIsEmpty(NSArray *array){
    if(!array){
        return YES;
    }
    
    if(![array isKindOfClass:[NSArray class]]){
        return YES;
    }
    
    return array.count == 0;
}

BOOL CXDictionaryIsEmpty(NSDictionary *dictionary){
    if(!dictionary){
        return YES;
    }
    
    if(![dictionary isKindOfClass:[NSDictionary class]]){
        return YES;
    }
    
    return dictionary.count == 0;
}

BOOL CXSwizzleMethod(Class clazz, SEL originalSelector, SEL swizzledSelector, BOOL isClassSelector){
    Method swizzledMethod = isClassSelector ? class_getClassMethod(clazz, swizzledSelector) : class_getInstanceMethod(clazz, swizzledSelector);
    if(!swizzledMethod){
        return NO;
    }
    
    Method originalMethod = isClassSelector ? class_getClassMethod(clazz, originalSelector) : class_getInstanceMethod(clazz, originalSelector);
    if(!originalMethod){
        return NO;
    }
    
    class_addMethod(clazz,
                    originalSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(clazz,
                    swizzledSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    method_exchangeImplementations(originalMethod, swizzledMethod);
    return YES;
}

BOOL CXSwizzleClassMethod(Class clazz, SEL originalSelector, SEL swizzledSelector){
    return CXSwizzleMethod(clazz, originalSelector, swizzledSelector, YES);
}

BOOL CXSwizzleInstanceMethod(Class clazz, SEL originalSelector, SEL swizzledSelector){
    return CXSwizzleMethod(clazz, originalSelector, swizzledSelector, NO);
}
