//
//  ProfileViewController.h
//  Graffiti
//
//  Created by Ade on 8/19/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupsViewController.h"

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

@end
