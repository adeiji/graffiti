//
//  Tag.h
//  Graffiti
//
//  Created by Ade on 5/27/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic, retain) NSMutableArray *conversation;
@property (nonatomic, retain) NSDate *expirationDate;
@property (nonatomic, retain) NSDate *dateTime;
@property (nonatomic, retain) NSString *tagger;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *restrictions;

- (NSObject *) init;

-(void) init    :(NSString *) myType
                :(NSString *) myId
                :(NSString *) myContent
                :(NSString *) myUrl
                :(NSNumber *) myLatitude
                :(NSNumber *) myLongitude
                :(NSString *) myName
                :(NSData *) data
                :(NSMutableArray *) conversation
                :(NSDate *) expirationDate
                :(NSDate *) dateTime
                :(NSString *) tagger
                :(NSString *) notes
                :(NSString *) restrictions
                :(NSMutableArray *) groups;
@end
