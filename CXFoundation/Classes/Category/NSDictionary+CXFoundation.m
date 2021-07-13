//
//  NSDictionary+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "NSDictionary+CXFoundation.h"

@implementation NSDictionary (CXFoundation)

- (id)cx_objectForKey:(id<NSCopying>)key{
    if(!key){
        return nil;
    }
    
    id value = [self objectForKey:key];
    
    if([value isKindOfClass:[NSNull class]]){
        return nil;
    }
    
    return value;
}

- (BOOL)cx_hasKey:(id<NSCopying>)key{
    return ([self cx_objectForKey:key] != nil);
}

- (NSString *)cx_stringForKey:(id<NSCopying>)key{
    id value = [self cx_objectForKey:key];
    
    if([value isKindOfClass:[NSString class]]){
        return value;
    }
    
    if([value isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%@", value];
    }
    
    return nil;
}

- (NSNumber *)cx_numberForKey:(id<NSCopying>)key{
    id value = [self cx_objectForKey:key];
    
    if([value isKindOfClass:[NSNumber class]]){
        return value;
    }
    
    if([value isKindOfClass:[NSString class]]){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter numberFromString:value];
    }
    
    return nil;
}

- (NSArray *)cx_arrayForKey:(id<NSCopying>)key{
    id value = [self cx_objectForKey:key];
    
    if([value isKindOfClass:[NSArray class]]){
        return value;
    }
    
    return nil;
}

- (NSDictionary *)cx_dictionaryForKey:(id<NSCopying>)key{
    id value = [self cx_objectForKey:key];
    
    if([value isKindOfClass:[NSDictionary class]]){
        return value;
    }
    
    return nil;
}

@end

@implementation NSMutableDictionary (CXFoundation)

- (void)cx_setObject:(id)object forKey:(id<NSCopying>)key{
    if(!object || !key){
        return;
    }
    
    [self setObject:object forKey:key];
}

- (void)cx_setValue:(id)value forKey:(NSString *)key{
    if(!key){
        return;
    }
    
    [self setValue:value forKey:key];
}

- (void)cx_setString:(NSString *)string forKey:(id<NSCopying>)key{
    [self cx_setObject:string forKey:key];
}

@end
