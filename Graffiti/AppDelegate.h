//
//  AppDelegate.h
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DataLayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) DataLayer *controller;

- (NSURL *) applicationDocumentsDirectory;
- (void) saveContext;

@end
