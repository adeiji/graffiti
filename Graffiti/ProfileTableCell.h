//
//  ProfileTableCell.h
//  Graffiti
//
//  Created by Ade on 8/20/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtInputField;

- (void) changeTextFieldLayout;

@end
