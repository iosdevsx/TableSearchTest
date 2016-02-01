//
//  ViewController.h
//  TableSearchHomework
//
//  Created by jsd on 10.01.16.
//  Copyright © 2016 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@property (weak, nonatomic) IBOutlet UIView *dataContainer;

@end

