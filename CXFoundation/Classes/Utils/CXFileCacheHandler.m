//
//  CXFileCacheHandler.m
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import "CXFileCacheHandler.h"
#import "CXStringUtils.h"

@implementation CXFileCacheHandler

+ (NSString *)tmpFilePathWithDirectory:(CXFileDirectory)directory fileName:(NSString *)fileName{
    if(CXStringIsEmpty(fileName)){
        return nil;
    }
    
    NSString *tmpPath = [self tmpPathWithDirectory:directory];
    if(tmpPath){
        return [tmpPath stringByAppendingPathComponent:fileName];
    }
    
    return nil;
}

+ (NSString *)cachesFilePathWithDirectory:(CXFileDirectory)directory fileName:(NSString *)fileName{
    if(CXStringIsEmpty(fileName)){
        return nil;
    }
    
    NSString *cachesPath = [self cachesPathWithDirectory:directory];
    if(cachesPath){
        return [cachesPath stringByAppendingPathComponent:fileName];
    }
    
    return nil;
}

+ (NSString *)cachesPathWithDirectory:(CXFileDirectory)directory{
    if(CXStringIsEmpty(directory)){
        return nil;
    }
    
    NSString *cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cachesPath = [cachesDir stringByAppendingPathComponent:directory];
    if([[NSFileManager defaultManager] fileExistsAtPath:cachesPath]){
        return cachesPath;
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return cachesPath;
}

+ (NSString *)tmpPathWithDirectory:(CXFileDirectory)directory{
    if(CXStringIsEmpty(directory)){
        return nil;
    }
    
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:directory];
    if([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
        return tmpPath;
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return tmpPath;
}

@end

NSString *CXCreateCacheFileName(NSString *ext){
    NSString *name = [NSString stringWithFormat:@"%.f", ([NSDate date].timeIntervalSince1970 * 1000)];
    return [name stringByAppendingString:ext];
}

CXFileDirectory const CXDownloadCacheDirectory = @"download";
CXFileDirectory const CXRecordCacheDirectory = @"record";
