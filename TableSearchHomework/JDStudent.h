//
//  JDStudent.h
//  TableSearchHomework
//
//  Created by jsd on 10.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSDate* birthday;

+ (NSArray*) createSudents;

@end
