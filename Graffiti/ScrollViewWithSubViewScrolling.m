//
//  ScrollViewWithSubViewScrolling.m
//  Graffiti
//
//  Created by Ade on 8/29/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ScrollViewWithSubViewScrolling.h"

@implementation ScrollViewWithSubViewScrolling

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    
    if ([result.superview isKindOfClass:[UITableView class]] || [result isKindOfClass:[UITableView class]] || [result.superview isKindOfClass:[UITableViewCell class]])
    {
        self.scrollEnabled = NO;
    }
    else
    {
        self.scrollEnabled = YES;
    }
    
    return result;
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
