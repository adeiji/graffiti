//
//  DataLayer.h
//  Graffiti
//
//  Created by Ade on 5/8/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"
#import "AppDelegate.h"

@interface DataLayer : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (void) SaveContext : (NSString *) userId : (NSString *) password : (NSUUID *) UDID;
- (void) SaveContext  :(Tag *) myTag;
//Receives a number of rows wanted, which tag, and which sort descriptor, and then returns the fetched objects
- (NSArray *) fetchValues : (NSString *) entityName : (NSString *) sortDescriptorName : (int) numOfRows;
@end
