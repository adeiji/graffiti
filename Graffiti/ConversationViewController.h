//
//  ConversationView.h
//  Graffiti
//
//  Created by Ade on 8/26/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@interface ConversationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Tag* tag;
@property (strong, nonatomic) NSArray *conversation;
@property (strong, nonatomic) IBOutlet NSObject *bottomLayoutGuide;

- (Tag*) tag;


@end
