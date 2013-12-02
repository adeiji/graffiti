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
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewTagsViewController ()
{
    int pageNumber;
    NSDictionary* tag;
    MACircleProgressIndicator *circleProgressIndicator;
    AVAudioPlayer *player;
    dispatch_queue_t aQueue;
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
    
    //Set Global Concurrent Dispatch Queue to asynchronously load the tag data.
    aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
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
        
        //Open the image using the Global Concurrent Dispatch Queue
        dispatch_async(aQueue, ^{
            [self.tagContent setImageWithURL:url];
            }
        );
    }
    else if ([[tag valueForKey:[TagEnumValue getStringValue:TAG_CONTENT_TYPE_COLUMN]] isEqualToString:[TagEnumValue getStringValue:CONTENT_TYPE_AUDIO]])
    {
        UIButton *playAudio = [UIButton buttonWithType:UIButtonTypeCustom];
        playAudio.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"playButton.png"];
        [playAudio setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [playAudio addTarget:self action:@selector(playAudioButtonPressed) forControlEvents:UIControlEventTouchDown];
        playAudio.userInteractionEnabled = YES;
        
        [self.displayTagView addSubview:playAudio];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:playAudio attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:150];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:playAudio attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:150];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:playAudio attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:playAudio.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:playAudio attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:playAudio.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        
        [playAudio addConstraint:heightConstraint];
        [playAudio addConstraint:widthConstraint];
        
        [playAudio.superview addConstraint:centerX];
        [playAudio.superview addConstraint:centerY];
        
        self.tagContent.hidden = YES;
        
        dispatch_async(aQueue, ^{
            //Setup audio session
            AVAudioSession *session = [AVAudioSession sharedInstance];
            //enables audio output
            [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
            [session setActive:YES error:nil];
        });
    }
    else if ([[tag valueForKey:[TagEnumValue getStringValue:TAG_CONTENT_TYPE_COLUMN]] isEqualToString:[TagEnumValue getStringValue:CONTENT_TYPE_VIDEO]])
    {
        self.movieController = [[MPMoviePlayerController alloc] init];
       // [self.movieController.view setFrame:CGRectMake(0, 0, 150, 150)];
        self.movieController.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *urlString = [[tag valueForKey:[TagEnumValue getStringValue:TAG_DATA_URL_COLUMN]] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [self.movieController setContentURL:url];
        [self.displayTagView addSubview:self.movieController.view];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.movieController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.movieController.view.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.movieController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.movieController.view.superview attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.movieController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.movieController.view.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.movieController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.movieController.view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        
        NSArray *centerConstraints = [[NSArray alloc] initWithObjects:heightConstraint, widthConstraint, centerX, centerY, nil];
        
        [self.movieController.view.superview addConstraints:centerConstraints];
        [self.movieController prepareToPlay];
    }
        
    self.txtTagger.text = [tag valueForKey:@"name"];
    self.txtContent.text = [tag valueForKey:@"content"];
}

- (void) playAudioButtonPressed
{
    NSString *stringUrl = [[tag valueForKey:@"url"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    
    player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
    [player play];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
