//
//  MongoDbConnection.h
//  Graffiti
//
//  Created by Ade on 8/19/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjCMongoDB.h"
#import "Tag.h"

@interface MongoDbConnection : NSObject

@property (nonatomic, retain) MongoConnection *dbConn;
@property (nonatomic, retain) MongoDBCollection *collection;

//Insert the login information along with the device
- (void) insertCredential : (NSString *) userName
                          : (NSString *) password
                          : (NSString *) device;
- (NSDictionary *) getValues : (NSString *) valueToGet : (NSString *) keyPathToSearch;
- (NSArray *) getAllValuesFromTable : (NSString *) keyPath;
- (void) changeUserName : (NSString*) oldUserName : (NSString *) newUserName;
- (void) setUpConnection : (NSString *) collectionName;
- (void) insertTag : (Tag *) myTag;

@end
