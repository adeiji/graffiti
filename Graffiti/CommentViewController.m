//
//  CommentViewController.m
//  Graffiti
//
//  Created by Ade on 8/22/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tag.h"
#import "MongoDbConnection.h"

@interface CommentViewController ()
{
    Tag *tag;
}
@end

@implementation CommentViewController

@synthesize txtComment;

#define MONGODB_COLLECTION_NAME @"Graffiti.Tags"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect frame = CGRectMake(7, 5, 227, 34);
        txtComment.frame = frame;
    }
    return self;
}

- (void) setTag : (Tag *) myTag
{
    tag = myTag;
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

- (void) textViewDidChange:(UITextView *)textView
{
    int const MAX_HEIGHT = 70;
    
    if (txtComment.contentSize.height > txtComment.frame.size.height && txtComment.frame.size.height < MAX_HEIGHT)
    {
        CGRect frame = txtComment.frame;
        
        int heightChange = txtComment.contentSize.height - frame.size.height;
        
        //Change the view that the text view is inside by increasing the height, and moving the view up  to compensate for the new height
        frame = txtComment.superview.frame;
        frame.size.height += heightChange;
        frame.origin.y -= heightChange;
        txtComment.superview.frame = frame;
        
        frame = txtComment.frame;
        frame.size.height = txtComment.contentSize.height;
        txtComment.frame = frame;
        
        frame = self.sendButton.frame;
        frame.origin.y += heightChange;
        self.sendButton.frame = frame;
        
        frame = self.tableView.frame;
        frame.size.height -= heightChange;
        self.tableView.frame = frame;
        
        NSLog(@"Height Changed");
    }
    else if (txtComment.contentSize.height < txtComment.frame.size.height)
    {
        CGRect frame = txtComment.frame;
        
        int heightChange = frame.size.height - txtComment.contentSize.height;
        
        //Change the view that the text view is inside by increasing the height, and moving the view up  to compensate for the new height
        frame = txtComment.superview.frame;
        frame.size.height -= heightChange;
        frame.origin.y += heightChange;
        
        txtComment.superview.frame = frame;
        
        frame = txtComment.frame;
        
        frame.size.height = txtComment.contentSize.height;
        txtComment.frame = frame;
        
        frame = self.sendButton.frame;
        
        frame.origin.y -= heightChange;
        
        self.sendButton.frame = frame;
        
        frame = self.tableView.frame;
        frame.size.height += heightChange;
        self.tableView.frame = frame;
        
        NSLog(@"Height Changed");
    }
}

- (IBAction)viewTagsPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Send Button
- (IBAction)sendButtonPressed:(id)sender {
    
    NSMutableArray *updatedConversationArray ;
    
    NSArray *initialConversationArray = [tag valueForKey:@"comments"];
    //If the initialConversationArray is null then the app will crash
    if (![initialConversationArray isEqual:[NSNull null]])
    {
        updatedConversationArray = [[NSMutableArray alloc] initWithArray:initialConversationArray];
    }
    else
    {
        updatedConversationArray = [[NSMutableArray alloc] init];
    }
    
    [updatedConversationArray addObject:txtComment.text];
    
    NSMutableDictionary *oldValue = [[NSMutableDictionary alloc] initWithObjectsAndKeys:initialConversationArray, @"comments", nil];
    
    NSMutableDictionary *newValue = [[NSMutableDictionary alloc] initWithObjectsAndKeys:updatedConversationArray, @"comments", nil];
    
    //Save the content of this tag
    MongoDbConnection *myDbConnection = [[MongoDbConnection alloc] init];
    
    [myDbConnection setUpConnection:MONGODB_COLLECTION_NAME];
    
    //Save the login in the mongoDbDatabase
    [myDbConnection changeValue:oldValue:newValue];
}
@end
