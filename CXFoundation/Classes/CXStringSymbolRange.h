//
//  CXStringSymbolRange.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@interface CXStringSymbolRange : NSObject

- (instancetype)initWithBeginSymbol:(NSString *)beginSymbol
                          endSymbol:(NSString *)endSymbol
                       formatString:(NSString *)formatString;

- (NSArray<NSValue *> *)pairedSymbolRanges;

- (NSString *)replacedString;

@end
