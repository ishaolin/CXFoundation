//
//  CXBlockOperationQueue.h
//  Pods
//
//  Created by wshaolin on 2018/11/22.
//

#import <Foundation/Foundation.h>

@class CXBlockOperationHandlerResult;

typedef void(^CXBlockOperationResultNotify)(id data);
typedef void(^CXBlockOperationHandler)(CXBlockOperationResultNotify notify);
typedef void(^CXBlockOperationQueueCompletion)(NSArray<CXBlockOperationHandlerResult *> *results);

@interface CXBlockOperationQueue : NSObject

@property (nonatomic, copy) CXBlockOperationQueueCompletion completion;

- (void)addOperationHandler:(CXBlockOperationHandler)handler;

- (void)addOperationHandler:(CXBlockOperationHandler)handler forKey:(NSString *)key;

- (void)invoke;

- (void)cancelAllOperations;

@end

@interface CXBlockOperationHandlerResult : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id data;

@end
