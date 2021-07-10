//
//  CXDispatchHandler.h
//  Pods
//
//  Created by wshaolin on 2018/7/23.
//

#import <Foundation/Foundation.h>

@interface CXDispatchHandler : NSObject

+ (void)asyncOnMainQueue:(dispatch_block_t)block;

@end
