//
//  NSDate+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "NSDate+CXFoundation.h"
#import <objc/runtime.h>

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0)
#define CXCalendarUnitYear              NSCalendarUnitYear
#define CXCalendarUnitMonth             NSCalendarUnitMonth
#define CXCalendarUnitDay               NSCalendarUnitDay
#define CXCalendarUnitHour              NSCalendarUnitHour
#define CXCalendarUnitMinute            NSCalendarUnitMinute
#define CXCalendarUnitSecond            NSCalendarUnitSecond
#define CXCalendarUnitWeekday           NSCalendarUnitWeekday
#define CXCalendarUnitWeekOfMonth       NSCalendarUnitWeekOfMonth
#define CXCalendarUnitWeekOfYear        NSCalendarUnitWeekOfYear
#define CXCalendarUnitWeekdayOrdinal    NSCalendarUnitWeekdayOrdinal
#else
#define CXCalendarUnitYear              NSYearCalendarUnit
#define CXCalendarUnitMonth             NSMonthCalendarUnit
#define CXCalendarUnitDay               NSDayCalendarUnit
#define CXCalendarUnitHour              NSHourCalendarUnit
#define CXCalendarUnitMinute            NSMinuteCalendarUnit
#define CXCalendarUnitSecond            NSSecondCalendarUnit
#define CXCalendarUnitWeekday           NSWeekdayCalendarUnit
#define CXCalendarUnitWeekOfMonth       NSWeekOfMonthCalendarUnit
#define CXCalendarUnitWeekOfYear        NSWeekOfYearCalendarUnit
#define CXCalendarUnitWeekdayOrdinal    NSWeekdayOrdinalCalendarUnit
#endif

typedef NS_ENUM(NSInteger, CXCalendarCompareType){
    CXCalendarCompareTypeEarlier,
    CXCalendarCompareTypeEqual,
    CXCalendarCompareTypeLater
};

static inline NSCalendar *CXGetCalendar(void){
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

@implementation NSDate (CXFoundation)

- (NSCalendar *)cx_calendar{
    NSCalendar *calendar = objc_getAssociatedObject(self, _cmd);
    if(!calendar){
        calendar = CXGetCalendar();
        objc_setAssociatedObject(self, _cmd, calendar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return calendar;
}

+ (uint64_t)cx_timeStampForMillisecond{
    return [[self date] cx_timeStampForMillisecond];
}

- (uint64_t)cx_timeStampForMillisecond{
    uint64_t timeStamp = (uint64_t)(self.timeIntervalSince1970 * 1000);
    return timeStamp;
}

- (NSString *)cx_formatString:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)cx_dateFromString:(NSString *)dateString format:(NSString *)format{
    if(!dateString || dateString.length == 0){
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

- (NSInteger)cx_year {
    return [self.cx_calendar components:CXCalendarUnitYear fromDate:self].year;
}

- (NSInteger)cx_month {
    return [self.cx_calendar components:CXCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)cx_day {
    return [self.cx_calendar components:CXCalendarUnitDay fromDate:self].day;
}

- (NSInteger)cx_hour {
    return [self.cx_calendar components:CXCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)cx_minute {
    return [self.cx_calendar components:CXCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)cx_firstDayWeekIndexInMonth {
    NSCalendar *calendar = self.cx_calendar;
    calendar.firstWeekday = 2;
    NSDateComponents *components = [calendar components:CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay fromDate:self];
    components.day = 1;
    
    return [calendar ordinalityOfUnit:CXCalendarUnitWeekday
                               inUnit:CXCalendarUnitWeekOfMonth
                              forDate:[calendar dateFromComponents:components]];
}

- (NSDate *)cx_offsetYear:(NSInteger)year{
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cx_offsetMonth:(NSInteger)month {
    NSCalendar *calendar = self.cx_calendar;
    calendar.firstWeekday = 2;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cx_offsetHour:(NSInteger)hour {
    NSCalendar *calendar = self.cx_calendar;
    calendar.firstWeekday = 2;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hour;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cx_offsetMinute:(NSInteger)minute{
    NSCalendar *calendar = self.cx_calendar;
    calendar.firstWeekday = 2;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.minute = minute;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cx_offsetDay:(NSInteger)day {
    NSCalendar *calendar = self.cx_calendar;
    calendar.firstWeekday = 2;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = day;
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)cx_daysInMonth {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:CXCalendarUnitDay
                                                       inUnit:CXCalendarUnitMonth
                                                      forDate:self];
    return range.length;
}

+ (NSDate *)cx_firstDayOfThisYear{
    NSCalendar *calendar = CXGetCalendar();
    NSDateComponents *components = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:[NSDate date]];
    components.month = 1;
    components.day = 1;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)cx_firstDayOfThisMonth{
    NSCalendar *calendar = CXGetCalendar();
    NSDateComponents *components = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:[NSDate date]];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)cx_firstDayOfThisWeek{
    NSCalendar *calendar = CXGetCalendar();
    calendar.firstWeekday = 2;
    NSDate *date = [NSDate date];
    NSDateComponents *components = [calendar components:CXCalendarUnitWeekday fromDate:date];
    date = [date cx_offsetDay:(1 - components.weekday)];
    return date;
}

- (BOOL)cx_isYesterday{
    return [self cx_isSameDay:[[NSDate date] cx_offsetDay:-1]];
}

- (BOOL)cx_isToday{
    return [self cx_isSameDay:[NSDate date]];
}

- (BOOL)cx_isTomorrow{
    return [self cx_isSameDay:[[NSDate date] cx_offsetDay:1]];
}

- (BOOL)cx_isThisWeek{
    return [self cx_isSameWeek:[NSDate date]];
}

- (BOOL)cx_isThisMonth{
    return [self cx_isSameMonth:[NSDate date]];
}

- (BOOL)cx_isThisYear{
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components1 = [calendar components:CXCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [calendar components:CXCalendarUnitYear fromDate:[NSDate date]];
    return components1.year == components2.year;
}

- (BOOL)cx_isSameDay:(NSDate *)date{
    if(!date){
        return NO;
    }
    
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components1 = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:date];
    return (components1.year == components2.year &&
            components1.month == components2.month &&
            components1.day == components2.day);
}

- (BOOL)cx_isSameWeek:(NSDate *)date{
    if(!date){
        return NO;
    }
    
    NSCalendar *calendar = self.cx_calendar;
    NSCalendarUnit unit = CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitWeekOfMonth;
    NSDateComponents *components1 = [calendar components:unit fromDate:self];
    NSDateComponents *components2 = [calendar components:unit fromDate:date];
    if(components1.year != components2.year){
        return NO;
    }
    
    if(components1.month != components2.month){
        return NO;
    }
    
    return components1.weekOfMonth == components2.weekOfMonth;
}

- (BOOL)cx_isSameMonth:(NSDate *)date{
    return [self cx_compareMonth:date compareType:CXCalendarCompareTypeEqual];
}

- (BOOL)cx_isEarlierMonth:(NSDate *)date{
    return [self cx_compareMonth:date compareType:CXCalendarCompareTypeEarlier];
}

- (BOOL)cx_isLaterMonth:(NSDate *)date{
    return [self cx_compareMonth:date compareType:CXCalendarCompareTypeLater];
}

- (BOOL)cx_compareMonth:(NSDate *)date compareType:(CXCalendarCompareType)compareType{
    if(!date){
        return NO;
    }
    
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components1 = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth) fromDate:self];
    NSDateComponents *components2 = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth) fromDate:date];
    
    switch (compareType) {
        case CXCalendarCompareTypeEarlier:{
            return (components1.year < components2.year ||
                    (components1.year == components2.year &&
                     components1.month < components2.month));
        }
        case CXCalendarCompareTypeEqual:{
            return (components1.year == components2.year &&
                    components1.month == components2.month);
        }
        case CXCalendarCompareTypeLater:{
            return (components1.year > components2.year ||
                    (components1.year == components2.year &&
                     components1.month > components2.month));
        }
        default:
            return NO;
    }
}

- (NSDate *)cx_dateWithDay:(NSInteger)day{
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:self];
    components.day = day;
    return [calendar dateFromComponents:components];
}

- (NSDate *)cx_YMDDate{
    NSCalendar *calendar = self.cx_calendar;
    NSDateComponents *components = [calendar components:(CXCalendarUnitYear | CXCalendarUnitMonth | CXCalendarUnitDay) fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSString *)cx_description{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)cx_mediaTimeString:(NSInteger)seconds{
    int _hours = (int)MAX(MIN(seconds / 3600, 99), 0);
    int _minutes = (int)MAX((seconds % 3600) / 60, 0);
    int _seconds = (int)MAX((seconds % 3600) % 60, 0);
    
    if(_hours > 0){
        return [NSString stringWithFormat:@"%02d:%02d:%02d", _hours, _minutes, _seconds];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d", _minutes, _seconds];
}

@end
