//
//  NSBundle+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle (CXExtensions)

@property (nonatomic, copy, readonly) NSString *cx_appName;
@property (nonatomic, copy, readonly) NSString *cx_appId;
@property (nonatomic, copy, readonly) NSString *cx_appVersion;
@property (nonatomic, copy, readonly) NSString *cx_buildVersion;
@property (nonatomic, copy, readonly) NSString *cx_executableName;

@end
