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
#import "TagCell.h"
#import "TagEnumValue.h"
#import "MongoDbTags.h"

@interface CommentViewController ()
{
    Tag* tag;
    NSMutableArray *cellHeights;
}

@end

@implementation CommentViewController

@synthesize txtComment;
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

- (void) setTag:(Tag *)myTag
{
    tag = myTag;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //Remove all the memory allocations
    self.view = nil;
    self.tag = nil;
    self.txtComment = nil;
    self.tableView = nil;
    self.barView = nil;
    self.sendButton = nil;
    self.tableViewSpaceToBottomConstraint = nil;
    self.textViewSpaceToTopConstraint = nil;
    self.textViewHeightConstraint = nil;
    self.initialConversationArray = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [txtComment becomeFirstResponder];
    txtComment.layer.borderWidth = 1.0f;
    txtComment.layer.borderColor = [[UIColor grayColor] CGColor];
    
    txtComment.contentInset = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    cellHeights = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textViewDidChange:(UITextView *)textView
{
    int const MAX_HEIGHT = 70;
    static int line = 1;
    int originalTextViewHeight = txtComment.frame.size.height;
    
    NSLog(@"Comment View Controller text view content size: %@", NSStringFromCGSize(txtComment.contentSize));
    NSLog(@"Comment View Controller text view frame size: %@", NSStringFromCGSize(txtComment.frame.size));
    
    if (txtComment.contentSize.height + txtComment.contentInset.bottom + txtComment.contentInset.top > txtComment.frame.size.height && txtComment.frame.size.height < MAX_HEIGHT)
    {
        line++;
        int textViewHeight = (line * txtComment.font.lineHeight) + txtComment.contentInset.bottom + txtComment.contentInset.top;
        
        int heightDifference = textViewHeight - originalTextViewHeight;
        
        self.tableViewSpaceToBottomConstraint.constant += heightDifference;
   
        NSLog(@"Height of Comment View Controller Text Changed");
        NSLog(@"Text View Frame : %@",NSStringFromCGRect(txtComment.frame));
        
        textViewHeight = 0;
        heightDifference = 0;
    }
    else if (txtComment.contentSize.height + txtComment.contentInset.bottom + txtComment.contentInset.top < txtComment.frame.size.height)
    {
        line --;
        int textViewHeight = (line * txtComment.font.lineHeight) + txtComment.contentInset.bottom + txtComment.contentInset.top;
        int heightDifference = originalTextViewHeight - textViewHeight;

        self.tableViewSpaceToBottomConstraint.constant -= heightDifference;
        
        textViewHeight = 0;
        heightDifference = 0;
    }
    
}

- (IBAction)viewTagsPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Send Button
- (IBAction)sendButtonPressed:(id)sender {
    
    NSMutableArray *updatedConversationArray ;
    
    self.initialConversationArray = [tag valueForKey:[TagEnumValue getStringValue:TAG_COMMENTS_COLUMN]];
    //If the initialConversationArray is null then the app will crash
    if (![self.initialConversationArray isEqual:[NSNull null]])
    {
        updatedConversationArray = [[NSMutableArray alloc] initWithArray:self.initialConversationArray];
    }
    else
    {
        updatedConversationArray = [[NSMutableArray alloc] init];
    }
    
    [updatedConversationArray addObject:txtComment.text];
    
    NSMutableDictionary *oldValue = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.initialConversationArray, [TagEnumValue getStringValue:TAG_COMMENTS_COLUMN], nil];
    
    NSMutableDictionary *newValue = [[NSMutableDictionary alloc] initWithObjectsAndKeys:updatedConversationArray, [TagEnumValue getStringValue:TAG_COMMENTS_COLUMN], nil];
    
    //Save the content of this tag
    MongoDbConnection *myDbConnection = [[MongoDbConnection alloc] init];
    
    [myDbConnection setUpConnection:[TagEnumValue getStringValue:TAGS_TABLE]];
    
    //Save the login in the mongoDbDatabase
    [myDbConnection changeValue:oldValue:newValue];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.initialConversationArray =  [tag valueForKey:[TagEnumValue getStringValue:TAG_COMMENTS_COLUMN]];
    
    if (![self.initialConversationArray isEqual:[NSNull null]])
    {
        return [self.initialConversationArray count];
    }
    
    self.initialConversationArray = nil;
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayCommentsCell";
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.txtConversation.backgroundColor = [UIColor clearColor];
    [cell.txtConversation setTextColor:[UIColor whiteColor]];
    [cell.txtConversation setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.txtConversation setEditable:NO];
    
    //Open up what was said in the initialConversationArray
    cell.txtConversation.text = [self.initialConversationArray objectAtIndex:indexPath.row];
    
//    CGRect frame = cell.txtConversation.frame;
//    
//    frame.size.height = cell.txtConversation.contentSize.height;
//    //frame.origin.y = cell.frame.origin.y;
//    frame.size.width = 320;
//    cell.txtConversation.frame = frame;
    
    NSLog(@"Table content height is %@", NSStringFromCGSize(self.tableView.contentSize));
    NSLog(@"Cell Subview : %@", [cell.subviews description]);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comment = [self.initialConversationArray objectAtIndex:indexPath.row];
    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height * 2;
}


@end
