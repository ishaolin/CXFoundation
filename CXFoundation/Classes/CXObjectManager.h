//
//  CXObjectManager.h
//  Pods
//
//  Created by wshaolin on 2021/7/15.
//

#import <Foundation/Foundation.h>

@interface CXObjectManager : NSObject

+ (BOOL)addObject:(NSObject *)object;
+ (void)removeObject:(NSObject *)object;
+ (BOOL)containsObject:(NSObject *)object;

@end
