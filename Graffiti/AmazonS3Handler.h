//
//  AmazonS3Handler.h
//  Graffiti
//
//  Created by Ade on 5/9/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWSS3/AWSS3.h"

@interface AmazonS3Handler : NSObject <AmazonServiceRequestDelegate>
{
    NSURL *url;
}

- (AmazonS3Handler *) init : (NSDictionary *) myContent;

-(NSString *) GetUrl;

@end
