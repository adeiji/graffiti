//
//  ViewTagsWithDetailViewController.h
//  Graffiti
//
//  Created by Ade on 7/16/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLayer.h"
#import "ViewAllTagDetailView.h"
#import "TagCell.h"
#import "MainViewTagsViewController.h"
#import "ScrollViewWithSubViewScrolling.h"

@interface ViewTagsWithDetailViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UIScrollViewDelegate>

- (void) loadTags;

@property (strong, nonatomic) IBOutlet ScrollViewWithSubViewScrolling *scrollView;
@property (strong, nonatomic) DataLayer *dataLayer;
@property (strong, nonatomic) NSArray *myTags;

@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UIView *conversationView;
@property (strong, nonatomic) MainViewTagsViewController *mainViewTagsView;
//Stores all the view controllers that will be loaded for paging
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSMutableArray *conversationControllers;

@end
