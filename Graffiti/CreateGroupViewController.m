//
//  CreateGroupViewController.m
//  Graffiti
//
//  Created by Ade on 8/30/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "ProfileTableCell.h"
#import "MongoDataLayer.h"

@interface CreateGroupViewController ()
{
    UITextField *activeField;
    NSArray *mongoDbKeyNames;
}
@end

@implementation CreateGroupViewController

static NSString* const mongoTableName = @"graffiti.groups";
static NSString* const NAME_COLUMN_NAME = @"name";
static NSString* const DESCRIPTION_COLUMN_NAME = @"description";
static NSString* const PRIMARY_LOCATION_COLUMN_NAME = @"primaryloc";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //These two arrays carry the section title and the text that will go into the uitextfields
    self.sections = [[NSArray alloc] initWithObjects:@"Name", @"Description", @"Primary Location", nil];
    self.cellInfo = [[NSArray alloc] initWithObjects:@"Enter name...", @"Enter description...", @"Enter primary location...", nil];
    self.tableViewContent = [[NSDictionary alloc] initWithObjects:self.cellInfo forKeys:self.sections];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //Create an array that holds the names of the tables that we're inserting the groups into
    mongoDbKeyNames = [[NSArray alloc] initWithObjects:NAME_COLUMN_NAME, DESCRIPTION_COLUMN_NAME, PRIMARY_LOCATION_COLUMN_NAME, nil];
    
}

- (void) keyboardWasShown:(NSNotification *) aNotification
{
    //decrease the size of the table view and then scroll to the bottom
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 60);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void) keyboardWillBeHidden:(NSNotification *) aNotification
{
    //increase the size of the table view and then scroll to the top
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 60);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Get the section title from the sections array
    NSString *sectionTitle = [self.sections objectAtIndex:section];
    //Create a label that will go into the header view
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
    
    header.font = [UIFont systemFontOfSize:18.0f];
    header.textColor = [UIColor whiteColor];
    header.backgroundColor = [UIColor clearColor];
    header.text = sectionTitle;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    
    //add the label to the header view
    [view addSubview:header];
    
    return view;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableCell *cell = (ProfileTableCell *) [tableView dequeueReusableCellWithIdentifier:@"CreateGroupTableCell" forIndexPath:indexPath];
    
    NSString* key = [self.sections objectAtIndex:indexPath.section];
    
    cell.txtInputField.text = [self.tableViewContent objectForKey:key];
    cell.txtInputField.tag = indexPath.section;
    
    return cell;
}
//Because we have a custom header we need to implement this method
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewContent count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Insert the new group into the groups database
- (IBAction)createGroupButtonPressed:(id)sender {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    //Get all the values from the table
    for (NSInteger section = 0; section < [self.tableView numberOfSections]; section++)
    {
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:section]; row ++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            ProfileTableCell *cell = (ProfileTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [sections addObject:[mongoDbKeyNames objectAtIndex:section]];
            
            NSLog(@"Added header - %@ - to sections array ", [mongoDbKeyNames objectAtIndex:section]);
            NSLog(@"Added text value - %@ - to values array ", cell.txtInputField.text);            
            [values addObject:cell.txtInputField.text];
        }
    }
    //Create a dictionary with all necessary values and it enter the new groups collection
    NSDictionary *dataToEnterIntoMongo = [[NSDictionary alloc] initWithObjects:values forKeys:sections];
    [MongoDataLayer insertData:dataToEnterIntoMongo tableName:mongoTableName];
}

@end
