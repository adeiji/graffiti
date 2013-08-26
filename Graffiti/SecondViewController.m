//
//  SecondViewController.m
//  Graffiti
//
//  Created by Ade on 5/7/13.
//  Copyright (c) 2013 Ade. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Tag.h"
#import "AmazonS3Handler.h"
#import "DataLayer.h"
#import "AppDelegate.h"
#import "GraffitiTabBarController.h"
#import "MongoDbConnection.h"

@interface SecondViewController ()
{
    Tag *tag;
    UIImage *myImage;
}

@end

@implementation SecondViewController

@synthesize txtTag;
@synthesize ComposeTagNavBar;
@synthesize cameraButton;
@synthesize myLocationManager;
@synthesize myDataLayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    tag = [[Tag alloc] init];
    
    //We do this so that the Keyboard appears immediately when you open the Tag Screen after taking the picture
    [txtTag becomeFirstResponder];
    //Make the title of the Tag Page Tag Location
    
    CGRect frame = ComposeTagNavBar.frame;
    
    frame.origin.y = 0;
    frame.origin.x = 0;
    
    ComposeTagNavBar.frame = frame;
    
    ComposeTagNavBar.topItem.title = @"Tag Location";
    myDataLayer = [[DataLayer alloc] init];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Handles the location services
- (void) InitiateLocationServices
{
    myLocationManager = [[CLLocationManager alloc] init];
    
    //Set the delegate to itself and make sure that we're using the best and most accurate service available which is GPS.
    myLocationManager.delegate = self;
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //Notifice us only when the location changes by more than a certain amount, in this case 1000 meters.
    myLocationManager.distanceFilter = 1000.0f;
    
}


#pragma mark - Camera Non Delegate Methods

-(void) DisplayImage : (UIImage*) image
{
    UIImageView * myImageView = [[UIImageView alloc] initWithImage:image];
    
    myImageView.frame = CGRectMake(20, 20, 100, 100);
}

- (IBAction)CameraButtonPressed:(id)sender {
    // Do any additional setup after loading the view, typically from a nib.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //Check to see if this device uses a camera
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)btnTagItPressed:(id)sender {
    //Here we only want to get the location of the user at this specific location, when tagging this area, therefore, it's not necessary to keep
    //updating the location.
    [self InitiateLocationServices];
    [myLocationManager startUpdatingLocation];
}

- (IBAction)btnCancelPressed:(id)sender {
    
    GraffitiTabBarController *myController = (GraffitiTabBarController *) self.parentViewController;
    
    [self.tabBarController setSelectedViewController:myController.myPreviousViewController];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Get the latitude and longitude values of the current user
    double latitude = [[locations objectAtIndex:0] coordinate].latitude;
    double longitude = [[locations objectAtIndex:0] coordinate].longitude;
    
    NSString *latitudeString = [NSString stringWithFormat:@"%g\u00B0", latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%g\u00B0", longitude];
    
    tag.latitude = [NSNumber numberWithDouble:latitude];
    tag.longitude = [NSNumber numberWithDouble:longitude];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Tagged" message:[NSString stringWithFormat:@"Information tagged at location - Latitude: %@ , Longitude: %@", latitudeString, longitudeString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [alert show];
    //Stop updating the location because now it is uneccesary
    [myLocationManager stopUpdatingLocation];
    [self GetTagName];
}

- (void) GetTagName
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Enter the title of this tag" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    //Create the text field that will be added to the alert view
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}
//Create the tag with the specific name that's given
-(void) CreateTag: (NSString *) name
{
    tag.name = name;
    //Use this where explicit transactions are not allowed.  This creates a unique ID and stores it as an ID using core data
    tag.uid = (__bridge NSString *)(CFUUIDCreate(NULL));
    tag.type = @"image";
    tag.content = txtTag.text;
    tag.data = UIImageJPEGRepresentation(myImage, 1.0);
    //Call the AmazonS3Handler which will add the file to the Amazon Server
    AmazonS3Handler *myS3Handler = [[AmazonS3Handler alloc] init:myImage :tag.type :tag.name];
    //Get the Url of the image that was saved onto the server and then save this url into the database
    NSString *url = [myS3Handler GetUrl];
    tag.image = url;
    tag.conversation = @"This crazy right here man";
    tag.expirationDate =  [self getNextYear];
    tag.dateTime = [[NSDate alloc] init];
    //tag.tagger = self.delegate.tagger;
    tag.tagger = @"adeiji";
    tag.notes = @"NOTES";
    tag.restrictions = @"PUBLIC";
    tag.groups = @"NONE";
    
    //Save the content of this tag
    [myDataLayer SaveContext:tag];
}

- (NSDate *) getNextYear
{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    return nextYear;
}

#pragma mark - Alert View Delegate Methods
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Get the name of the Tag from the alertview textfield and then save this information to the database
    for (UIView* view in alertView.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            NSString *name = [alertView textFieldAtIndex:0].text;
        
            [self CreateTag:name];
        }
    }
}

#pragma mark - Camera Delegate Methods
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //Display the image at the top of the page
    [self DisplayImage:myImage];
    
    [cameraButton setTintColor:[UIColor redColor]];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
     [cameraButton setTintColor:[UIColor clearColor]];
}

#pragma mark - Keyboard Delegate Methods
-(void) keyboardWillShow
{
    
}

@end
