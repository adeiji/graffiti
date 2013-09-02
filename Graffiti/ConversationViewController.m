//
//  ConversationView.m
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ConversationViewController.h"
#import "TagCell.h"

@implementation ConversationViewController
{
    NSMutableArray *cellHeights;
}
@synthesize conversation;
@synthesize tag;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    cellHeights = [[NSMutableArray alloc] init];
    conversation = [[NSArray alloc] init];
    
    [self.tableView layoutIfNeeded];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    conversation =  [self.tag valueForKey:@"comments"];
    
    if (![conversation isEqual:[NSNull null]])
    {
        return [conversation count];
    }
    
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayTagCell";
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        //Open up what was said in the conversation
        cell.txtConversation.text = [conversation objectAtIndex:indexPath.row];
        [cell.txtConversation setFont:[UIFont systemFontOfSize:14.0f]];
        CGRect frame = cell.txtConversation.frame;
        
        frame.size.height = cell.txtConversation.contentSize.height;
        frame.origin.y = cell.frame.origin.y;
        
        cell.txtConversation.frame = frame;
        
        if ((indexPath.row % 2) == 0)
        {
            UIColor * color = [UIColor colorWithRed:255/255.0f green:226/255.0f blue:191/255.0f alpha:1.0f];
            
            cell.txtConversation.backgroundColor = color;
        }
        
        NSLog(@"Content size: %@", NSStringFromCGSize(self.tableView.contentSize) );
    }
    
    return cell;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Conversation View Controller Pressed");
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil)
    {
        UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 0)];
        
        [self.view addSubview:text];
        
        text.text = [conversation objectAtIndex:indexPath.row];
        [text setFont:[UIFont systemFontOfSize:14.0]];
        text.hidden = YES;
        
        CGSize size = text.contentSize;
        
        text = nil;
        
        return size.height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
