//
//  NSLock+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2018/6/11.
//

#import <Foundation/Foundation.h>

@interface NSLock (CXExtensions)

- (void)cx_unlock:(float)delay;

@end
