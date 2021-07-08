//
//  CXLogger.h
//  Pods
//
//  Created by wshaolin on 2018/7/20.
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

typedef NS_ENUM(NSInteger, CXLogLevel){
    CXLogLevelFatel = 0,
    CXLogLevelError = 1,
    CXLogLevelWarn  = 2,
    CXLogLevelInfo  = 3,
    CXLogLevelTrace = 4,
    CXLogLevelDebug = 5
};

CX_FOUNDATION_EXTERN void CXLogFunc(CXLogLevel level,
                                    const char *file,
                                    const char *function,
                                    NSUInteger line,
                                    NSString *format, ...) NS_FORMAT_FUNCTION(5, 6) NS_NO_TAIL_CALL;

CX_FOUNDATION_EXTERN void CXAssertFunc(BOOL condition,
                                       const char *file,
                                       const char *function,
                                       NSUInteger line,
                                       NSString *format, ...) NS_FORMAT_FUNCTION(5, 6) NS_NO_TAIL_CALL;
