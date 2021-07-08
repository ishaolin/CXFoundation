//
//  CXStringSymbolRange.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXStringSymbolRange.h"
#import "CXStringUtil.h"

@interface CXStringSymbolRange(){
    NSString *_beginSymbol;
    NSString *_endSymbol;
    NSMutableString *_mutableString;
    NSMutableArray<NSValue *> *_ranges;
}

@end

@implementation CXStringSymbolRange

- (instancetype)initWithBeginSymbol:(NSString *)beginSymbol
                          endSymbol:(NSString *)endSymbol
                       formatString:(NSString *)formatString{
    if(self = [super init]){
        _beginSymbol = beginSymbol;
        _endSymbol = endSymbol;
        _mutableString = [formatString mutableCopy];
    }
    
    return self;
}

- (NSString *)replacedString{
    return [_mutableString copy];
}

- (NSRange)nextPairedSymbolRange{
    if(CXStringIsEmpty(_beginSymbol) ||
       CXStringIsEmpty(_endSymbol) ||
       CXStringIsEmpty(_mutableString)){
        return NSMakeRange(NSNotFound, 0);
    }
    
    NSUInteger beginIndex = NSNotFound;
    NSUInteger endIndex = NSNotFound;
    
    NSRange beginRange = [_mutableString rangeOfString:_beginSymbol];
    NSRange endRange = [_mutableString rangeOfString:_endSymbol];
    if(beginRange.location != NSNotFound &&
       endRange.location != NSNotFound &&
       endRange.location > beginRange.location){
        beginIndex = beginRange.location;
        [_mutableString replaceCharactersInRange:beginRange withString:@""];
        
        endRange.location = endRange.location - beginRange.length;
        endIndex = endRange.location;
        [_mutableString replaceCharactersInRange:endRange withString:@""];
    }
    
    return NSMakeRange(beginIndex, endIndex - beginIndex);
}

- (NSArray<NSValue *> *)pairedSymbolRanges{
    if(!_ranges){
        _ranges = [NSMutableArray array];
        
        NSRange range;
        while((range = [self nextPairedSymbolRange]).location != NSNotFound){
            [_ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    
    return [_ranges copy];
}

@end
