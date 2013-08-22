//
//  CommentViewController.m
//  Graffiti
//
//  Created by Ade on 8/22/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize txtComment;

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
    
    [txtComment becomeFirstResponder];
    txtComment.layer.borderWidth = 1.0f;
    txtComment.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTagsPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
