//
//  NSArray+SortHelper.m
//  TableSearchHomework
//
//  Created by jsd on 12.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "NSArray+SortHelper.h"
#import "JDStudentSection.h"
#import "JDStudent.h"
#import "NSDate+DateHelper.h"

@implementation NSArray (SortHelper)

//Сортировка по месяцам рождения
+ (NSArray*) sortByMonthArray: (NSArray*) array
{
    NSArray* sortedStudents = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                               {
                                   NSInteger first = [NSDate getMonthFromDate:[(JDStudent*)obj1 birthday]];
                                   NSInteger second = [NSDate getMonthFromDate:[(JDStudent*)obj2 birthday]];
                                   return first > second;
                               }];
    
    return sortedStudents;
}

//Сортировка студентов в секции
+ (NSMutableArray*) sortStudentsInSectionsArray: (NSMutableArray*) array withDescriptors: (NSArray*) descriptors
{
    for (JDStudentSection* section in array)
    {
        [section.students sortUsingDescriptors:descriptors];
    }
    
    return array;
}

@end
