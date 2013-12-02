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
#import "CommentViewController.h"

@interface ViewTagsWithDetailViewController : UIViewController <UIGestureRecognizerDelegate, UITextViewDelegate, UIScrollViewDelegate>

- (void) loadTags;

@property (strong, nonatomic) IBOutlet ScrollViewWithSubViewScrolling *scrollView;
@property (strong, nonatomic) NSArray *myTags;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *conversationView;

//View Controllers
@property (strong, nonatomic) MainViewTagsViewController *mainViewTagsView;
@property (strong, nonatomic) CommentViewController *commentViewController;

//Stores all the view controllers that will be loaded for paging
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (weak, nonatomic) IBOutlet UIPageControl *horizontalPageControl;

@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSMutableArray *conversationControllers;

@property (strong, nonatomic) NSCache *cache;

@end
