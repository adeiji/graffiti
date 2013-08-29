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

- (void) SaveContext : (NSString *) userId : (NSString *) password : (NSUUID *) UDID
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
 
    NSManagedObject *loginCredential;
    loginCredential = [NSEntityDescription insertNewObjectForEntityForName:@"Login" inManagedObjectContext:context];
    
    //Save the tag in the database
    [loginCredential setValue:userId forKey:@"username"];
    [loginCredential setValue:password forKey:@"password"];
    [loginCredential setValue:[UDID UUIDString] forKey:@"udid"];
    
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog([NSString stringWithFormat:@"%@", error]);
    }
    NSLog(@"Information Saved");

}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
}

//Receives a number of rows wanted, which tag, and which sort descriptor, and then returns the fetched objects
- (NSArray *) fetchValues : (NSString *) entityName : (NSString *) sortDescriptorName : (int) numOfRows
{
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:numOfRows];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescriptorName ascending:NO];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Login" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
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
