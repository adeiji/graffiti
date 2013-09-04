//
//  MainViewTagsViewController.m
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "MainViewTagsViewController.h"
#import "Tag.h"
#import "MACircleProgressIndicator.h"
#import "UIImageView+WebCache.h"
#import "UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MongoDbTags.h"
#import "TagEnumValue.h"

@interface MainViewTagsViewController ()
{
    int pageNumber;
    NSDictionary* tag;
    MACircleProgressIndicator *circleProgressIndicator;
}
@end

@implementation MainViewTagsViewController

- (id) initWithPageNumber:(NSUInteger) page : (NSDictionary *) myTag
{
    
    if ((self = [[UIStoryboard storyboardWithName:@"ViewTagsStoryboard" bundle:nil] instantiateInitialViewController])) {
        // Initialization code
        pageNumber = page;
        
        
        //put the circle progress indicator on the view
        circleProgressIndicator = [[MACircleProgressIndicator alloc] initWithFrame:CGRectMake((self.tagContent.frame.size.width / 2) - 25, (self.tagContent.frame.size.height / 2) - 25, 50, 50)];
        
        circleProgressIndicator.value = .1;
        circleProgressIndicator.color = [UIColor greenColor];
        
        tag = myTag;
    
        //[self viewDidLoad];
    }
    return self;
}
//Open up Google Maps and show you the directions to how to get to this tag.
- (IBAction)navigateButtonPressed:(id)sender {
    NSNumber *longitude = [tag valueForKey:[TagEnumValue getStringValue:TAG_LONGITUDE_COLUMN]];
    NSNumber *latitude = [tag valueForKey:[TagEnumValue getStringValue:TAG_LATITUDE_COLUMN]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&directionsmode=transit", [latitude doubleValue], [longitude doubleValue]]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //Fill in all the UI objects with the necessary data, ie image, notes, etc.
    [self fillOutObjects];
}

- (void) fillOutObjects
{ 
    circleProgressIndicator.value = 0.4;
    
    if ([[tag valueForKey:[TagEnumValue getStringValue:TAG_CONTENT_TYPE_COLUMN]] isEqualToString:[TagEnumValue getStringValue:CONTENT_TYPE_IMAGE]])
    {
        //We need to remove the quotation marks otherwise the application will say that this is not a valid URL.
        NSString *urlString = [[tag valueForKey:[TagEnumValue getStringValue:TAG_DATA_URL_COLUMN]] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        //Show the progress of the image loading as it's loaded
        circleProgressIndicator.value = 0.7;
        
        //Get the data from Amazon S3
        [self.tagContent setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            circleProgressIndicator.value = 1;
            //Remove the circle at finish of completion
            [circleProgressIndicator removeFromSuperview];
        }];
        }
    self.txtTagger.text = [tag valueForKey:@"name"];
    self.txtContent.text = [tag valueForKey:@"content"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
