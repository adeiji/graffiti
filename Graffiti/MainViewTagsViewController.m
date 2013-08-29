//
//  MainViewTagsViewController.m
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "MainViewTagsViewController.h"
#import "MainViewTagsView.h"
#import "Tag.h"
#import "MACircleProgressIndicator.h"
#import "UIImageView+WebCache.h"
#import "UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MainViewTagsViewController ()
{
    int pageNumber;
    NSDictionary* tag;
    MACircleProgressIndicator *circleProgressIndicator;
}
@end

@implementation MainViewTagsViewController

- (id) initWithPageNumber:(NSUInteger) page : (NSDictionary *) myTag
{
    
    if (self = [super init]) {
        // Initialization code
        pageNumber = page;
        //Set the visible view to the MainViewTagsView class
        MainViewTagsView *view = [[MainViewTagsView alloc] initWithFrame:CGRectMake(0, 20, 320, 960)];
        
        view.contentView.backgroundColor = [UIColor clearColor];
    
        //put the circle progress indicator on the view
        circleProgressIndicator = [[MACircleProgressIndicator alloc] initWithFrame:CGRectMake((view.tagContent.frame.size.width / 2) - 25, (view.tagContent.frame.size.height / 2) - 25, 50, 50)];
        
        circleProgressIndicator.value = .1;
        circleProgressIndicator.color = [UIColor greenColor];
        
        [view.tagContent addSubview:circleProgressIndicator];
        
        self.view = (MainViewTagsView *) view.contentView;;
        tag = myTag;
    
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //Fill in all the UI objects with the necessary data, ie image, notes, etc.
    [self fillOutObjects];
}

- (void) fillOutObjects
{
    MainViewTagsView *mainViewTagsView = (MainViewTagsView*) self.view.superview;
    
    circleProgressIndicator.value = 0.4;
    //We need to remove the quotation marks otherwise the application will say that this is not a valid URL.
    NSString *urlString = [[tag valueForKey:@"image"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Show the progress of the image loading as it's loaded
    circleProgressIndicator.value = 0.7;
    
    //Get the data from Amazon S3
    [mainViewTagsView.tagContent setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        circleProgressIndicator.value = 1;
        //Remove the circle at finish of completion
        [circleProgressIndicator removeFromSuperview];
    }];
    
    mainViewTagsView.txtTagger.text = [tag valueForKey:@"name"];
    mainViewTagsView.txtContent.text = [tag valueForKey:@"content"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
