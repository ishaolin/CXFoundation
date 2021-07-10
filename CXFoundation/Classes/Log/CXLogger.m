//
//  CXLogger.m
//  Pods
//
//  Created by wshaolin on 2018/7/20.
//

#import "CXLogger.h"
#import "CXStringUtils.h"

static inline dispatch_queue_t CXLogWorkQueue(void){
    static dispatch_queue_t workQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 串行队列 attr is DISPATCH_QUEUE_SERIAL or NULL
        workQueue =  dispatch_queue_create("com.athena.track.log.queue",  NULL);
    });
    
    return workQueue;
}

static inline NSString *CXLogLevelString(CXLogLevel level){
    static NSDictionary<NSNumber *, NSString *> *logLevels;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logLevels = @{@(CXLogLevelFatel) : @"FATAL",
                      @(CXLogLevelError) : @"ERROR",
                      @(CXLogLevelWarn) : @"WARN",
                      @(CXLogLevelInfo) : @"INFO",
                      @(CXLogLevelTrace) : @"TRACE",
                      @(CXLogLevelDebug) : @"DEBUG"};
    });
    
    return [logLevels objectForKey:@(level)];
}

static inline NSString *CXLogDateFormatString(void){
    static NSString *key = @"com.athena.log.date";
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = dictionary[key];
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone systemTimeZone];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss'.'SSS"];
        
        dictionary[key] = formatter;
    }
    
    return [formatter stringFromDate:[NSDate date]];
}

static inline NSString *CXLogFileNameFromFilePath(const char *filePath){
    if(!filePath){
        return nil;
    }
    
    NSString *_filePath = [[NSString alloc] initWithCString:filePath encoding:NSUTF8StringEncoding];
    NSString *fileName = _filePath.lastPathComponent;
    return fileName;
}

@interface CXLogger : NSObject

+ (void)log:(NSString *)log
      level:(CXLogLevel)level
       file:(const char *)fileName
   function:(const char *)functionName
       line:(NSUInteger)lineNumber;

+ (void)log:(NSString *)log
      level:(CXLogLevel)level
       file:(const char *)fileName
   function:(const char *)functionName
       line:(NSUInteger)lineNumber
   userInfo:(NSDictionary<NSString *, id> *)userInfo;

@end

@implementation CXLogger

+ (void)log:(NSString *)log
      level:(CXLogLevel)level
       file:(const char *)fileName
   function:(const char *)functionName
       line:(NSUInteger)lineNumber{
    NSString *threadInfo = [NSThread currentThread].description ?: @"";
    
    [self log:log
        level:level
         file:fileName
     function:functionName
         line:lineNumber
     userInfo:@{@"thread" : threadInfo}];
}

+ (void)log:(NSString *)log
      level:(CXLogLevel)level
       file:(const char *)fileName
   function:(const char *)functionName
       line:(NSUInteger)lineNumber
   userInfo:(NSDictionary<NSString *, id> *)userInfo{
    dispatch_async(CXLogWorkQueue(), ^{
        NSString *msg = [self formatLog:log
                                  level:level
                                   file:fileName
                               function:functionName
                                   line:lineNumber
                               userInfo:userInfo];
        NSLog(@"%@", msg);
    });
}

+ (NSString *)formatLog:(NSString *)log
                  level:(CXLogLevel)level
                   file:(const char *)fileName
               function:(const char *)functionName
                   line:(NSUInteger)lineNumber
               userInfo:(NSDictionary<NSString *, id> *)userInfo{
    NSMutableString *msg = [NSMutableString stringWithFormat:@"[%@] [%@][%@][%@ %s->%lu] || _msg=[%@]",
                            [NSBundle mainBundle].bundleIdentifier,
                            CXLogLevelString(level) ?: @"/",
                            CXLogDateFormatString() ?: @"/",
                            CXLogFileNameFromFilePath(fileName) ?: @"/",
                            functionName,
                            (unsigned long)lineNumber,
                            log];
    if(userInfo){
        NSString *info = [NSString stringWithFormat:@"%@", userInfo];
        info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@" " withString:@""];
        [msg appendFormat:@" || _info=%@", info];
    }
    
    return [msg copy];
}

@end

void CXLogFunc(CXLogLevel level,
               const char *file,
               const char *function,
               NSUInteger line,
               NSString *format, ...) {
    if(CXStringIsEmpty(format)){
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString *log = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [CXLogger log:log level:level file:file function:function line:line];
}

void CXAssertFunc(BOOL condition,
                  const char *file,
                  const char *function,
                  NSUInteger line,
                  NSString *format, ...) {
    if(condition){
        return;
    }
    
    @try{
        NSString *msg = @"nil";
        if([CXStringUtils isValidString:format]){
            va_list args;
            va_start(args, format);
            msg = [[NSString alloc] initWithFormat:format arguments:args];
            va_end(args);
            
            msg = [NSString stringWithFormat:@"Assert Exception: %@ info = {\n    file = \"%@\", \n    func = \"%s\", \n    line = %@\n}", msg, CXLogFileNameFromFilePath(file), function, @(line)];
        }
        [NSException raise:@"CXAssertException" format:msg, nil];
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
    }
}
