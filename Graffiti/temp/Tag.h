//
//  Tag.h
//  Graffiti
//
//  Created by Ade on 5/8/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSManagedObjectModel

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *audio;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *name;

-(void) init    :(NSString *) myType
                :(NSString *) myId
                :(NSString *) myContent
                :(NSString *) myImage
                :(NSString *) myAudio
                :(NSString *) myLatitude
                :(NSString *) myLongitude
                :(NSString *) myName;

@end
