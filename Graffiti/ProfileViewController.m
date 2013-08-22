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
    
    self.groupsViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"groupsViewController"];
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
            cell.txtInputField.text = @"User Id";
            break;
        case PASSWORD:
            cell.txtInputField.text = @"Password";
            break;
        case EMAIL:
            cell.txtInputField.text = @"Email";
            break;
        case PROFILEPICTURE:
            cell.txtInputField.text = @"Profile Picture";
            break;
        case GROUP:
            cellIdentifier = @"groupCell";
            GroupTableCell *groupCell = (GroupTableCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            return groupCell;
            break;
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


@end
