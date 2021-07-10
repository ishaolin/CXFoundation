//
//  CXFileHandler.h
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import <Foundation/Foundation.h>

#define CX_REMOVE_FILE(path)          [CXFileHandler removeFileAtPath:path]

@interface CXFileHandler : NSObject

+ (BOOL)removeFileAtPath:(NSString *)path;

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)error;

@end
