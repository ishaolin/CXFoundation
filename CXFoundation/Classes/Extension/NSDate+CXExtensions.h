//
//  NSDate+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (CXExtensions)

+ (uint64_t)cx_timeStampForMillisecond;
- (uint64_t)cx_timeStampForMillisecond;

- (NSDate *)cx_offsetYear:(NSInteger)year;
- (NSDate *)cx_offsetMonth:(NSInteger)month;
- (NSDate *)cx_offsetDay:(NSInteger)day;
- (NSDate *)cx_offsetHour:(NSInteger)hour;
- (NSDate *)cx_offsetMinute:(NSInteger)minute;

- (NSInteger)cx_daysInMonth;
- (NSInteger)cx_firstDayWeekIndexInMonth;
- (NSInteger)cx_year;
- (NSInteger)cx_month;
- (NSInteger)cx_day;
- (NSInteger)cx_hour;
- (NSInteger)cx_minute;

+ (NSDate *)cx_firstDayOfThisYear;
+ (NSDate *)cx_firstDayOfThisMonth;
+ (NSDate *)cx_firstDayOfThisWeek;

- (BOOL)cx_isYesterday;
- (BOOL)cx_isToday;
- (BOOL)cx_isTomorrow;
- (BOOL)cx_isThisWeek;
- (BOOL)cx_isThisMonth;
- (BOOL)cx_isThisYear;

- (BOOL)cx_isSameDay:(NSDate *)date;
- (BOOL)cx_isSameWeek:(NSDate *)date;
- (BOOL)cx_isSameMonth:(NSDate *)date;
- (BOOL)cx_isEarlierMonth:(NSDate *)date;
- (BOOL)cx_isLaterMonth:(NSDate *)date;

- (NSDate *)cx_dateWithDay:(NSInteger)day;
- (NSDate *)cx_YMDDate;
+ (NSDate *)cx_dateFromString:(NSString *)dateString format:(NSString *)format;

- (NSString *)cx_description;
- (NSString *)cx_formatString:(NSString *)dateFormat;

+ (NSString *)cx_mediaTimeString:(NSInteger)seconds; // 00:00:00 | 00:00

@end
