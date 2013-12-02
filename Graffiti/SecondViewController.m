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
#import "TagAudioViewController.h"
#import "TagTypes.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SecondViewController ()
{
    Tag *tag;
    UIImage *myImage;
    NSURL *audioUrl;
    TagAudioViewController *tagAudioViewController;
    NSURL *movieUrl;
}

@end

@implementation SecondViewController

@synthesize txtTag;
@synthesize ComposeTagNavBar;
@synthesize cameraButton;
@synthesize myLocationManager;

#define CONTENT @"content"
#define CONTENT_TYPE @"contentType"
#define TAG_NAME @"tagName"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //We do this so that the Keyboard appears immediately when you open the Tag Screen after taking the picture
    [txtTag becomeFirstResponder];
    //Make the title of the Tag Page Tag Location
    
    CGRect frame = ComposeTagNavBar.frame;
    
    frame.origin.y = 0;
    frame.origin.x = 0;
    
    ComposeTagNavBar.frame = frame;
    
    ComposeTagNavBar.topItem.title = @"Tag Location";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Create a new tag every time the screen appears.
    tag = [[Tag alloc] init];
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
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
        //Set the tag type to image
        tag.type = [TagEnumValue getStringValueForTagType:TYPE_IMAGE];
    }
}

- (IBAction)btnTagItPressed:(id)sender {
    //Here we only want to get the location of the user at this specific location, when tagging this area, therefore, it's not necessary to keep
    //updating the location.
    [self InitiateLocationServices];
    [myLocationManager startUpdatingLocation];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self gotoPreviousWindow];
}

- (IBAction)audioButtonPressed:(id)sender {
    
    tagAudioViewController = [[TagAudioViewController alloc] initWithNibName:@"TagAudioView" bundle:nil];
    
    tagAudioViewController.audioUrl = audioUrl;
    tag.type = [TagEnumValue getStringValueForTagType:TYPE_AUDIO];
    
    [self.navigationController pushViewController:tagAudioViewController animated:YES];
    
    [cameraButton setTintColor:[UIColor clearColor]];
    [_audioButton setTintColor:[UIColor redColor]];
}

- (IBAction)videoButtonPressed:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //Check to see if this device uses a camera
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
        [self presentViewController:picker animated:YES completion:nil];
        //Set the tag type to image
        tag.type = [TagEnumValue getStringValueForTagType:TYPE_VIDEO];
    }
}

- (void) gotoPreviousWindow
{
    GraffitiTabBarController *myController = (GraffitiTabBarController *) self.tabBarController;
    
    [self.tabBarController setSelectedViewController:myController.myPreviousViewController];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Get the latitude and longitude values of the current user
    double latitude = [[locations objectAtIndex:0] coordinate].latitude;
    double longitude = [[locations objectAtIndex:0] coordinate].longitude;
    
    tag.latitude = [NSNumber numberWithDouble:latitude];
    tag.longitude = [NSNumber numberWithDouble:longitude];
    
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
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc] init];
    
    tag.name = name;
    
    //Use this where explicit transactions are not allowed.  This creates a unique ID and stores it as an ID using core data
    tag.uid = (__bridge NSString *)(CFUUIDCreate(NULL));
    tag.content = txtTag.text;
    
    
    if ([tag.type isEqualToString:[TagEnumValue getStringValueForTagType:TYPE_IMAGE]])
    {
        tag.data = UIImageJPEGRepresentation(myImage, .2);
    }
    else if ([tag.type isEqualToString:[TagEnumValue getStringValueForTagType:TYPE_AUDIO]])
    {
        tag.data = [NSData dataWithContentsOfURL:tagAudioViewController.audioUrl options:0 error:nil];
    }
    else if ([tag.type isEqualToString:[TagEnumValue getStringValueForTagType:TYPE_VIDEO]])
    {
        tag.data = [NSData dataWithContentsOfURL:movieUrl options:0 error:nil];
    }
    //Add the content information to a dictionary and then send this information to the Amazon S3 Handler so that it can asynchronously upload this data to the S3 server.
    [contentDictionary setObject:tag.data forKey:CONTENT];
    [contentDictionary setObject:tag.type forKey:CONTENT_TYPE];
    [contentDictionary setObject:tag.name forKey:TAG_NAME];
    
    //Call the AmazonS3Handler which will add the file to the Amazon Server
    AmazonS3Handler *myS3Handler = [[AmazonS3Handler alloc] init:contentDictionary];
    
    //Get the Url of the image that was saved onto the server and then save this url into the database
    NSString *url = [myS3Handler GetUrl];
    tag.url = url;
    //[tag.conversation addObject:@"This crazy right here man"];
    tag.expirationDate =  [self getNextYear];
    tag.dateTime = [[NSDate alloc] init];
    //tag.tagger = self.delegate.tagger;
    tag.tagger = @"adeiji";
    tag.notes = @"NOTES";
    tag.restrictions = @"PUBLIC";
    [tag.groups addObject:@"NOTHING"];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:tag.dateTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    NSString *expirationDateString = [NSDateFormatter localizedStringFromDate:tag.expirationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    
    contentDictionary = [[NSMutableDictionary alloc] init];
    [contentDictionary setObject:[NSString stringWithFormat:@"%@",tag.uid] forKey:[TagEnumValue getStringValue:TAG_ID_COLUMN]];
    [contentDictionary setObject:tag.name forKey:[TagEnumValue getStringValue:TAG_NAME_COLUMN]];
    [contentDictionary setObject:tag.type forKey:[TagEnumValue getStringValue:TAG_CONTENT_TYPE_COLUMN]];
    [contentDictionary setObject:tag.content forKey:[TagEnumValue getStringValue:TAG_CONTENT_COLUMN]];
    [contentDictionary setObject:tag.url forKey:[TagEnumValue getStringValue:TAG_DATA_URL_COLUMN]];
    [contentDictionary setObject:tag.conversation forKey:[TagEnumValue getStringValue:TAG_COMMENTS_COLUMN]];
    [contentDictionary setObject:expirationDateString forKey:[TagEnumValue getStringValue:TAG_EXPIRATION_DATE_COLUMN]];
    [contentDictionary setObject:dateString forKey:[TagEnumValue getStringValue:TAG_TIME_DROPPED_COLUMN]];
    [contentDictionary setObject:tag.tagger forKey:[TagEnumValue getStringValue:TAG_TAGGER_COLUMN]];
    [contentDictionary setObject:tag.notes forKey:[TagEnumValue getStringValue:TAG_NOTES_COLUMN]];
    [contentDictionary setObject:tag.restrictions forKey:[TagEnumValue getStringValue:TAG_RESTRICTED_BY_COLUMN]];
    [contentDictionary setObject:tag.groups forKey:[TagEnumValue getStringValue:TAG_GROUP_COLUMN]];
    [contentDictionary setObject:tag.longitude forKey:[TagEnumValue getStringValue:TAG_LONGITUDE_COLUMN]];
    [contentDictionary setObject:tag.latitude forKey:[TagEnumValue getStringValue:TAG_LATITUDE_COLUMN]];
    //Add the tag to the mongo database
    [MongoDbConnection insertInfo:contentDictionary collectionName:[TagEnumValue getStringValue:TAGS_TABLE]];
    
    NSLog(@"Tag saved");
    
    NSString *latitudeString = [NSString stringWithFormat:@"%@\u00B0", tag.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%@\u00B0", tag.longitude];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Tagged" message:[NSString stringWithFormat:@"Information tagged at location - Latitude: %@ , Longitude: %@", latitudeString, longitudeString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [alert show];
    
    
    //Alloc a new tag object so that we don't have any issues with the previous tag conflicting with our new tag values
    tag = [[Tag alloc] init];
    myImage = nil;
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
        @try {
            NSString *name = [alertView textFieldAtIndex:0].text;
            //Create the actual tag asyncronously
            //[self CreateTag:name];
            [self performSelectorInBackground:@selector(CreateTag:) withObject:name];
            [self gotoPreviousWindow];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Error: Alert view does not contain a text field.");
        }
        @finally {
            NSLog(@"ERROR");
        }
    }
}

#pragma mark - Camera Delegate Methods


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (tag.type == [TagEnumValue getStringValueForTagType:TYPE_IMAGE])
    {
        myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        myImage = [UIImage imageWithCGImage:myImage.CGImage scale:0.1f orientation:UIImageOrientationRight];
        [cameraButton setTintColor:[UIColor redColor]];
        [_audioButton setTintColor:[UIColor clearColor]];
    }
    else if (tag.type == [TagEnumValue getStringValueForTagType:TYPE_VIDEO])
    {
        movieUrl = info[UIImagePickerControllerMediaURL];
        [self.videoButton setTintColor:[UIColor redColor]];
        [_audioButton setTintColor:[UIColor clearColor]];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
     //[cameraButton setTintColor:[UIColor clearColor]];
}

#pragma mark - Keyboard Delegate Methods
-(void) keyboardWillShow
{
    
}

@end
