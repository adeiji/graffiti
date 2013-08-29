//
//  RefreshButtonViewController.m
//  Graffiti
//
//  Created by Ade on 8/29/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "RefreshButtonViewController.h"
#import "RefreshButtonView.h"

@interface RefreshButtonViewController ()

@end

@implementation RefreshButtonViewController

- (id) init
{
    if (self = [super init]) {
        //This must be called in order to create all of our objects in the nib file
        RefreshButtonView *mainView = [[RefreshButtonView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        
        self.view = mainView;
        
        [self viewDidLoad];
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
