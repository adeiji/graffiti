//
//  TagAudioViewController.h
//  Graffiti
//
//  Created by Ade on 9/4/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TagAudioViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) NSTimer *timer;

- (IBAction)recordButtonPressed:(id)sender;
- (IBAction)recordButtonReleased:(id)sender;
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)playButtonReleased:(id)sender;
- (IBAction)saveAudio:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *audioLengthImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *audioLengthRightSpace;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)cancelButtonPressed:(id)sender;
@property (strong, nonatomic) NSURL *audioUrl;


@end
