//
//  JDStudentSection.h
//  TableSearchHomework
//
//  Created by jsd on 10.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDStudentSection : UITableViewCell

@property (strong, nonatomic) NSString* sectionName;
@property (strong, nonatomic) NSMutableArray* students;

@end
