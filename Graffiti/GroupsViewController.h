//
//  GroupsViewController.h
//  Graffiti
//
//  Created by Ade on 8/21/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MongoDbConnection.h"

@interface GroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MongoDbConnection *connection;
@property (strong, nonatomic) NSMutableArray *groups;

@end
