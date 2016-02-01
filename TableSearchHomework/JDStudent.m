//
//  JDStudent.m
//  TableSearchHomework
//
//  Created by jsd on 10.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import "JDStudent.h"

@implementation JDStudent

static NSString* firstNames[] = {
    @"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
    @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
    @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
    @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
    @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
    @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
    @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
    @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
    @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
    @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie"
};

static NSString* lastNames[] = {
    
    @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
    @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
    @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
    @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
    @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
    @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
    @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
    @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
    @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
    @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook"
};

static int namesCount = 50;

//Создаем 50-100 студентов
+ (NSArray*) createSudents
{
    NSMutableArray* students = [NSMutableArray array];
    for (int i = 0; i < 100; i++)
    {
        JDStudent* student = [self randomStudent];
        [students addObject:student];
    }
    return [NSArray arrayWithArray:students];
}

//Создание студента
+ (JDStudent*) randomStudent
{
    JDStudent* student = [[JDStudent alloc] init];
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    student.birthday = [self generateRandomDate];
    return student;
}

#pragma mark -
#pragma mark ToDo: Переписать на нормальный алгоритм
//Генерация даты
+ (NSDate *) generateRandomDate
{
    NSInteger r1 = arc4random() % 30;
    NSInteger r2 = arc4random() % 12;
    NSInteger r3 = arc4random() % 4;
    
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [NSDateComponents new];
    [components setDay:r1];
    [components setMonth:r2];
    [components setYear:1990+r3];
    
    NSDate *date = [gregorian dateFromComponents:components];
    
    return date;
}

@end
