//
//  MongoDbConnection.m
//  Graffiti
//
//  Created by Ade on 8/19/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "MongoDbConnection.h"
#import "ObjCMongoDB.h"
#import "Tag.h"
#import "NSArray+MongoAdditions.h"

@implementation MongoDbConnection

@synthesize dbConn;
@synthesize collection;

//Set the address to the ip of my mac or whatever the ip address is of the server
#define address @"54.213.167.56"

//mac home address - 192.168.1.129

- (void) setUpConnection : (NSString *) collectionName
{
    NSError *error = nil;
    //Create the connection and access the collectionName
    dbConn = [MongoConnection connectionForServer:address error:&error];
    collection = [dbConn collectionWithName:collectionName];
}

- (void) insertTag : (Tag*) myTag
{
    NSError *error = nil;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:myTag.dateTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    NSString *expirationDateString = [NSDateFormatter localizedStringFromDate:myTag.expirationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    NSDictionary *tagInfo = @{
                                @"uid" : [NSString stringWithFormat:@"\"%@\"", myTag.uid],
                                @"comments" : [NSNull null],
                                @"content" : [NSString stringWithFormat:@"\"%@\"", myTag.content],
                                @"dateTime" : [NSString stringWithFormat:@"\"%@\"", dateString ],
                                @"expirationDate" : [NSString stringWithFormat:@"\"%@\"", expirationDateString],
                                @"groups" : @[
                                        @{
                                            @"group" : [[NSArray alloc ] initWithArray:myTag.groups]
                                            }
                                        ],
                                @"image" : [NSString stringWithFormat:@"\"%@\"", myTag.image],
                                @"longitude" : [NSString stringWithFormat:@"\"%@\"", myTag.longitude],
                                @"latitude" : [NSString stringWithFormat:@"\"%@\"", myTag.latitude],
                                @"name" : [NSString stringWithFormat:@"\"%@\"", myTag.name],
                                @"notes" : [NSString stringWithFormat:@"\"%@\"", myTag.notes],
                                @"expirationDate" : [NSString stringWithFormat:@"\"%@\"", expirationDateString],
                                @"expirationDate" : [NSString stringWithFormat:@"\"%@\"", expirationDateString],
                                @"device" : @[
                                        @{
                                            @"device" : [NSString stringWithFormat:@"\"%@\"", @"THIS"]
                                            }
                                        ]
                                };
    
    [collection insertDictionary:tagInfo writeConcern:nil error:&error];
    
    //Deallocate strings
    dateString =  nil;
    expirationDateString = nil;
}

//Receieve the credential information and store it into the mongodb database
- (void) insertCredential : (NSString *) userName
                          : (NSString *) password
                          : (NSString *) device
{
    NSError *error = nil;
    NSDictionary *loginInfo = @{
                                @"userid" : [NSString stringWithFormat:@"\"%@\"", userName],
                                @"password" : [NSString stringWithFormat:@"\"%@\"", password],
                                @"device" : @[
                                        @{
                                            @"device" : [NSString stringWithFormat:@"\"%@\"", device]
                                        }
                                    ]
                                };
    
    [collection insertDictionary:loginInfo writeConcern:nil error:&error];
}

- (NSDictionary *) getValues : (NSString *) valueToGet : (NSString *) keyPathToSearch
{
    NSError *error = nil;
    MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
    [predicate keyPath:keyPathToSearch matches:valueToGet];
    BSONDocument *resultDoc = [collection findOneWithPredicate:predicate error:&error];
    NSDictionary * result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
    NSLog(@"fetch result: %@", result);
    
    
    return result;
}

//Returns all the values from a given table given a specific key path
- (NSArray *) getAllValuesFromTable
{
    NSError *error = nil;
    //Gets an array of BSON documents
    NSArray *result = [collection findAllWithError:&error];
    NSLog(@"fetch result: %@", result);
    
    return [collection findAllWithError:&error];
}

- (void) changeUserName : (NSString*) oldUserName : (NSString *) newUserName : (NSString *) keyPathToSearch
{
    NSError *error = nil;
    MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
    [predicate keyPath:keyPathToSearch matches:oldUserName];
    
    MongoUpdateRequest *updateRequest = [MongoUpdateRequest updateRequestWithPredicate:predicate firstMatchOnly:YES];
    [updateRequest keyPath:keyPathToSearch setValue:newUserName];
    
    [collection updateWithRequest:updateRequest error:&error];
    
    BSONDocument *resultDoc = [collection findOneWithPredicate:predicate error:&error];
    NSDictionary *result = [BSONDecoder decodeDictionaryWithDocument:resultDoc];
    NSLog(@"fetch result after update: %@", result);
}

- (void) changeValue : (NSDictionary *) oldValue
                     : (NSDictionary *) newValue
{
    //This dictionary contains all the Column names and dictionaries that contain the old and new values
    for (NSString *columnName in [oldValue allKeys])
    {
        NSError *error = nil;
        MongoKeyedPredicate *predicate = [MongoKeyedPredicate predicate];
        //Set the predicate to search for the given column name with the old value
        [predicate keyPath:columnName matches:[oldValue objectForKey:columnName]];
        
        MongoUpdateRequest *updateRequest = [MongoUpdateRequest updateRequestWithPredicate:predicate firstMatchOnly:YES];
        //Update the old value with the new value.
        [updateRequest keyPath:columnName setValue:[newValue objectForKey:columnName]];
        [collection updateWithRequest:updateRequest error:&error];
    }
   
}


@end
