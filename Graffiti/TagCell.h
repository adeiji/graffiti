//
//  TagCell.h
//  Graffiti
//
//  Created by Ade on 8/14/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) UITextView *txtTagContent;

- (void) layoutSubviews;
@property (strong, nonatomic) UITextView *txtConversation;

@end
