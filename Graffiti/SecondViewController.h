//
//  SecondViewController.h
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataLayer.h"

@interface SecondViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UITextView *txtTag;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *audioButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *videoButton;

@property (strong, nonatomic) IBOutlet UINavigationBar *ComposeTagNavBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnTagIt;
@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) UIImagePickerController *picker;
- (IBAction)CameraButtonPressed:(id)sender;
- (IBAction)btnTagItPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)audioButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;

@end
