//
//  NSCharacterSet+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (CXExtensions)

// encode完整的url，包括：'://=&?/#%'等
@property (class, nonatomic, copy, readonly) NSCharacterSet *cx_URLWholeAllowedCharacterSet;

@end
