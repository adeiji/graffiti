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
@synthesize myTableView;
@synthesize cellHeight;
@synthesize background;
@synthesize mainView;
@synthesize imageView;
@synthesize txtMessageNotes;

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

- (void)viewDidLoad
{
//    viewAllTagsDetailView = [[ViewAllTagDetailView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.scrollView setScrollEnabled:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    viewTags.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    //Set the background to the background image
    self.mainView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    self.imageView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.5f];
    
    dataLayer = [[DataLayer alloc] init];
    
    [self gotoFirstRowInTable];
    
    //Set up the container view to hold your custom view hierarchy
    CGSize containerSize = CGSizeMake(320.0f, 822.0f);
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointMake(0.0f, 0.0f), .size = containerSize}];
    [self.scrollView addSubview:self.containerView];
    
    [self addButtonToViewTags];
    
    //setup your custom view hierarchy
    CGRect frame = viewTags.frame;
    
    frame.origin.y = 550;
    frame.origin.x = 20;
    
    frame.size.width = 280;
    
    viewTags.frame = frame;
    viewTags.hidden = false;
    
    [self.containerView addSubview:viewTags];
    
    //Tell the scroll view the size of the contents
    self.scrollView.contentSize = containerSize;
    
}
//Add the add comment button
- (void) addButtonToViewTags
{
    //Create the button
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //Set it on the second view when scrolled down
    CGRect frame = CGRectMake(123, 470, 75, 75);
    myButton.frame = frame;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"commentbutton.png"];
    
    [myButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [myButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchDown];
    myButton.userInteractionEnabled = YES;
    [self.containerView addSubview:myButton];
    
}

- (void) commentButtonPressed
{
    UIViewController *commentViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"commentViewController"];
    
    [self.navigationController pushViewController:commentViewController animated:YES];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set up the minimum and maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = 1.0f;
    
    [self centerScrollViewContents];
    //Fetch the values from the CoreData Database
    // - Entity Name - Sort Descriptor - Number Of rows to get
    myTags = [dataLayer fetchValues:@"Tag" : @"name" : 20];
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
    NSString *myConversation = [[myTags objectAtIndex:indexPath.row] valueForKey:@"conversation"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [myConversation sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
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
    NSString *myTagDetails = myConversation;
    
    txtMessageNotes.text = myContent;
    
    //Set the height of the TableViewCell to the height of the text containing the content
    [cell.txtTagContent sizeToFit];
    
    cell.txtTagContent.text = myTagDetails;
    [cell.contentView addSubview:cell.txtTagContent];
    
    //Set the height of the cell's text view to the height of the content within it.  Dynamic height.
    CGRect frame =  cell.txtTagContent.frame;
    frame.size.height = cell.txtTagContent.contentSize.height;
    cell.txtTagContent.frame = frame;
    
    cellHeight = cell.txtTagContent.frame.size.height;
    
    //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgContent.image = [UIImage imageWithData:[[myTags objectAtIndex:indexPath.row] valueForKey:@"data"]];
    txtMessageNotes.text = [[myTags objectAtIndex:indexPath.row] valueForKey:@"content"];
}

@end
