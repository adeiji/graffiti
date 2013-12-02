//
//  GroupsViewController.h
//  Graffiti
//
//  Created by Ade on 8/21/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MongoDbConnection.h"

@class ProfileViewController;

typedef enum {
    PROFILE_TABLE_USERNAME_ROW = 0,
    PROFILE_TABLE_PASSWORD_ROW = 1,
    PROFILE_TABLE_EMAIL_ROW =  2,
    PROFILE_TABLE_PICTURE_ROW = 3,
    PROFILE_TABLE_GROUPS_ROW = 4 
} rowNames;

@interface GroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *groups;

@property (strong, nonatomic) NSArray *groupsSelected;

- (IBAction)saveGroupsPressed:(id)sender;
@property (weak   , nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ProfileViewController *profileViewController;

@end
