//
//  CXBlockOperationQueue.m
//  Pods
//
//  Created by wshaolin on 2018/11/22.
//

#import "CXBlockOperationQueue.h"
#import "CXUtils.h"
#import "CXObjectManager.h"

@interface CXBlockOperationQueue () {
    NSMutableArray<CXBlockOperationHandlerResult *> *_results; // 处理结果
    NSMutableDictionary<NSString *, CXBlockOperationHandler> *_handlers; // 任务
}

@end

@implementation CXBlockOperationQueue

- (instancetype)init{
    if(self = [super init]){
        _results = [NSMutableArray array];
        _handlers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addOperationHandler:(CXBlockOperationHandler)handler{
    [self addOperationHandler:handler forKey:@(_handlers.count).stringValue];
}

- (void)addOperationHandler:(CXBlockOperationHandler)handler forKey:(NSString *)key{
    if(!handler || !key){
        return;
    }
    
    // 开始执行之后不能再添加handler
    if([CXObjectManager containsObject:self]){
        return;
    }
    
    _handlers[key] = [handler copy];
}

- (void)invoke{
    if(CXDictionaryIsEmpty(_handlers) || [CXObjectManager addObject:self]){
        return;
    }
    
    [_handlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CXBlockOperationHandler  _Nonnull handler, BOOL * _Nonnull stop) {
        CXBlockOperationResultNotify notify = ^(id data){
            [self handleInvokeResultData:data forKey:key];
        };
        
        handler(notify);
    }];
}

- (void)handleInvokeResultData:(id)data forKey:(NSString *)key{
    CXBlockOperationHandlerResult *result = [[CXBlockOperationHandlerResult alloc] init];
    result.key = key;
    result.data = data;
    [_results addObject:result];
    
    if(_results.count == _handlers.count){
        if(self.completion){
            self.completion([_results copy]);
        }
        
        [_handlers removeAllObjects];
        [CXObjectManager removeObject:self];
    }
}

- (void)cancelAllOperations{
    [_results removeAllObjects];
    [_handlers removeAllObjects];
    [CXObjectManager removeObject:self];
}

@end

@implementation CXBlockOperationHandlerResult

@end
