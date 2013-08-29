//
//  MainViewTagsView.h
//  Graffiti
//
//  Created by Ade on 8/24/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewTagsView : UIView

@property (strong, nonatomic) UIImageView *chainFence;
@property (strong, nonatomic) UITextView *txtConversation;
@property (strong, nonatomic) IBOutlet UITextView *txtTagger;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *tagContent;

@end
