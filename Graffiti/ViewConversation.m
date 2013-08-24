//
//  ViewConversation.m
//  Graffiti
//
//  Created by Ade on 8/24/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ViewConversation.h"

@implementation ViewConversation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"ViewConversation" owner:self options:nil];
        
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
