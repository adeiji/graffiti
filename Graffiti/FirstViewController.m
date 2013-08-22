//
//  FirstViewController.m
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "FirstViewController.h"
#import "DataLayer.h"
#import "MongoDbConnection.h"

@interface FirstViewController ()


@end

@implementation FirstViewController

@synthesize scrollView;
@synthesize activeField;
@synthesize txtPassword;
@synthesize txtUserId;
@synthesize delegate = __delegate;

#define mongoDbCollectionName @"Graffiti.LoginCredentials"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Required line if you want to scroll
    scrollView.contentSize = CGSizeMake(320, 411);
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) registerForKeyboardNotifications
{
    //Make sure when writing the selector, you add the semicolon to the end, for ex, keyboardWasShown: not keyboardWasShown
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

/*Called when thge UIKeyboardDidShowNotification is sent
 This method does three things
 
 1. Get the size of the keyboard
 2. Adjust the bottom content inset of the scroll view by the keyboard height.
 3. Scroll the target text field into view
 */
- (void) keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    //if active text field is hidden by keyboard, scroll so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if(!CGRectContainsPoint(aRect, activeField.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

//Called when the UIKeyboardWillHideNotification is sent
- (void) keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Text Field Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    [textField resignFirstResponder];
}

//User signs in, and we create the login information
- (IBAction)signInPressed:(id)sender {
    
    DataLayer *myDataLayer = [[DataLayer alloc] init];
    MongoDbConnection *myDbConnection = [[MongoDbConnection alloc] init];
    
    [myDbConnection setUpConnection:mongoDbCollectionName];
    
    //Save the login in the mongoDbDatabase
    [myDbConnection insertCredential:txtUserId.text :txtPassword.text : (NSString *) [[UIDevice currentDevice] identifierForVendor]];
    
    //Save the login in the CoreData database on the device
    [myDataLayer SaveContext : txtUserId.text : txtPassword.text : [[UIDevice currentDevice] identifierForVendor]];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.delegate.tagger = txtUserId.text;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return false;
}

@end
