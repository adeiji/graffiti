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

@interface CommentViewController ()
{
    Tag* tag;
    NSMutableArray *cellHeights;
}

@end

@implementation CommentViewController

@synthesize txtComment;
@synthesize initialConversationArray;

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

- (void) setTag:(Tag *)myTag
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
    
    initialConversationArray = [tag valueForKey:@"comments"];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Methods
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    initialConversationArray =  [tag valueForKey:@"comments"];
    
    if (![initialConversationArray isEqual:[NSNull null]])
    {
        return [initialConversationArray count];
    }
    
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
    cell.txtConversation.text = [initialConversationArray objectAtIndex:indexPath.row];
    
    CGRect frame = cell.txtConversation.frame;
    
    frame.size.height = cell.txtConversation.contentSize.height;
    //frame.origin.y = cell.frame.origin.y;
    frame.size.width = 320;
    cell.txtConversation.frame = frame;
    
    NSLog(@"Table content height is %@", NSStringFromCGSize(self.tableView.contentSize));
    NSLog(@"Cell Subview : %@", [cell.subviews description]);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comment = [initialConversationArray objectAtIndex:indexPath.row];
    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}


@end
