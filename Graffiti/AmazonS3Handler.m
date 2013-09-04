//
//  AmazonS3Handler.m
//  Graffiti
//
//  Created by Ade on 5/9/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "AmazonS3Handler.h"
#import <AWSRuntime/AWSRuntime.h>

@implementation AmazonS3Handler 

#define CONTENT @"content"
#define CONTENT_TYPE @"contentType"
#define TAG_NAME @"tagName"

- (AmazonS3Handler *) init:(NSDictionary *)myContent
{
    id content = [myContent valueForKey:CONTENT];
    NSString *contentType = [myContent valueForKey:CONTENT_TYPE];
    NSString *tagName = [myContent valueForKey:TAG_NAME];
    
   // [AmazonErrorHandler shouldNotThrowExceptions];
    
    NSData *contentData = UIImageJPEGRepresentation(content, 1.0);
    
    [self UploadContentToServer:contentData :contentType :tagName];
    
    return self;
}

- (void) UploadContentToServer : (NSData *) contentData : (NSString *) contentType : (NSString *) tagName
{
    //create an Amazon S3 client to communicate with the service.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:@"AKIAJ7RF4BNC4O2XJH6Q" withSecretKey:@"kH8GPq5Vm4RG0DolhUWZC5SNaRynjrycT4NYrqU9"];
    
    //We need to remove all the dashes from the vendorId and replace them with periods to adhere to the bucket naming rules.
    NSString *vendorId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    vendorId = [[vendorId stringByReplacingOccurrencesOfString:@"-" withString:@"" ] lowercaseString];
    
    NSLog(@"Reformatted vendor id - %@", vendorId);
    
    //Set the bucketname to the device's vendor identifier so that we add all the files to the same bucket
    NSString *bucketName = [NSString stringWithFormat:@"%@bucket", vendorId];
    
    //Create the bucket to store the image
    [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:bucketName]];
    
    //Put the image object into the bucket
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:tagName inBucket:bucketName];
    
    //If the content type is an image then save this content as an image
    if ([contentType isEqualToString:@"image"])
    {
        por.contentType = @"image/jpeg";
        por.data = contentData;
    }
    
    [s3 putObject:por];
    
    [self AssignUrl:bucketName :tagName :s3];
}

-(void) AssignUrl : (NSString *) bucketName : (NSString *) tagName : (AmazonS3Client *) s3
{
    //create an override content type to ensure that the "content" will be treated as an image by the browser.
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    
    S3GetPreSignedURLRequest *getPreSignedUrlRequest = [[S3GetPreSignedURLRequest alloc] init];
    getPreSignedUrlRequest.key = tagName;
    getPreSignedUrlRequest.bucket = bucketName;
    getPreSignedUrlRequest.expires  = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
    getPreSignedUrlRequest.responseHeaderOverrides = override;
    
    url = [s3 getPreSignedURL:getPreSignedUrlRequest];
}
//Return the url of the content that you've just loaded
-(NSString *) GetUrl
{
    NSLog(@"Tag URL - %@", [url absoluteString]);
    return [url absoluteString];
}


@end
