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

@property (weak, nonatomic) IBOutlet CommentTextView *txtComment;
- (IBAction)sendButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) NSArray * initialConversationArray;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewSpaceToBottomConstraint;
@property ( weak, nonatomic) IBOutlet NSLayoutConstraint *textViewSpaceToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;


- (IBAction)viewTagsPressed:(id)sender;
- (void) setTag : (Tag *) tag;


@end
