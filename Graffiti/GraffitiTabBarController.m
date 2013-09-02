//
//  GraffitiTabBarController.m
//  Graffiti
//
//  Created by Ade on 8/15/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "GraffitiTabBarController.h"
#import "CollectionViewController.h"
#import "CreateGroupViewController.h"
#import "SecondViewController.h"

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
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    
    //Create the view that will contain the table to show the conversations had on this tag.
    CreateGroupViewController  *createGroupViewController = [[UIStoryboard storyboardWithName:@"CreateGroup" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateGroupViewController"];
    
    createGroupViewController.title = @"Create Group";
    createGroupViewController.tabBarItem.image = [UIImage imageNamed:@"spraycan.png"];
    
    [viewControllers addObject:createGroupViewController];
    //Create the view that will handle creating tags
    SecondViewController *tagLocationViewController = [[UIStoryboard storyboardWithName:@"TagLocationStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"TagLocationViewController"];
    
    tagLocationViewController.title = @"Tag";
    tagLocationViewController.tabBarItem.image = [UIImage imageNamed:@"spraycan.png"];
    
    [viewControllers addObject:tagLocationViewController];
    
    UINavigationController *profileNavigationController = [[UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil] instantiateInitialViewController];
    
    profileNavigationController.title = @"Profile";
    profileNavigationController.tabBarItem.image = [UIImage imageNamed:@"spraycan.png"];
    
    [viewControllers addObject:profileNavigationController];
    
    self.viewControllers = viewControllers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //Save the previous view controller so that we can return to this view controller after the user tags the item
    myPreviousViewController = tabBarController.selectedViewController;
    
    return YES;
}
@end
