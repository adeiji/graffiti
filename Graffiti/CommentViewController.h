//
//  CommentViewController.h
//  Graffiti
//
//  Created by Ade on 8/22/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "CommentTextView.h"

@interface CommentViewController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet CommentTextView *txtComment;
- (IBAction)sendButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) NSArray *initialConversationArray;

- (IBAction)viewTagsPressed:(id)sender;
- (void) setTag : (Tag *) tag;

@end
