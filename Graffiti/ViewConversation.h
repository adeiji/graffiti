//
//  ViewConversation.h
//  Graffiti
//
//  Created by Ade on 8/24/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagCell.h"

@interface ViewConversation : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet TagCell *cell;
@property (strong, nonatomic) IBOutlet UITextView *txtConversation;

@end
