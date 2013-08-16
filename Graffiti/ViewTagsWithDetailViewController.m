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

@property float cellHeight;
@property (strong, nonatomic) UIView *containerView;

- (void) centerScrollViewContents;

@end

@implementation ViewTagsWithDetailViewController

@synthesize myTags;
@synthesize viewTags;
@synthesize dataLayer;
@synthesize imgContent;
@synthesize viewAllTagsDetailView;
@synthesize txtContent;
@synthesize myTableView;
@synthesize cellHeight;
@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

- (void)viewDidLoad
{
//    viewAllTagsDetailView = [[ViewAllTagDetailView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    viewTags.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    
    dataLayer = [[DataLayer alloc] init];
    myTags = [dataLayer GetFiftyRecords];
    
    [self gotoFirstRowInTable];
}

- (void) viewDidAppear:(BOOL)animated
{
    [myTableView reloadData];
}

//Select the first row of the table view
- (void) gotoFirstRowInTable
{
    if ([myTags count] > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [myTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}



#pragma mark - Table View Delegate Methods

//TableDataSource protocal method
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myTags count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayTagCell";
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Get the correct information from the database specific to this tag
    NSString *myTagger = [[myTags objectAtIndex:indexPath.row] valueForKey:@"tagger"];
    NSString *myDate = [[myTags objectAtIndex:indexPath.row] valueForKey:@"dateTime"];
    NSString *myContent = [[myTags objectAtIndex:indexPath.row] valueForKey:@"content"];
    NSString *myConversation = [[myTags objectAtIndex:indexPath.row] valueForKey:@"conversation"];
    NSString *myLatitude = [[myTags objectAtIndex:indexPath.row] valueForKey:@"latitude"];
    NSString *myLongitude = [[myTags objectAtIndex:indexPath.row] valueForKey:@"longitude"];
    NSString *myGroup = [[myTags objectAtIndex:indexPath.row] valueForKey:@"groups"];
    
    //If an image is stored here, than get the image from the data table in the database
    NSMutableString *myTagDetails = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"Tagger - %@\nDate Uploaded - %@\nContent - %@\nConversation - %@\nLocation - %@, %@\nGroup - %@", myTagger, myDate, myContent, myConversation, myLatitude, myLongitude, myGroup]];
    
    //Set the height of the TableViewCell to the height of the text containing the content
    [cell.txtTagContent sizeToFit];
    
    cell.txtTagContent.text = myTagDetails;
    [cell.contentView addSubview:cell.txtTagContent];
    
    //Set the height of the cell's text view to the height of the content within it.  Dynamic height.
    CGRect frame =  cell.txtTagContent.frame;
    frame.size.height = cell.txtTagContent.contentSize.height;
    cell.txtTagContent.frame = frame;
    cellHeight = cell.txtTagContent.frame.size.height;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgContent.image = [UIImage imageWithData:[[myTags objectAtIndex:indexPath.row] valueForKey:@"data"]];
}

@end
