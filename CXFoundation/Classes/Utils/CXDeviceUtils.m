//
//  CXDeviceUtils.m
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import "CXDeviceUtils.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "NSDictionary+CXExtensions.h"

@implementation CXDeviceUtils

+ (uint64_t)freeDiskSpaceInBytes{
    NSDictionary<NSFileAttributeKey, id> *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    if(attributes){
        return [attributes cx_numberForKey:NSFileSystemFreeSize].unsignedLongLongValue;
    }
    
    return 0;
}

+ (uint64_t)totalDiskSpaceInBytes{
    NSDictionary<NSFileAttributeKey, id> *attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    if(attributes){
        return [attributes cx_numberForKey:NSFileSystemSize].unsignedLongLongValue;
    }
    
    return 0;
}

+ (uint64_t)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    }
    
    return 0;
}

+ (uint64_t)directorySizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        return 0;
    }
    
    __block uint64_t size = 0;
    NSArray<NSString *> *subpaths = [fileManager subpathsAtPath:path];
    [subpaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        size += [self fileSizeAtPath:[path stringByAppendingPathComponent:obj]];
    }];
    
    return size;
}

@end
