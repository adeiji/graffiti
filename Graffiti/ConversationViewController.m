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
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    conversation =  [self.tag valueForKey:@"comments"];
    
    return [conversation count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayTagCell";
    TagCell *cell = (TagCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //Open up what was said in the conversation
    cell.txtConversation.text = [conversation objectAtIndex:indexPath.row];

    CGRect frame = cell.txtConversation.frame;
    
    frame.size.height = cell.txtConversation.contentSize.height;
    frame.origin.y = cell.frame.origin.y;
    
    cell.txtConversation.frame = frame;
    
    [cellHeights addObject:@(cell.txtConversation.frame.size.height)];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comment = [conversation objectAtIndex:indexPath.row];
    
    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(260, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}

@end
