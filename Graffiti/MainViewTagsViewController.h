//
//  MainViewTagsViewController.h
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewTagsViewController : UIViewController

- (id) initWithPageNumber:(NSUInteger) page : (NSDictionary *) tag;

@property (weak, nonatomic) IBOutlet UIImageView *tagContent;
@property (weak, nonatomic) IBOutlet UITextView *txtTagger;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;

- (IBAction)navigateButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *displayTagView;

@property (strong, nonatomic) MPMoviePlayerController *movieController;

@end
