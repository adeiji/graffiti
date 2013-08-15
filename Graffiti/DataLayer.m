//
//  DataLayer.m
//  Graffiti
//
//  Created by Ade on 5/8/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "DataLayer.h"
#import "Tag.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataAI/CoreData.h"

@implementation DataLayer

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

- (NSObject*) init
{
    CoreData *coreData = [CoreData sharedInstance];
    self.managedObjectContext = coreData.managedObjectContext;
    
    return self;
}

- (void) SaveContext  :(Tag *) myTag
{
    //First we create the app delegate
    
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSManagedObject *newTag;
    newTag = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    //In order to save the id propertly we must convert first to a string
    CFUUIDRef theUid = CFUUIDCreate(NULL);
    CFStringRef myId = CFUUIDCreateString(NULL, theUid);
    
    //Save the tag in the database
    [newTag setValue:[myTag name] forKey:@"name"];
    [newTag setValue:[myTag type] forKey:@"type"];
    [newTag setValue:[myTag image] forKey:@"image"];
    [newTag setValue:[myTag content] forKey:@"content"];
    [newTag setValue:[myTag latitude] forKey:@"latitude"];
    [newTag setValue:[myTag longitude] forKey:@"longitude"];
    [newTag setValue:(__bridge id)(myId) forKey:@"uid"];
    [newTag setValue:[myTag data] forKey:@"data"];
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog([NSString stringWithFormat:@"%@", error]);
    }
    NSLog(@"Information Saved");
}


- (NSArray *) GetFiftyRecords
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController.fetchedObjects;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController;
}

@end
