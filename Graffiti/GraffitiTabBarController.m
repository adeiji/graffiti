//
//  GraffitiTabBarController.m
//  Graffiti
//
//  Created by Ade on 8/15/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "GraffitiTabBarController.h"

@interface GraffitiTabBarController ()

@end

@implementation GraffitiTabBarController

@synthesize myPreviousViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    myPreviousViewController = tabBarController.selectedViewController;
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    myPreviousViewController = tabBarController.selectedViewController;
    
    return YES;
}
@end
