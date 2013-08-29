//
//  RefreshButtonView.h
//  Graffiti
//
//  Created by Ade on 8/29/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTagsWithDetailViewController.h"


@interface RefreshButtonView : UIView

- (IBAction)refreshPressed:(id)sender;

- (void) setControlToRefresh : (ViewTagsWithDetailViewController *) controlToRefresh;

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end
