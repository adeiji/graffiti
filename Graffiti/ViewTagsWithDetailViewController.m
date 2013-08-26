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
#import "MainViewTagsViewController.h"
#import "MainViewTagsView.h" 
#import "ConversationViewController.h"

@interface ViewTagsWithDetailViewController ()

@property float cellHeight;

@property (strong, nonatomic) UIView *containerView;

- (void) centerScrollViewContents;

@end

@implementation ViewTagsWithDetailViewController

@synthesize myTags;
@synthesize dataLayer;
@synthesize myTableView;
@synthesize cellHeight;
@synthesize background;
@synthesize mainView;

@synthesize scrollView = _scrollView;
@synthesize containerView = _containerView;
@synthesize mainViewTagsView;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_CONTENT_HEIGHT 822.0f

#define VIEW_MAIN_X_POSITION 0
#define VIEW_SUB_X_POSITION 20
#define VIEW_MAIN_Y_POSITION 0
#define VIEW_SUB_Y_POSITION 550

#define SWIPE_LEFT @"LEFT"
#define SWIPE_RIGHT @"RIGHT"


- (void)viewDidLoad
{
    //Add the main view to the entire view
    [self.view addSubview:self.mainView];
    
    [self.scrollView setScrollEnabled:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set the UI specs of the mainView view controllers
    {
        //Set the backgrounds to clear so that the image appears through
        self.mainView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        self.scrollView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    }
    
    dataLayer = [[DataLayer alloc] init];
    
    [self gotoFirstRowInTable];
    
    [self.scrollView addSubview:self.pageControl];
    
    [self setUpPaging];
}


- (void) setUpPaging
{
    NSUInteger numberOfPages = 10;
    
    //View controllers are created lazily
    NSMutableArray *controllers = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < numberOfPages; i++ )
    {
        //Load with placeholder objects, and they will be replaced on demand
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberOfPages, CGRectGetHeight(self.scrollView.frame) * 2);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.scrollsToTop = NO;
    
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;
    
    //Pages are created on demand
    //load the visible page and the next one so that the user doesn't get a flash when scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}


- (void) loadScrollViewWithPage:(NSUInteger) page
{
    //Number of pages we're going to load
    if (page >= 5)
        return;
    
    // replace the placeholder if necessary
    MainViewTagsViewController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MainViewTagsViewController alloc] initWithPageNumber:page];
        //Create the view that will contain the table to show the conversations had on this tag.
        ConversationViewController *conversationViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"ConversationViewController"];
        
        //Change the orientation of the view so that it fits on the next page
        CGRect frame = conversationViewController.view.frame;
        
        frame.origin.x = 30;
        frame.origin.y = 550;
        
        frame.size.width = 260;
        frame.size.height = 250;
        
        conversationViewController.view.frame = frame;
        
        [controller.view addSubview:conversationViewController.view];
        
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        
        frame = controller.view.frame;
        
        [self addButtonToViewTags : controller.view];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        frame.size.height = 820;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
    }
}


// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}


//Add a view to the scroll view.  This will be called every time there is a swipe
- (void) addViewToScrollView : (UIView *) view : (NSString *) gestureDirection : (int) x : (int) y
{
    //Set the container size to initialize only the first time with these parameters
    static CGSize containerSize = { 640.0f, CELL_CONTENT_HEIGHT };
    //setup your custom view hierarchy
    static CGRect frame = (CGRect){ { 320.0f , 480.0f }, { 0.0f , 0.0f  } } ;
    
    if ([gestureDirection isEqualToString:SWIPE_LEFT])
    {
        //Add the width of the iPhone screen so that now we can scroll to the proper location
        containerSize.width += CELL_CONTENT_WIDTH;
        frame.origin.x = x + 320.0f;
    }
    else if ([gestureDirection isEqualToString:SWIPE_RIGHT])
    {
        containerSize.width -= CELL_CONTENT_WIDTH;
    }
    else
    {
        frame.origin.x = x;
    }
    //Set the position of the y, this will change between the main view and the view conversation view
    frame.origin.y = y;
    //the width will always be the same no matter the view for now
    frame.size.width = 280;
    //Set the height so that the frame does not read the height at zero
    frame.size.height = view.frame.size.height;
    
    view.frame = frame;
    view.hidden = false;
    
    [self.containerView addSubview:view];
}

//Add the add comment button
- (void) addButtonToViewTags : (UIView *) view
{
    //Create the button
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //Set it on the second view when scrolled down
    CGRect frame = CGRectMake(123, 470, 75, 75);
    myButton.frame = frame;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"commentbutton.png"];
    //Set the image background
    [myButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [myButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchDown];
    myButton.userInteractionEnabled = YES;
    
    [view addSubview:myButton];
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
    
    //txtMessageNotes.text = myContent;
    
    //Set the height of the TableViewCell to the height of the text containing the content
    [cell.txtTagContent sizeToFit];
    
    cell.txtTagContent.text = myTagDetails;
   // [cell.contentView addSubview:cell.txtTagContent];
    
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
    //imgContent.image = [UIImage imageWithData:[[myTags objectAtIndex:indexPath.row] valueForKey:@"data"]];
    //txtMessageNotes.text = [[myTags objectAtIndex:indexPath.row] valueForKey:@"content"];
}

@end
