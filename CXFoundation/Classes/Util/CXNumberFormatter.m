//
//  CXNumberFormatter.m
//  Pods
//
//  Created by wshaolin on 2019/7/22.
//

#import "CXNumberFormatter.h"

@implementation CXNumberFormatter

+ (NSString *)stringFromFloat:(float)floatValue{
    return [self stringFromFloat:floatValue format:CXNumberFormatDynamicMaxTwo];
}

+ (NSString *)stringFromDouble:(double)doubleValue{
    return [self stringFromDouble:doubleValue format:CXNumberFormatDynamicMaxTwo];
}

+ (NSString *)stringFromNumber:(NSNumber *)number{
    return [self stringFromNumber:number format:CXNumberFormatDynamicMaxTwo];
}

+ (NSString *)stringFromFloat:(float)floatValue format:(NSString *)format{
    return [self stringFromNumber:[NSNumber numberWithFloat:floatValue] format:format];
}

+ (NSString *)stringFromDouble:(double)doubleValue format:(NSString *)format{
    return [self stringFromNumber:[NSNumber numberWithDouble:doubleValue] format:format];
}

+ (NSString *)stringFromNumber:(NSNumber *)number format:(NSString *)format{
    if(number == nil || number.doubleValue == 0){
        return @"0";
    }
    
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    formatter.positiveFormat = format;
    return [formatter stringFromNumber:number];
}

@end

NSString * const CXNumberFormatDynamicMaxTwo = @"0.##";
NSString * const CXNumberFormatDynamicMinOne = @"0.0#";
NSString * const CXNumberFormatFixedInteger = @"#";
NSString * const CXNumberFormatFixedOne = @"0.0";
NSString * const CXNumberFormatFixedTwo = @"0.00";
