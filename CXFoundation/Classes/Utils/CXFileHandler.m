//
//  CXFileHandler.m
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import "CXFileHandler.h"
#import "CXStringUtils.h"

@implementation CXFileHandler

+ (BOOL)removeFileAtPath:(NSString *)path{
    return [self removeFileAtPath:path error:nil];
}

+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)error{
    if(CXStringIsEmpty(path)){
        return NO;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
    }
    
    return NO;
}

@end
