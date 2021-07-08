//
//  NSJSONSerialization+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "NSJSONSerialization+CXExtensions.h"

@implementation NSJSONSerialization (CXExtensions)

+ (NSDictionary *)cx_deserializeJSONToDictionary:(id)obj{
    return [self cx_deserializeJSON:obj forClass:[NSDictionary class]];
}

+ (NSArray *)cx_deserializeJSONToArray:(id)obj{
    return [self cx_deserializeJSON:obj forClass:[NSArray class]];
}

+ (NSString *)cx_stringWithJSONObject:(id)obj{
    return [self cx_stringWithJSONObject:obj options:0];
}

+ (NSString *)cx_stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)options{
    if(!obj){
        return nil;
    }
    
    if([obj isKindOfClass:[NSString class]]){
        return obj;
    }
    
    NSData *data = nil;
    if([obj isKindOfClass:[NSData class]]){
        data = obj;
    }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]){
        data = [self dataWithJSONObject:obj options:options error:nil];
    }
    
    if(!data){
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)cx_deserializeJSON:(id)obj forClass:(Class)clazz{
    if(!obj || !clazz){
        return nil;
    }
    
    if([obj isKindOfClass:clazz]){
        return obj;
    }
    
    NSData *data = nil;
    if([obj isKindOfClass:[NSData class]]){
        data = (NSData *)obj;
    }else if([obj isKindOfClass:[NSString class]]){
        data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if(data){
        id json = [self JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([json isKindOfClass:clazz]){
            return json;
        }
    }
    
    return nil;
}

@end
