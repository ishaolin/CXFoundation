//
//  CXDispatchHandler.m
//  Pods
//
//  Created by wshaolin on 2018/7/23.
//

#import "CXDispatchHandler.h"

@implementation CXDispatchHandler

+ (void)asyncOnMainQueue:(dispatch_block_t)block{
    if(!block){
        return;
    }
    
    if([NSThread isMainThread]){
        block();
    }else{
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
