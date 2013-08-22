//
//  CommentViewController.h
//  Graffiti
//
//  Created by Ade on 8/22/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *txtComment;
- (IBAction)viewTagsPressed:(id)sender;

@end
