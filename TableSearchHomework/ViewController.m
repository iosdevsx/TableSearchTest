//
//  ViewController.m
//  TableSearchHomework
//
//  Created by jsd on 10.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "ViewController.h"
#import "JDStudent.h"
#import "JDStudentCell.h"
#import "JDStudentSection.h"
#import "NSDate+DateHelper.h"
#import "NSArray+SortHelper.h"

typedef enum {
    JDStudentSortDate,
    JDStudentSortFirstName,
    JDStudentSortLastName
} JDStudentSort;

static NSString* firstName = @"firstName";
static NSString* lastName = @"lastName";

@interface ViewController ()

@property (strong, nonatomic) NSArray* studentsArray;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) NSOperationQueue* currentOperation;
@property (assign, nonatomic) JDStudentSort sortEnum;
@property (assign, nonatomic) CGPoint lastPosition;
@property (assign, nonatomic) UIImageOrientation scrollOrientation;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentOperation = [[NSOperationQueue alloc] init];
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 25, CGRectGetMidY(self.view.frame) - 25, 50, 50)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dataContainer addSubview:indicator];
    
    [indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:50]];
    [indicator addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:50]];
    
    [self.dataContainer addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dataContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.dataContainer addConstraint:[NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.dataContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.dataContainer addSubview:indicator];
    [indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.studentsArray = [NSArray sortByMonthArray:[JDStudent createSudents]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self generateDateSectionsInBackgroundFromArray:self.studentsArray withFilter:self.searchBar.text];
            [indicator stopAnimating];
            self.dataContainer = self.tableView;
            [indicator removeFromSuperview];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Private Methods

//Выбираем метод для отображения в зависимости от выбранного сегмента
- (void) selectMethodForDisplayData
{
    switch (self.sortControl.selectedSegmentIndex)
    {
        case JDStudentSortDate:
            [self generateDateSectionsInBackgroundFromArray:self.studentsArray
                                                 withFilter:self.searchBar.text];
            break;
        case JDStudentSortFirstName:
            [self generateNameSectionsInBackgroundFromArray:self.studentsArray
                                                 withFilter:self.searchBar.text
                                usingDesriptorKeyForSorting:firstName
                                   andDescriptorForSections:lastName];
            break;
        case JDStudentSortLastName:
            [self generateNameSectionsInBackgroundFromArray:self.studentsArray
                                                 withFilter:self.searchBar.text
                                usingDesriptorKeyForSorting:lastName
                                   andDescriptorForSections:firstName];
            break;
        default:
            break;
    }
}

//Отображение объектов в случае выбора сегмента даты
- (void) generateDateSectionsInBackgroundFromArray: (NSArray*) array withFilter: (NSString*) filter
{
    [self.currentOperation cancelAllOperations];
    __weak ViewController* weakSelf = self;
    
    NSBlockOperation* blockOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation* weakBlockOperation = blockOperation;
    
    [blockOperation addExecutionBlock:^{
        
        //Массив секций
        NSMutableArray* sections = [NSMutableArray array];
        
        //Массив индексов для секций
        NSMutableArray* indexes = [NSMutableArray array];
        
        NSInteger currentMonth = 0;
        
        //Раскидываем студентов по секциям
        for (JDStudent* student in array)
        {
            if (weakBlockOperation.isCancelled)
            {
                break;
            }
                
            if ([filter length] > 0 && [student.firstName rangeOfString:filter].location == NSNotFound)
            {
                continue;
            }
            
            NSDate* bday = [student birthday];
            NSInteger month = [NSDate getMonthFromDate:bday];
            JDStudentSection* section = nil;
            
            if (month != currentMonth)
            {
                section = [[JDStudentSection alloc] init];
                section.sectionName = [NSDate getFormattedMonthFromDate:bday withFormat:@"LLLL"];
                section.students = [NSMutableArray array];
                currentMonth = month;
                [sections addObject:section];
                [indexes addObject:[NSDate getFormattedMonthFromDate:bday withFormat:@"LL"]];
            } else
            {
                section = [sections lastObject];
            }
            
            [section.students addObject:student];
        }
        
        NSSortDescriptor* firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        weakSelf.sections = [NSArray sortStudentsInSectionsArray:sections withDescriptors:@[firstDescriptor, lastDescriptor]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    [self.currentOperation addOperation:blockOperation];
}

//Отображение объектов в случае выбора сегмента имени или фамилии
- (void) generateNameSectionsInBackgroundFromArray: (NSArray*) array
                                        withFilter: (NSString*) filter
                       usingDesriptorKeyForSorting: (NSString*) sortArrayKey
                          andDescriptorForSections: (NSString*) sortSectionsKey
{
    [self.currentOperation cancelAllOperations];
    __weak ViewController* weakSelf = self;
    
    NSMutableArray* sections = [NSMutableArray array];
    NSBlockOperation* blockOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation* weakBlockOperation = blockOperation;
    
    [blockOperation addExecutionBlock:^{
        
        NSMutableArray* students = [NSMutableArray arrayWithArray:array];
        NSSortDescriptor* descriptorForStudents = [[NSSortDescriptor alloc] initWithKey:sortArrayKey ascending:YES];
        [students sortUsingDescriptors:@[descriptorForStudents]];

        NSString* currentLetter = nil;
        JDStudentSection* section = nil;
        
        //Раскидываем студентов по секциям
        for (JDStudent* student in students)
        {
            if (weakBlockOperation.isCancelled)
            {
                break;
            }
            
            if ([filter length] > 0 && [[student valueForKey:sortArrayKey] rangeOfString:filter].location == NSNotFound)
            {
                continue;
            }
            
            NSString* firstLetter = nil;
            firstLetter = [[student valueForKey:sortArrayKey] substringToIndex:1];
            
            if (![currentLetter isEqualToString:firstLetter])
            {
                section = [[JDStudentSection alloc] init];
                section.sectionName = firstLetter;
                section.students = [NSMutableArray array];
                currentLetter = firstLetter;
                [sections addObject:section];
            }
            else
            {
                section = [sections lastObject];
            }
            
            [section.students addObject:student];
        }
        NSSortDescriptor* descriptorForSections = [[NSSortDescriptor alloc] initWithKey:sortSectionsKey ascending:YES];
        weakSelf.sections = [NSArray sortStudentsInSectionsArray:sections withDescriptors:@[descriptorForSections]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.tableView reloadData];
        }];
    }];
    
    [self.currentOperation addOperation:blockOperation];
}

//Генерируем индексы для секций
- (NSArray*) generateIndexesForSections: (NSArray*) sections
{
    NSMutableArray* array = [NSMutableArray array];
    for (JDStudentSection* section in sections)
    {
        NSString* index = [section.sectionName substringToIndex:1];
        [array addObject:index];
    }
    return [NSArray arrayWithArray:array];
}

#pragma mark -UITableViewDataSource

//Количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

//Заголовки для секций
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.sections objectAtIndex:section] sectionName];
}

//Заголовки для индексов секций
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self generateIndexesForSections:self.sections];
}

//Количество элементов в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JDStudentSection* sec = [self.sections objectAtIndex:section];
    return [sec.students count];
}

//Создание ячейки
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    JDStudentCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[JDStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    JDStudentSection* sec = [self.sections objectAtIndex:indexPath.section];
    JDStudent* student = [sec.students objectAtIndex:indexPath.row];
    
    cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.studentBdayLabel.text = [NSDate getFormattedBirthdayForDate:student.birthday];

    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ToDo: Баг в анимации при первом прокручивании
/*- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isDragging)
    {
        if (self.scrollOrientation == UIImageOrientationDown)
        {
            CATransform3D rotation;
            rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
            rotation.m34 = 1.0/ -600;
            
            cell.layer.shadowColor = [[UIColor blackColor]CGColor];
            cell.layer.shadowOffset = CGSizeMake(10, 10);
            cell.alpha = 0;
            
            cell.layer.transform = rotation;
            cell.layer.anchorPoint = CGPointMake(0, 0.5);
            
            [UIView beginAnimations:@"rotation" context:NULL];
            [UIView setAnimationDuration:0.8];
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            [UIView commitAnimations];
        }
    }
}*/

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollOrientation = scrollView.contentOffset.y > self.lastPosition.y ? UIImageOrientationDown : UIImageOrientationUp;
    self.lastPosition = scrollView.contentOffset;
}

#pragma mark -UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self selectMethodForDisplayData];
}

#pragma mark -Actions

- (IBAction)sortControlAction:(UISegmentedControl *)sender
{
    [self selectMethodForDisplayData];
}


@end
