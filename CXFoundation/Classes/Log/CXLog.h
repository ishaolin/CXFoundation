//
//  CXLog.h
//  Pods
//
//  Created by wshaolin on 2018/7/20.
//

#import "CXLogger.h"

#if !defined(ENABLE_LOG)
#if defined(DEBUG) && DEBUG
#define ENABLE_LOG 1
#else
#define ENABLE_LOG 0
#endif
#endif

#if ENABLE_LOG
#define POSSIBLE_LOG(level, format, ...)                                                    \
_Pragma("clang diagnostic push")                                                            \
_Pragma("clang diagnostic ignored \"-Wformat\"")                                            \
do { CXLogFunc(level, __FILE__, __FUNCTION__, __LINE__, format, ##__VA_ARGS__); } while(0)  \
_Pragma("clang diagnostic pop")
#else
#define POSSIBLE_LOG(level, format, ...) do { } while(0)
#endif

#define LOG_FATEL(format, ...)     POSSIBLE_LOG(CXLogLevelFatel, format, ##__VA_ARGS__)
#define LOG_ERROR(format, ...)     POSSIBLE_LOG(CXLogLevelError, format, ##__VA_ARGS__)
#define LOG_WARN(format, ...)      POSSIBLE_LOG(CXLogLevelWarn, format, ##__VA_ARGS__)
#define LOG_INFO(format, ...)      POSSIBLE_LOG(CXLogLevelInfo, format, ##__VA_ARGS__)
#define LOG_TRACE(format, ...)     POSSIBLE_LOG(CXLogLevelTrace, format, ##__VA_ARGS__)
#define LOG_DEBUG(format, ...)     POSSIBLE_LOG(CXLogLevelDebug, format, ##__VA_ARGS__)

#define CX_ASSERT(condition, format, ...)                                                           \
_Pragma("clang diagnostic push")                                                                    \
_Pragma("clang diagnostic ignored \"-Wformat\"")                                                    \
do { CXAssertFunc(condition, __FILE__, __FUNCTION__, __LINE__, format, ##__VA_ARGS__); } while(0)   \
_Pragma("clang diagnostic pop")

#define LOG_BREAKPOINT(format, ...) CX_ASSERT(NO, format, ##__VA_ARGS__)
