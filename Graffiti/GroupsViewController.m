//
//  GroupsViewController.m
//  Graffiti
//
//  Created by Ade on 8/21/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "GroupsViewController.h"
#import "MongoDbConnection.h"
#import "BSONDecoder.h"
#import "BSONDocument.h" 
#import "BSONParser.h"
#import "ShowGroupTableCell.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

@synthesize connection = __connection;
@synthesize groups = __groups;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.connection = [[MongoDbConnection alloc] init];
    [self.connection setUpConnection:@"Graffiti.groups"];

    BSONParser *parse = [[BSONParser alloc] init];
    self.groups = [parse parseBSONFiles:[self.connection getAllValuesFromTable:@"group"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"displayGroupCell";
    ShowGroupTableCell *cell = (ShowGroupTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.groups objectAtIndex:indexPath.row];
    
    cell.lblGroup.text = [dictionary objectForKey:@"group"];
    
    return cell;
}

@end
