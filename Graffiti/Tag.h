//
//  Tag.h
//  Graffiti
//
//  Created by Ade on 5/27/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData *data;

- (NSManagedObject *) init;

-(void) init    :(NSString *) myType
                :(NSString *) myId
                :(NSString *) myContent
                :(NSString *) myImage
                :(NSNumber *) myLatitude
                :(NSNumber *) myLongitude
                :(NSString *) myName
                :(NSData *) data;
@end
