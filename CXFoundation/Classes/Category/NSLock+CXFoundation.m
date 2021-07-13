//
//  NSLock+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2018/6/11.
//

#import "NSLock+CXFoundation.h"

@implementation NSLock (CXFoundation)

- (void)cx_unlock:(float)delay{
    if(delay > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self unlock];
        });
    }else{
        [self unlock];
    }
}

@end
