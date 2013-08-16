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

@interface ViewTagsWithDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgContent;
@property (strong, nonatomic) DataLayer *dataLayer;
@property (strong, nonatomic) NSArray *myTags;
@property (strong, nonatomic) IBOutlet UIView *viewTags;
@property (strong, nonatomic) IBOutlet ViewAllTagDetailView *viewAllTagsDetailView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;


@end
