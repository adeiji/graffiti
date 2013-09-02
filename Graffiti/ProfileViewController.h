//
//  ProfileViewController.h
//  Graffiti
//
//  Created by Ade on 8/19/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupsViewController;

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

typedef enum
{
    USERNAME = 0,
    PASSWORD = 1,
    EMAIL = 2,
    PROFILEPICTURE = 3,
    GROUP = 4
} ProfileCellType;

@property (strong, nonatomic) GroupsViewController *groupsViewController;

@property (strong, nonatomic) NSArray *rows;
@property (strong, nonatomic) NSArray *groups;
- (IBAction)saveButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
