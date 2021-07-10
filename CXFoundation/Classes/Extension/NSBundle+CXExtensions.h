//
//  NSBundle+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle (CXExtensions)

@property (nonatomic, strong, readonly) NSString *cx_appName;
@property (nonatomic, strong, readonly) NSString *cx_appId;
@property (nonatomic, strong, readonly) NSString *cx_appVersion;
@property (nonatomic, strong, readonly) NSString *cx_buildVersion;
@property (nonatomic, strong, readonly) NSString *cx_executableName;
@property (nonatomic, strong, readonly) NSString *cx_displayName;

@end
