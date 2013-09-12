//
//  TagAudioViewController.m
//  Graffiti
//
//  Created by Ade on 9/4/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "TagAudioViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TagAudioViewController ()
{
    bool isHoldingRecord;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@end

@implementation TagAudioViewController

@synthesize timer;
@synthesize audioUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"audio.m4a", nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    //Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //enables both audio input and output
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Play Button Actions

- (IBAction)playButtonPressed:(id)sender {
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    [player setDelegate:self];
    [player play];
}

- (IBAction)playButtonReleased:(id)sender {
    
}

- (IBAction)saveAudio:(id)sender {
    audioUrl = [recorder url];
}

- (void) showRecordingLength
{
    //Shows how much more time the user can enter the audio for
    if (self.audioLengthImageView.frame.size.width < 313)
    {
        
    }
}

#pragma mark - Record Button Actions

- (IBAction)recordButtonPressed:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(showRecordingLength) userInfo:nil repeats:YES];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    //start recording
    [recorder record];
}

- (IBAction)recordButtonReleased:(id)sender {
    [timer invalidate];
    timer = nil;
    
    [recorder stop];
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)useAudioPressed:(id)sender {
    [self saveAudio:sender];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
