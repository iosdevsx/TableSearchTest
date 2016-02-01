//
//  NSDate+DateHelper.m
//  TableSearchHomework
//
//  Created by jsd on 11.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "NSDate+DateHelper.h"

@implementation NSDate (DateHelper)

//Получить номер месяца
+ (NSInteger) getMonthFromDate: (NSDate*) date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger component = [calendar component:NSCalendarUnitMonth fromDate:date];
    return component;
}

//Получить месяц
+ (NSString*) getFormattedMonthFromDate: (NSDate*) date withFormat: (NSString*) format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
}

//Форматированная дата для дня рождения
+ (NSString*) getFormattedBirthdayForDate: (NSDate*) date
{
    static NSDateFormatter* formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy"];
    }
    
    return [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
}

@end
