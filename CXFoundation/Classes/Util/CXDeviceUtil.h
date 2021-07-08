//
//  CXDeviceUtil.h
//  Pods
//
//  Created by wshaolin on 2018/9/6.
//

#import <Foundation/Foundation.h>

@interface CXDeviceUtil : NSObject

+ (uint64_t)freeDiskSpaceInBytes;
+ (uint64_t)totalDiskSpaceInBytes;

+ (uint64_t)fileSizeAtPath:(NSString *)path;
+ (uint64_t)directorySizeAtPath:(NSString *)path;

@end
