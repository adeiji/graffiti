//
//  ViewAllTagDetailView.m
//  Graffiti
//
//  Created by Ade on 7/16/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ViewAllTagDetailView.h"

@implementation ViewAllTagDetailView

@synthesize myImageView;
@synthesize dataLayer;
@synthesize myTags;
@synthesize sizeConstraint;
@synthesize myTextView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dataLayer = [[DataLayer alloc] init];
//        myTags = [dataLayer GetFiftyRecords];
    }
    
    return self;
}

@end
