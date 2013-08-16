//
//  GraffitiTabBarController.h
//  Graffiti
//
//  Created by Ade on 8/15/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraffitiTabBarController : UITabBarController <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, retain) UIViewController *myPreviousViewController;

@end
