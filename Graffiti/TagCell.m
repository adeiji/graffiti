//
//  TagCell.m
//  Graffiti
//
//  Created by Ade on 8/14/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.txtConversation = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 0)];
    self.txtConversation.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:self.txtConversation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
