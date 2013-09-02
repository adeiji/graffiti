//
//  CreateGroupViewController.h
//  Graffiti
//
//  Created by Ade on 8/30/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSDictionary *tableViewContent;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *cellInfo;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)createGroupButtonPressed:(id)sender;


@end
