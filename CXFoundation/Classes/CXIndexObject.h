//
//  CXIndexObject.h
//  Pods
//
//  Created by wshaolin on 2019/1/14.
//

#import <Foundation/Foundation.h>

@protocol CXIndexPinyinObject <NSObject>

@required

@property (nonatomic, copy) NSString *pinyin;

- (NSString *)pinyinSource;
- (NSString *)uid;

@end

@interface CXIndexObject : NSObject

@property (nonatomic, copy, readonly) NSString *indexKey;
@property (nonatomic, strong, readonly) NSArray<id<CXIndexPinyinObject>> *objects;

- (instancetype)initWithIndexKey:(NSString *)indexKey object:(id<CXIndexPinyinObject>)object;

- (void)addObject:(id<CXIndexPinyinObject>)object;
- (void)insertObject:(id<CXIndexPinyinObject>)object atIndex:(NSUInteger)index;

- (NSUInteger)removeObject:(id<CXIndexPinyinObject>)object;
- (NSUInteger)removeObjectForUid:(NSString *)uid;
- (void)removeAtIndex:(NSUInteger)index;

- (id<CXIndexPinyinObject>)objectForUid:(NSString *)uid atIndex:(NSUInteger *)index;

@end
