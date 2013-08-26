//
//  MainViewTagsViewController.m
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "MainViewTagsViewController.h"
#import "MainViewTagsView.h"

@interface MainViewTagsViewController ()
{
    int pageNumber;
}
@end

@implementation MainViewTagsViewController

- (id) initWithPageNumber:(NSUInteger) page
{
    
    if (self = [super init]) {
        // Initialization code
        pageNumber = page;
        //Set the visible view to the MainViewTagsView class
        MainViewTagsView *view = [[MainViewTagsView alloc] initWithFrame:CGRectMake(0, 20, 320, 960)];
        
        view.contentView.backgroundColor = [UIColor clearColor];
        
        self.view = view.contentView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
