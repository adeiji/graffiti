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
@synthesize dataLayer;
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
    
    [self.scrollView addSubview:self.pageControl];
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
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberOfPages; i++ )
    {
        //Load with placeholder objects, and they will be replaced on demand
        [controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    //This array will hold the conversation Controllers so that they are not released and we cannot scroll because the delegate will be set to nil.
    self.conversationControllers = [[NSMutableArray alloc] init];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberOfPages, CGRectGetHeight(self.scrollView.frame) * 2);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.scrollsToTop = NO;
    
    self.pageControl.numberOfPages = numberOfPages;
    
    // set the current page to whatever page is currently being displayed right now
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;;
}

- (void) loadScrollViewWithPage:(NSUInteger) page
{
    //Number of pages we're going to load
    if (page > [tags count])
        return;
    
    // replace the placeholder if necessary
    UIViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null])
    {
        //If this is not the extra page created for the refresh button
        if (page != [tags count])
        {
            controller = [[MainViewTagsViewController alloc] initWithPageNumber:page:[tags objectAtIndex:page]];
            //Create the view that will contain the table to show the conversations had on this tag.
            ConversationViewController *conversationViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"ConversationViewController"];
            
            conversationViewController.tag = [tags objectAtIndex:page];
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
            [self.conversationControllers addObject:conversationViewController];
            
         
        }
        else
        {
            //Add a refresh button to the very end of the scroll
            controller = [[RefreshButtonViewController alloc] init];
            
            RefreshButtonView *refreshView = (RefreshButtonView*) controller.view;
            [refreshView setControlToRefresh:self];
            
            controller.view = refreshView;
            
            [self.viewControllers replaceObjectAtIndex:page withObject:controller];

        }
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
    CommentViewController *commentViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"commentViewController"];
    
    //Set the tag to send to the comment view controller so that way the user can comment on the tag
    [commentViewController setTag:[tags objectAtIndex:self.pageControl.currentPage]];
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
  //  [super viewDidLoad];
    [self loadTags];
    
}

- (void) refreshController
{
    [self setUpPaging];
    
    //Get the current page
    NSUInteger page = self.pageControl.currentPage;
    
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
