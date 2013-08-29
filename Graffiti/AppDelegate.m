//
//  AppDelegate.m
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "AppDelegate.h"
#import "DataLayer.h"
#import "SecondViewController.h"
#import "ViewTagsWithDetailViewController.h"
#import "FirstViewController.h"

@implementation AppDelegate

@synthesize window = __window;
@synthesize tagger = __tagger;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //If this is the first time that the user is using the application then we load the login page and after this we add a UDID number to their database
    
    //Check to .see if the database contains a UDID number
    DataLayer *myDataLayer = [[DataLayer alloc] init];
    NSArray *myUDID = [myDataLayer fetchValues:@"Login" : @"udid" : 1];
    
    [self.window makeKeyAndVisible];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    
    //If this is the first time that this app is being run on this device then we open the login screen, otherwise, we set the tagger to the value stored on the device.
    if ([myUDID count] == 0)
    {
        FirstViewController *loginScreen = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        [self.window.rootViewController presentViewController:loginScreen animated:YES completion:nil];
    }
    else
    {
        //Get the tagger name from the database
        NSArray *myTagger = [myDataLayer fetchValues:@"Login" : @"username" : 1];
        self.tagger = [myTagger objectAtIndex:0];
    }
    return YES;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
