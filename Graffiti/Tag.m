//
//  Tag.m
//  Graffiti
//
//  Created by Ade on 5/27/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "Tag.h"


@implementation Tag

@synthesize content;
@synthesize uid;
@synthesize url;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize type;
@synthesize data;
@synthesize conversation;
@synthesize expirationDate;
@synthesize dateTime;
@synthesize tagger;
@synthesize notes;
@synthesize restrictions;
@synthesize groups;


- (NSObject *) init
{
    return self;
}

- (void) init    :(NSString *) myType
                 :(NSString *) myId
                 :(NSString *) myContent
                 :(NSString *) myUrl
                 :(NSNumber *) myLatitude
                 :(NSNumber *) myLongitude
                 :(NSString *) myName
                 :(NSData *) myData
                 :(NSMutableArray *) myConversation
                 :(NSDate *) myExpirationDate
                 :(NSDate *) myDateTime
                 :(NSString *) myTagger
                 :(NSString *) myNotes
                 :(NSString *) myRestrictions
                 :(NSMutableArray *) myGroups;

{
    type = myType;
    uid = myId;
    content = myContent;
    url = myUrl;
    latitude = myLatitude;
    longitude = myLongitude;
    name = myName;
    data = myData;
    conversation = myConversation;
    expirationDate = myExpirationDate;
    dateTime = myDateTime;
    tagger = myTagger;
    notes = myNotes;
    restrictions = myRestrictions;
    groups = myGroups;
}

@end
