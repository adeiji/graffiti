//
//  FirstViewController.h
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) IBOutlet UITextField *txtUserId;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

-(void) textFieldDidBeginEditing:(UITextField *)textField;
-(void) textFieldDidEndEditing:(UITextField *)textField;

@end
