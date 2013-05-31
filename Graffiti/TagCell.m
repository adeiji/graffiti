//
//  TagCell.m
//  Graffiti
//
//  Created by Ade on 5/31/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.098 green:0.824 blue:0.871 alpha:1.0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
