//
//  ProfileViewController.m
//  Graffiti
//
//  Created by Ade on 8/19/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableCell.h"
#import "GroupsViewController.h"
#import "GroupTableCell.h"
#import "TagEnumValue.h"
#import "MongoDbTags.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

ProfileCellType myProfileCellType;
@synthesize groupsViewController = __groupsViewController;

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
    
    self.groupsViewController = [[UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"groupsViewController"];
    
    self.groupsViewController.profileViewController = self;
    
    _rows = [[NSArray alloc] initWithObjects:@"User Id", @"Password", @"Email", @"Profile Picture", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    ProfileTableCell *cell;
    
    if (indexPath.row != GROUP)
    {
        cellIdentifier = @"profileCell";
        cell = (ProfileTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    [cell changeTextFieldLayout];
    
    //Check to see which row of the table view that we're at
    switch (indexPath.row) {
        case USERNAME:
            cell.txtInputField.text = [_rows objectAtIndex:indexPath.row];
            break;
        case PASSWORD:
            cell.txtInputField.text = [_rows objectAtIndex:indexPath.row];
            cell.txtInputField.secureTextEntry = YES;
            break;
        case EMAIL:
            cell.txtInputField.text = [_rows objectAtIndex:indexPath.row];
            break;
        case PROFILEPICTURE:
            cell.txtInputField.text = [_rows objectAtIndex:indexPath.row];
            break;
        case GROUP:
            cellIdentifier = @"groupCell";
            GroupTableCell *groupCell = (GroupTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            return groupCell;
            break;
    }

    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


//Saves every row in the table to the mongodb database
- (IBAction)saveButtonPressed:(id)sender {
    
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];

    for (NSInteger i = 0; i < [indexPaths count]; i ++)
    {
        NSIndexPath *indexPath = [indexPaths objectAtIndex:i];
        
        if (![[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[GroupTableCell class]])
        {
            
            ProfileTableCell *cell = (ProfileTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //Get all the values from the table according the current row that is currently being traversed.
            switch (indexPath.row) {
                case PROFILE_TABLE_USERNAME_ROW:
                    [content setValue:cell.txtInputField.text forKey:[TagEnumValue getStringValue:PROFILE_NAME_COLUMN]];
                    break;
                case PROFILE_TABLE_PASSWORD_ROW:
                    [content setValue:cell.txtInputField.text forKey:[TagEnumValue getStringValue:PROFILE_PASSWORD_COLUMN]];
                    break;
                case PROFILE_TABLE_EMAIL_ROW:
                    [content setValue:cell.txtInputField.text forKey:[TagEnumValue getStringValue:PROFILE_EMAIL_COLUMN]];
                    break;
                case PROFILE_TABLE_PICTURE_ROW:
                    [content setValue:cell.txtInputField.text forKey:[TagEnumValue getStringValue:PROFILE_PICTURE_COLUMN]];
                    break;
                default:
                    break;
            }
        }
    }
    
    [content setValue:self.groups forKey:[TagEnumValue getStringValue:PROFILE_GROUPS_COLUMN]];
    [content setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:[TagEnumValue getStringValue:PROFILE_UUID_COLUMN]];
    
    [MongoDbConnection insertInfo:content collectionName:[TagEnumValue getStringValue:PROFILE_TABLE]];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
