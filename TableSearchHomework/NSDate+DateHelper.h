//
//  NSDate+DateHelper.h
//  TableSearchHomework
//
//  Created by jsd on 11.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)

+ (NSInteger) getMonthFromDate: (NSDate*) date;
+ (NSString*) getFormattedMonthFromDate: (NSDate*) date withFormat: (NSString*) format;
+ (NSString*) getFormattedBirthdayForDate: (NSDate*) date;

@end
