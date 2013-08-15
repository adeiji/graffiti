//
//  Tag.m
//  Graffiti
//
//  Created by Ade on 5/8/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@synthesize type;
@synthesize _id;
@synthesize content;
@synthesize image;
@synthesize audio;
@synthesize latitude;
@synthesize longitude;
@synthesize name;

-(void) init    :(NSString *) myType
                :(NSString *) myId
                :(NSString *) myContent
                :(NSString *) myImage
                :(NSString *) myAudio
                :(NSString *) myLatitude
                :(NSString *) myLongitude
                :(NSString *) myName
{
    type = myType;
    _id = myId;
    content = myContent;
    image = myImage;
    audio = myAudio;
    latitude = myLatitude;
    longitude = myLongitude;
    name = myName;
}

@end
