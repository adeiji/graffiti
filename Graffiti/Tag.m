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
@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize type;

- (NSManagedObject*) init
{
    return self;
}

- (void) init   :(NSString *) myType
                :(NSString *) myId
                :(NSString *) myContent
                :(NSString *) myImage
                :(NSNumber *) myLatitude
                :(NSNumber *) myLongitude
                :(NSString *) myName
{
    type = myType;
    uid = myId;
    content = myContent;
    image = myImage;
    latitude = myLatitude;
    longitude = myLongitude;
    name = myName;
}

@end
