//
//  ViewTagsWithDetailViewController.m
//  Graffiti
//
//  Created by Ade on 7/16/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ViewTagsWithDetailViewController.h"
#import "ViewAllTagDetailView.h"
#import "TagCell.h"

@interface ViewTagsWithDetailViewController ()

@end

@implementation ViewTagsWithDetailViewController

@synthesize myTags;
@synthesize dataLayer;
@synthesize lblDetails;
@synthesize lblHeader;
@synthesize imgContent;
@synthesize imgAvatar;
@synthesize viewAllTagsDetailView;

- (void)viewDidLoad
{
//    viewAllTagsDetailView = [[ViewAllTagDetailView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    dataLayer = [[DataLayer alloc] init];
    myTags = [dataLayer GetFiftyRecords];
    
    [self loadTags];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadTags
{
    for (int i = 0; i < [myTags count]; i ++)
    {
        //Get the correct information from the database specific to this tag
        NSString *myContent = [[myTags objectAtIndex:i] valueForKey:@"content"];
        NSString *myType = [[myTags objectAtIndex:i] valueForKey:@"type"];
        //If an image is stored here, than get the image from the data table in the database
        UIImage *myImage = [[UIImage alloc]initWithData:[[myTags objectAtIndex:i]valueForKey:@"data"]];
    
        imgContent.image = myImage;
        lblDetails.text = myContent;
        
        CGRect rect = lblDetails.frame;
        rect.size.height = lblDetails.contentSize.height;
        lblDetails.frame = rect;
    }
}

#pragma mark - Table View Delegate Methods

//TableDataSource protocal method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([myTags count] == 0)
    {
    }
    return [myTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayTagCell";
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Get the correct information from the database specific to this tag
    NSString *myId = [[myTags objectAtIndex:indexPath.row] valueForKey:@"uid"];
    NSString *myContent = [[myTags objectAtIndex:indexPath.row] valueForKey:@"content"];
    NSString *myType = [[myTags objectAtIndex:indexPath.row] valueForKey:@"type"];
    //If an image is stored here, than get the image from the data table in the database
    UIImage *myImage = [[UIImage alloc]initWithData:[[myTags objectAtIndex:indexPath.row]valueForKey:@"data"]];

    NSMutableString *myTagDetails = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@\nType - %@\nDate Uploaded - %@\nDistance - %@\nConversation - %@", myId, myType, @"1-25-2005", @"25 miles", @"Enter later"]];
    
    cell.txtTagContent.text = myTagDetails;
    
    return cell;
}


@end
