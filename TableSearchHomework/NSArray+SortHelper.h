//
//  NSArray+SortHelper.h
//  TableSearchHomework
//
//  Created by jsd on 12.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SortHelper)

+ (NSArray*) sortByMonthArray: (NSArray*) array;
+ (NSMutableArray*) sortStudentsInSectionsArray: (NSMutableArray*) array withDescriptors: (NSArray*) descriptors;

@end
