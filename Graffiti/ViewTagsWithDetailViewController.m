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
#import "ConversationViewController.h"
#import "MongoDbConnection.h"
#import "BSONParser.h"
#import "CommentViewController.h"
#import "RefreshButtonViewController.h"
#import "RefreshButtonView.h"

@interface ViewTagsWithDetailViewController ()
{
    int previousTagCount;
    int currentTagCount;
}
@property float cellHeight;

@property (strong, nonatomic) UIView *containerView;

- (void) centerScrollViewContents;

@end

@implementation ViewTagsWithDetailViewController

@synthesize tags;
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

#define mongoDbCollectionName @"Graffiti.tags"

#define COMMENT_BUTTON_HEIGHT_CONSTRAINT @"commentButtonHeightConstraint"
#define COMMENT_BUTTON_WIDTH_CONSTRAINT @"commentButtonWidthConstraint"
#define COMMENT_BUTTON_CONSTRAINTS_ARRAY @"commentButtonConstraintsArray"
#define COMMENT_BUTTON_SPACE_TO_TABLE_CONSTRAINT @"commentButtonSpaceToTableConstraint"
#define COMMENT_BUTTON_SUPERVIEW @"commentButtonSuperview"
#define COMMENT_BUTTON_SPACE_TO_TOP_CONSTRAINT @"commentButtonSpaceToTopConstraint"
#define COMMENT_BUTTON_CENTER_X_CONSTRAINT @"commentButtonCenterX"


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
    
    
    [self.scrollView addSubview:self.horizontalPageControl];
}

- (void) loadTags
{
    BSONParser *parse = [[BSONParser alloc] init];
    MongoDbConnection *connection = [[MongoDbConnection alloc] init];
    
    [connection setUpConnection:mongoDbCollectionName];
    tags = [[NSArray alloc] initWithArray:[parse parseBSONFiles:[MongoDbConnection getValues:[TagEnumValue getStringValue:GETTER_GET_ALL_VALUES] keyPathToSearch:[TagEnumValue getStringValue:GETTER_NO_KEY] collectionName:[TagEnumValue getStringValue:TAGS_TABLE]]]];
}

- (void) setUpPaging
{
    NSUInteger numberOfPages = [tags count] + 1;
    
    //View controllers are created lazily
    static NSMutableArray *controllers;
    
    controllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberOfPages; i++ )
    {
        //Load with placeholder objects, and they will be replaced on demand
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    
    //This array will hold the conversation Controllers so that they are not released and we cannot scroll because the delegate will be set to nil.
    if (!self.conversationControllers)
    {
        self.conversationControllers = [[NSMutableArray alloc] init];
    }
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberOfPages, CGRectGetHeight(self.scrollView.frame));
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.scrollsToTop = NO;
    
    self.horizontalPageControl.numberOfPages = numberOfPages;
    
    // set the current page to whatever page is currently being displayed right now
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.horizontalPageControl.currentPage = page;;
}

- (UIViewController *) createCompleteViewControllerWithPagingEnabled : (NSInteger) page
{
    UIViewController *viewCompleteTag = [[UIViewController alloc] init];
    
    //Page Control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    //Scroll View
    CGRect scrollViewFrame = CGRectMake(0, 0, 320, 480);
    UIScrollView *viewCompleteTagScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    //Set the content size to hold two view controllers
    viewCompleteTagScrollView.contentSize = CGSizeMake(320, 480 * 2);
    viewCompleteTagScrollView.scrollEnabled = YES;
    viewCompleteTagScrollView.bounces = YES;
    viewCompleteTagScrollView.pagingEnabled = YES;

    //Main View
    viewCompleteTag.view = [[UIView alloc] init];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:viewCompleteTag.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:320];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:viewCompleteTag.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:480];
    
    NSArray *viewCompleteTagConstraints = [[NSArray alloc] initWithObjects:widthConstraint, heightConstraint, nil];
    
    [viewCompleteTag.view addConstraints:viewCompleteTagConstraints];
    
    [viewCompleteTag.view addSubview:viewCompleteTagScrollView];
    [viewCompleteTagScrollView addSubview:pageControl];
    
    //The View Controller that will actually display all the details of the tag
    MainViewTagsViewController *mainViewTagsViewController = [[MainViewTagsViewController alloc] initWithPageNumber:page :[tags objectAtIndex:page]];
    
    //Create the view that will contain the table to show the conversations had on this tag.
    ConversationViewController *conversationViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"ConversationViewController"];
    
    [conversationViewController.tableView layoutIfNeeded];
    
    conversationViewController.tag = [tags objectAtIndex:page];

    //Change the orientation of the view so that it fits on the next page
    CGRect frame = mainViewTagsViewController.view.frame;
    
    frame.origin.y = 0;
    
    //-----------Add the main view tags controller to the view controller that will allow the vertical paging
    [self addControllerToScrollView:mainViewTagsViewController page:page scrollView:viewCompleteTagScrollView controllerToAddControllerTo:viewCompleteTag frame:frame];
    //set the frame, this step is really for assigning the proper y value
    frame = conversationViewController.view.frame;
    
    frame.origin.y = 480;
    
    [self addControllerToScrollView:conversationViewController page:page scrollView:viewCompleteTagScrollView controllerToAddControllerTo:viewCompleteTag frame:frame];
    
    //You must create the table view variable after the conversationViewController has been added to this view controller
    //Create the two views first so that we can use these two to cretae constraints.
    UITableView *conversationTableView = conversationViewController.tableView;
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //Create a dictionary that will contain the comment Button and conversationTableView, this is then used in the addButtonToViewTags method when adding constraints to the comment button
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(commentButton, conversationTableView);
    
    //-------Add the comment button to the view ------
    [self addButtonToViewTags : conversationViewController.view viewDictionary:viewsDictionary button:commentButton];

    return viewCompleteTag;
}

- (void) loadScrollViewWithPage:(NSUInteger) page
{
    CGRect frame;
    //Number of pages we're going to load
    if (page > [tags count])
        return;
    
    // replace the placeholder if necessary.  Set this view controller to static so that we don't keep loading this information into memory.
    static UIViewController *controller;
    controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        //If this is not the extra page created for the refresh button
        if (page != [tags count])
        {
            controller = [self createCompleteViewControllerWithPagingEnabled : page];
            
            [self.viewControllers replaceObjectAtIndex:page withObject:controller];
            
            frame = self.scrollView.frame;
            frame.origin.x = CGRectGetWidth(frame) * page;
            frame.origin.y = 0;
        }
        else
        {
            //Add a refresh button to the very end of the scroll
            controller = [[RefreshButtonViewController alloc] init];
            
            static RefreshButtonView *refreshView;
            refreshView = (RefreshButtonView*) controller.view;
            [refreshView setControlToRefresh:self];
            
            controller.view = refreshView;
            
            [self.viewControllers replaceObjectAtIndex:page withObject:controller];
            
            frame = self.scrollView.frame;
            frame.origin.x = CGRectGetWidth(frame) * page;
            frame.origin.y = 0;
        }
        
        //Add the controller's view to the scroll view
        [self addControllerToScrollView:controller page:page scrollView:self.scrollView controllerToAddControllerTo:self frame:frame];
    }
}

- (void) addControllerToScrollView : (UIViewController *) controller
                              page : (NSInteger) page
                        scrollView : (UIScrollView *) scrollView
        controllerToAddControllerTo: (UIViewController *) controllerToAddControllerTo
                             frame : (CGRect) frame
{
    // Check to see if this controller has already been added to any view
    if (controller.view.superview == nil)
    {
        controller.view.frame = frame;
        
        [controllerToAddControllerTo addChildViewController:controller];
        [scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
    }
}


// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.horizontalPageControl.currentPage = page;
    
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
              viewDictionary : (NSDictionary *) viewDictionary
                      button : (UIButton *) commentButton
{
    commentButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:commentButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:commentButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75];
    
    //Add the height and width constraints to the button itself
    NSArray *constraints = [[NSArray alloc] initWithObjects:heightConstraint, widthConstraint, nil];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"commentbutton.png"];
    
    //Set the image background
    [commentButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [commentButton addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchDown];
    commentButton.userInteractionEnabled = YES;
    
    [view addSubview:commentButton];
    [commentButton addConstraints:constraints];
    
    //Create the constraint that will keep the button 20 pixels from the top
    NSArray *spaceToTable = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentButton]-20-[conversationTableView]" options:0 metrics:nil views:viewDictionary];
    //Create the view that will hold the commentbutton superview so that we can add it to NSDictionaryOfVariableBindings to use with the constraint.
    UIView *superView = commentButton.superview;
    
    //Store the comment button and it's superview in the dictionary to use for the constraint
    viewDictionary = NSDictionaryOfVariableBindings(superView, commentButton);
    
    NSArray *spaceToTop = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[commentButton]-180-[superView]" options:0 metrics:nil views:viewDictionary];
    
    //Create the constraint that will keep the button in the middle
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:commentButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:commentButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    constraints = [[NSArray alloc] initWithObjects:[spaceToTable objectAtIndex:0], [spaceToTop objectAtIndex:0], centerX, nil];
    [commentButton.superview addConstraints:constraints];

    [self.cache setObject:heightConstraint forKey:COMMENT_BUTTON_HEIGHT_CONSTRAINT];
    [self.cache setObject:constraints forKey:COMMENT_BUTTON_CONSTRAINTS_ARRAY];
    [self.cache setObject:widthConstraint forKey:COMMENT_BUTTON_WIDTH_CONSTRAINT];
    [self.cache setObject:spaceToTable forKey:COMMENT_BUTTON_SPACE_TO_TABLE_CONSTRAINT];
    [self.cache setObject:superView forKey:COMMENT_BUTTON_SUPERVIEW];
    [self.cache setObject:spaceToTop forKey:COMMENT_BUTTON_SPACE_TO_TOP_CONSTRAINT];
    [self.cache setObject:centerX forKey:COMMENT_BUTTON_CENTER_X_CONSTRAINT];
    
    NSLog(@"Comment Button Frame - %@",NSStringFromCGSize(commentButton.frame.size));
}

- (void) commentButtonPressed
{
    self.commentViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"commentViewController"];
    
    //Set the tag to send to the comment view controller so that way the user can comment on the tag
    [self.commentViewController setTag:[tags objectAtIndex:self.horizontalPageControl.currentPage]];
    [self.navigationController pushViewController:self.commentViewController animated:YES];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
//    if (contentsFrame.size.height < boundsSize.height) {
//        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
//    } else {
        contentsFrame.origin.y = 0.0f;
//    }
    
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
    
    for (NSInteger i = 0; i < [self.viewControllers count]; i++)
    {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        if ((NSNull *) controller != [NSNull null])
        {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
    }
    
  //  [super viewDidLoad];
    [self loadTags];
    
}

- (void) refreshController
{
    self.viewControllers = nil;
    
    [self setUpPaging];
    
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    //Get the current page
    NSUInteger page = self.horizontalPageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    if (page > 0)
    {
        [self loadScrollViewWithPage:page - 1];
    }
    
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Load the tags from the MonogoDb
    
    [self refreshController];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    previousTagCount = [tags count];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
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

@end
