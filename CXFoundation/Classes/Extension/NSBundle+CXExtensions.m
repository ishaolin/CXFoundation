//
//  NSBundle+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "NSBundle+CXExtensions.h"
#import "NSDictionary+CXExtensions.h"

@implementation NSBundle (CXExtensions)

- (NSString *)cx_appName{
    return [self.infoDictionary cx_stringForKey:@"CFBundleName"];
}

- (NSString *)cx_appId{
    return [self.infoDictionary cx_stringForKey:@"CFBundleIdentifier"];
}

- (NSString *)cx_appVersion{
    return [self.infoDictionary cx_stringForKey:@"CFBundleShortVersionString"];
}

- (NSString *)cx_buildVersion{
    return [self.infoDictionary cx_stringForKey:@"CFBundleVersion"];
}

- (NSString *)cx_executableName{
    return [self.infoDictionary cx_stringForKey:@"CFBundleExecutable"];
}

- (NSString *)cx_displayName{
    return [self.infoDictionary cx_stringForKey:@"CFBundleDisplayName"];
}

@end
