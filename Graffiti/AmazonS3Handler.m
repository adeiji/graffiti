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

- (AmazonS3Handler *) init : (id) content : (NSString *) contentType : (NSString *) tagName
{
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    NSData *contentData = UIImageJPEGRepresentation(content, 1.0);
    
    [self UploadContentToServer:contentData :contentType :tagName];

    return self;
}

- (void) UploadContentToServer : (NSData *) contentData : (NSString *) contentType : (NSString *) tagName
{
    //create an Amazon S3 client to communicate with the service.
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:@"AKIAJ7RF4BNC4O2XJH6Q" withSecretKey:@"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"];
    
    
    NSString *bucketName = [NSString stringWithFormat:@"%@bucket", tagName];
    
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
    return [url absoluteString];
}


@end
