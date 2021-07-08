//
//  CXIndexList.m
//  Pods
//
//  Created by wshaolin on 2019/1/14.
//

#import "CXIndexList.h"
#import "NSString+CXExtensions.h"
#import "CXUtil.h"

static inline CXIndexObject *_CXFetchIndexObjectByIndexKey(NSArray<CXIndexObject *> *indexObjects, NSString *indexKey){
    __block CXIndexObject *indexObject = nil;
    [indexObjects enumerateObjectsUsingBlock:^(CXIndexObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.indexKey isEqualToString:indexKey]){
            indexObject = obj;
            *stop = YES;
        }
    }];
    
    return indexObject;
}

@interface CXIndexList () {
    NSMutableArray<NSString *> *_indexKeys;
    NSMutableArray<CXIndexObject *> *_indexObjects;
}

@end

@implementation CXIndexList

- (NSArray<NSString *> *)indexKeys{
    return _indexKeys;
}

- (NSArray<CXIndexObject *> *)indexObjects{
    return _indexObjects;
}

- (instancetype)initWithIndexKeys:(NSArray<NSString *> *)indexKeys
                     indexObjects:(NSArray<CXIndexObject *> *)indexObjects{
    if(CXArrayIsEmpty(indexKeys) || CXArrayIsEmpty(indexObjects)){
        return nil;
    }
    
    if(self = [super init]){
        _indexKeys = [NSMutableArray arrayWithArray:indexKeys];
        _indexObjects = [NSMutableArray arrayWithArray:indexObjects];
    }
    
    return self;
}

+ (instancetype)listWithObjects:(NSArray<id<CXIndexPinyinObject>> *)objects{
    if(CXArrayIsEmpty(objects)){
        return nil;
    }
    
    objects = [objects sortedArrayUsingComparator:^NSComparisonResult(id<CXIndexPinyinObject> _Nonnull obj1, id<CXIndexPinyinObject> _Nonnull obj2) {
        if(!obj1.pinyin){
            obj1.pinyin = CXValidPinyinString([[obj1 pinyinSource] cx_pinyin]);
        }
        
        if(!obj2.pinyin){
            obj2.pinyin = CXValidPinyinString([[obj2 pinyinSource] cx_pinyin]);
        }
        
        return [obj1.pinyin compare:obj2.pinyin];
    }];
    
    NSMutableArray<CXIndexObject *> *indexObjects = [NSMutableArray array];
    NSMutableArray<NSString *> *indexKeys = [NSMutableArray array];
    [objects enumerateObjectsUsingBlock:^(id<CXIndexPinyinObject> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *indexKey = [obj.pinyin substringWithRange:NSMakeRange(0, 1)];
        CXIndexObject *indexObject = _CXFetchIndexObjectByIndexKey(indexObjects, indexKey);
        if(indexObject){
            [indexObject addObject:obj];
        }else{
            indexObject = [[CXIndexObject alloc] initWithIndexKey:indexKey object:obj];
            [indexObjects addObject:indexObject];
            [indexKeys addObject:indexKey];
        }
    }];
    
    CXIndexObject *indexObject = indexObjects.firstObject;
    if([indexObject.indexKey isEqualToString:@"#"]){
        [indexObjects removeObjectAtIndex:0];
        [indexObjects addObject:indexObject];
        
        NSString *indexKey = indexKeys.firstObject;
        [indexKeys removeObjectAtIndex:0];
        [indexKeys addObject:indexKey];
    }
    
    return [[self alloc] initWithIndexKeys:indexKeys indexObjects:indexObjects];
}

- (NSIndexPath *)addPinyinObject:(id<CXIndexPinyinObject>)object{
    if(!object){
        return nil;
    }
    
    if(!object.pinyin){
        object.pinyin = CXValidPinyinString([[object pinyinSource] cx_pinyin]);
    }
    
    NSString *indexKey = [object.pinyin substringWithRange:NSMakeRange(0, 1)];
    NSUInteger section = [self indexWithIndexKey:indexKey];
    if(section != NSNotFound){
        CXIndexObject *indexObject = _indexObjects[section];
        [indexObject addObject:object];
        return [NSIndexPath indexPathForRow:indexObject.objects.count - 1 inSection:section];
    }
    
    [_indexKeys addObject:indexKey];
    [_indexKeys sortUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *firstIndexKey = _indexKeys.firstObject;
    if([firstIndexKey isEqualToString:@"#"]){
        [_indexKeys removeObjectAtIndex:0];
        [_indexKeys addObject:firstIndexKey];
    }
    
    section = [self indexWithIndexKey:indexKey];
    CXIndexObject *indexObject = [[CXIndexObject alloc] initWithIndexKey:indexKey object:object];
    [_indexObjects insertObject:indexObject atIndex:section];
    return [NSIndexPath indexPathForRow:0 inSection:section];
}

- (NSUInteger)indexWithIndexKey:(NSString *)indexKey{
    __block NSUInteger index = NSNotFound;
    [_indexKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isEqualToString:indexKey]){
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (NSUInteger)removeObjectsForIndexKey:(NSString *)indexKey{
    NSUInteger index = [self indexWithIndexKey:indexKey];
    
    if(index != NSNotFound){
        [_indexKeys removeObjectAtIndex:index];
        [_indexObjects removeObjectAtIndex:index];
    }
    
    return index;
}

- (NSIndexPath *)removePinyinObject:(id<CXIndexPinyinObject>)object indexKeyRemoved:(BOOL *)indexKeyRemoved{
    return [self removePinyinObjectForUid:[object uid] indexKeyRemoved:indexKeyRemoved];
}

- (NSIndexPath *)removePinyinObjectForUid:(NSString *)uid indexKeyRemoved:(BOOL *)indexKeyRemoved{
    __block NSUInteger section = NSNotFound;
    __block NSUInteger row = NSNotFound;
    __block NSString *removeIndexKey = nil;
    
    [_indexObjects enumerateObjectsUsingBlock:^(CXIndexObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger index = [obj removeObjectForUid:uid];
        if(index == NSNotFound){
            return;
        }
        
        if(CXArrayIsEmpty(obj.objects)){
            removeIndexKey = obj.indexKey;
        }
        
        section = idx;
        row = index;
        *stop = YES;
    }];
    
    if(section == NSNotFound){
        return nil;
    }
    
    if(removeIndexKey){
        if(indexKeyRemoved){
            *indexKeyRemoved = YES;
        }
        
        [self removeObjectsForIndexKey:removeIndexKey];
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)removeAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath){
        return;
    }
    
    if(indexPath.section >= _indexObjects.count){
        return;
    }
    
    CXIndexObject *indexObject = _indexObjects[indexPath.section];
    [indexObject removeAtIndex:indexPath.row];
    if(indexObject.objects.count > 0){
        return;
    }
    
    [_indexKeys removeObjectAtIndex:indexPath.section];
    [_indexObjects removeObjectAtIndex:indexPath.section];
}

@end
