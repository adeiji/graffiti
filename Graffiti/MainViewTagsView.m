//
//  MainViewTagsView.m
//  Graffiti
//
//  Created by Ade on 8/24/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "MainViewTagsView.h"

@implementation MainViewTagsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"MainViewTags" owner:self options:nil];
        
        [self addSubview:self.contentView];
    }
    return self;
}

@end
