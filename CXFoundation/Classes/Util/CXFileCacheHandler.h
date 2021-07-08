//
//  CXFileCacheHandler.h
//  Pods
//
//  Created by wshaolin on 2019/3/25.
//

#import "CXFoundationDefines.h"
#import "CXFileHandler.h"

NS_ASSUME_NONNULL_BEGIN

#define CX_CACHES_PATH_GET(dir, name) [CXFileCacheHandler cachesFilePathWithDirectory:dir fileName:name]
#define CX_TMP_PATH_GET(dir, name)    [CXFileCacheHandler tmpFilePathWithDirectory:dir fileName:name]

#define CX_DOWNLOAD_PATH_GET(name)    CX_TMP_PATH_GET(CXDownloadCacheDirectory, name)
#define CX_RECORD_PATH_GET(name)    CX_TMP_PATH_GET(CXRecordCacheDirectory, name)

typedef NSString *CXFileDirectory;

@interface CXFileCacheHandler : NSObject

// 临时文件夹
+ (NSString *)tmpFilePathWithDirectory:(CXFileDirectory)directory
                              fileName:(NSString *)fileName;

// caches文件夹
+ (NSString *)cachesFilePathWithDirectory:(CXFileDirectory)directory
                                 fileName:(NSString *)fileName;

// caches目录path
+ (NSString *)cachesPathWithDirectory:(CXFileDirectory)directory;

// tmp目录path
+ (NSString *)tmpPathWithDirectory:(CXFileDirectory)directory;

@end

CX_FOUNDATION_EXTERN CXFileDirectory const CXDownloadCacheDirectory;
CX_FOUNDATION_EXTERN CXFileDirectory const CXRecordCacheDirectory;

CX_FOUNDATION_EXTERN NSString *CXCreateCacheFileName(NSString *ext);

NS_ASSUME_NONNULL_END
