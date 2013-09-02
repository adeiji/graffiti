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
#import "MongoDbTags.h"
#import "TagEnumValue.h"
#import "ProfileViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

@synthesize groupsSelected = __groupsSelected;
@synthesize groups = __groups;
@synthesize profileViewController;

static NSString* const cellIdentifier = @"displayGroupCell";
static NSString* const collectionName = @"graffiti.groups";

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
    
    BSONParser *parse = [[BSONParser alloc] init];
    self.groups = [parse parseBSONFiles:[MongoDbConnection getValues:[TagEnumValue getStringValue:GETTER_GET_ALL_VALUES] keyPathToSearch:[TagEnumValue getStringValue:GETTER_NO_KEY] collectionName:collectionName]];
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
    NSString *groupCol = [TagEnumValue getStringValue:GROUP_NAME_COLUMN];
 
    ShowGroupTableCell *cell = (ShowGroupTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.groups objectAtIndex:indexPath.row];
    
    cell.lblGroup.text = [dictionary objectForKey:groupCol];
    
    return cell;
}


- (IBAction)saveGroupsPressed:(id)sender {
    NSMutableArray *selectedRows = [[NSMutableArray alloc] init];
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    
    for (NSInteger i = 0; i < [indexPaths count]; i++)
    {
        ShowGroupTableCell *cell = (ShowGroupTableCell *)[self.tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:i]];
        
        [selectedRows addObject:cell.lblGroup.text];
    }
    
    profileViewController.groups = selectedRows;
    
    NSLog(@"User selected groups - %@", [selectedRows description]);
    NSLog(@"Information added to the profile view controller groups array.");
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
