//
//  ViewAllTagDetailView.h
//  Graffiti
//
//  Created by Ade on 7/16/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLayer.h"

@interface ViewAllTagDetailView : UIView

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImageView *myImageView;
@property (strong, nonatomic) UITextView *myTextView;
@property (strong, nonatomic) DataLayer *dataLayer;
@property (strong, nonatomic) NSArray *myTags;
@property (strong, nonatomic) NSLayoutConstraint *sizeConstraint;

@end
