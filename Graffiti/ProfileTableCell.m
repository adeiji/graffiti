//
//  ProfileTableCell.m
//  Graffiti
//
//  Created by Ade on 8/20/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "ProfileTableCell.h"

@implementation ProfileTableCell

@synthesize txtInputField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) changeTextFieldLayout
{
    txtInputField.backgroundColor = [UIColor clearColor];
    // Border Style None
    [txtInputField setBorderStyle:UITextBorderStyleNone];
}
//If the user clicks on enter then the keyboard should disappear
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}


@end
