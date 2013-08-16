//
//  TagCell.h
//  Graffiti
//
//  Created by Ade on 8/14/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCell : UITableViewCell

@property (strong, nonatomic) UITextView *txtTagContent;

- (void) layoutSubviews;

@end
