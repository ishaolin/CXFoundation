//
//  CXIndexList.h
//  Pods
//
//  Created by wshaolin on 2019/1/14.
//

#import <Foundation/Foundation.h>
#import "CXIndexObject.h"

@interface CXIndexList : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *indexKeys;
@property (nonatomic, strong, readonly) NSArray<CXIndexObject *> *indexObjects;

- (instancetype)initWithIndexKeys:(NSArray<NSString *> *)indexKeys
                     indexObjects:(NSArray<CXIndexObject *> *)indexObjects;

+ (instancetype)listWithObjects:(NSArray<id<CXIndexPinyinObject>> *)objects;

- (NSIndexPath *)addPinyinObject:(id<CXIndexPinyinObject>)object;
- (NSUInteger)removeObjectsForIndexKey:(NSString *)indexKey;

- (NSIndexPath *)removePinyinObject:(id<CXIndexPinyinObject>)object
                    indexKeyRemoved:(BOOL *)indexKeyRemoved;
- (NSIndexPath *)removePinyinObjectForUid:(NSString *)uid
                          indexKeyRemoved:(BOOL *)indexKeyRemoved;

- (void)removeAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^CXIndexListBlock)(CXIndexList *indexList);
