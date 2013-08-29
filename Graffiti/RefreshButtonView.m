//
//  RefreshButtonView.m
//  Graffiti
//
//  Created by Ade on 8/29/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "RefreshButtonView.h"
#import "ViewTagsWithDetailViewController.h"

@implementation RefreshButtonView
{
    ViewTagsWithDetailViewController *myViewToRefresh;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Load the bundle
        [[NSBundle mainBundle] loadNibNamed:@"RefreshButtonView" owner:self options:nil];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        //Show the main content view
        [self addSubview: self.contentView];

    }
    return self;
}

- (void) setControlToRefresh:(ViewTagsWithDetailViewController *)controlToRefresh
{
    myViewToRefresh = controlToRefresh;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)refreshPressed:(id)sender {
    
    SEL loadTagsSelector = @selector(loadTags);
    SEL refreshSelector = @selector(refreshController);
 
    [myViewToRefresh performSelector:loadTagsSelector];
    [myViewToRefresh performSelector:refreshSelector];
    
}
@end
