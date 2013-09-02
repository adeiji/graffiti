//
//  ExpandingTextView.m
//  Graffiti
//
//  Created by Ade on 8/29/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ExpandingTextView.h"

@implementation ExpandingTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL) shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text
{
    CGRect frame = self.frame;
    
    frame.size.height = self.contentSize.height;
    frame.origin.y = self.frame.origin.y;
    
    self.frame = frame;
    
    return TRUE;
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
