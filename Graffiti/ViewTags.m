//
//  ViewTags.m
//  Graffiti
//
//  Created by Ade on 8/14/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ViewTags.h"

@implementation ViewTags

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Read Touch Event");
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
