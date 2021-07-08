//
//  CXIndexObject.m
//  Pods
//
//  Created by wshaolin on 2019/1/14.
//

#import "CXIndexObject.h"

@interface CXIndexObject () {
    NSMutableArray<id<CXIndexPinyinObject>> *_objects;
}

@end

@implementation CXIndexObject

- (NSArray<id<CXIndexPinyinObject>> *)objects{
    return _objects;
}

- (instancetype)initWithIndexKey:(NSString *)indexKey object:(id<CXIndexPinyinObject>)object{
    if(self = [super init]){
        _indexKey = indexKey;
        _objects = [NSMutableArray array];
        
        [self addObject:object];
    }
    
    return self;
}

- (void)addObject:(id<CXIndexPinyinObject>)object{
    if(object){
        [_objects addObject:object];
    }
}

- (void)insertObject:(id<CXIndexPinyinObject>)object atIndex:(NSUInteger)index{
    if(object){
        [_objects insertObject:object atIndex:index];
    }
}

- (NSUInteger)removeObject:(id<CXIndexPinyinObject>)object{
    return [self removeObjectForUid:[object uid]];
}

- (NSUInteger)removeObjectForUid:(NSString *)uid{
    if(!uid){
        return NSNotFound;
    }
    
    __block NSUInteger index = NSNotFound;
    [_objects enumerateObjectsUsingBlock:^(id<CXIndexPinyinObject>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[obj uid] isEqualToString:uid]){
            index = idx;
            *stop = YES;
        }
    }];
    
    [self removeAtIndex:index];
    return index;
}

- (void)removeAtIndex:(NSUInteger)index{
    if(index < _objects.count){
        [_objects removeObjectAtIndex:index];
    }
}

- (id<CXIndexPinyinObject>)objectForUid:(NSString *)uid atIndex:(NSUInteger *)index{
    if(!uid){
        return nil;
    }
    
    __block id<CXIndexPinyinObject> object = nil;
    __block NSUInteger _index = NSNotFound;
    [_objects enumerateObjectsUsingBlock:^(id<CXIndexPinyinObject>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([[obj uid] isEqualToString:uid]){
            object = obj;
            _index = idx;
            *stop = YES;
        }
    }];
    
    if(index){
        *index = _index;
    }
    
    return object;
}

@end
