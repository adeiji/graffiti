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

- (void) SaveContext  :(Tag *) myTag;
- (NSArray *) GetFiftyRecords;
@end
