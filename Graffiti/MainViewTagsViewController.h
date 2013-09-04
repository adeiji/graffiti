//
//  MainViewTagsViewController.h
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@interface MainViewTagsViewController : UIViewController

- (id) initWithPageNumber:(NSUInteger) page : (NSDictionary *) tag;

@property (strong, nonatomic) IBOutlet UIImageView *tagContent;
@property (strong, nonatomic) IBOutlet UITextView *txtTagger;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;

- (IBAction)navigateButtonPressed:(id)sender;

@end
