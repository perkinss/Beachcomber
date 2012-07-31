//
//  BaseViewController.m
//  BeachComber
//  Root view controller that prompts user to select between taking a photo or viewing photos table
//
//  Created by Jeff Proctor on 12-07-22.
//

#import "BaseViewController.h"
#import "PhotoTableViewController.h"
#import "PhotoDetailViewController.h"
#import "PhotoSelectionViewController.h"
#import "InfoViewController.h"
#import "PhotoData.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

@implementation BaseViewController
@synthesize photos, locationManager, currentLocation;

@synthesize photoTableViewController, photoSelectionViewController, photoDetailViewController, infoViewController;

- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
        
        photoTableViewController = nil;
        photoSelectionViewController = nil;
        photoDetailViewController = nil;
        infoViewController = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int buttonWidth = 240;
    int buttonHeight = 50;
    int margin = 10;
    int currentY = 50;
    int buttonX = (screenRect.size.width - buttonWidth)/2;
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    currentY += buttonHeight + margin;
    [photoButton addTarget:self action:@selector(cameraButton) forControlEvents:UIControlEventTouchDown];
    [photoButton setTitle:@"Take a photo" forState:UIControlStateNormal];

    UIButton *tableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tableButton.frame = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    currentY += buttonHeight + margin;
    [tableButton addTarget:self action:@selector(dataButton) forControlEvents:UIControlEventTouchDown];
    [tableButton setTitle:@"View and edit images" forState:UIControlStateNormal];
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    uploadButton.frame = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    currentY += buttonHeight + margin;
    [uploadButton addTarget:self action:@selector(uploadButton) forControlEvents:UIControlEventTouchDown];
    [uploadButton setTitle:@"Upload images" forState:UIControlStateNormal];
        
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    infoButton.frame = CGRectMake(buttonX, currentY, buttonWidth, buttonHeight);
    currentY += buttonHeight + margin;
    [infoButton addTarget:self action:@selector(infoButton) forControlEvents:UIControlEventTouchDown];
    [infoButton setTitle:@"Help / About" forState:UIControlStateNormal];

    
    [self.view addSubview:photoButton];
    [self.view addSubview:tableButton];
    [self.view addSubview:uploadButton];
    [self.view addSubview:infoButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
# pragma mark - location and buttons
//  called when new location data is received
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void) cameraButton {
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Location services are not available.  Please enable location services under Settings" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            // Displays a control that allows the user to choose picture or
            // movie capture, if both are available:
            cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            
            // Hides the controls for moving & scaling pictures, or for
            // trimming movies. To instead show the controls, use YES.
            cameraUI.allowsEditing = NO;
            
            cameraUI.delegate = self;
            
            
            [self presentModalViewController: cameraUI animated: YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera not available on this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    //return YES;
}

- (void) dataButton {
    if (photoTableViewController == nil) {
        photoTableViewController = [[PhotoTableViewController alloc] initWithPhotoData:self.photos];
    }
    [self.navigationController pushViewController:photoTableViewController animated:YES];
}

- (void) uploadButton {
    if (photoSelectionViewController == nil) {
        photoSelectionViewController = [[PhotoSelectionViewController alloc] initWithPhotoData:self.photos];
    }
    [self.navigationController pushViewController:photoSelectionViewController animated:YES];
}
- (void) infoButton {
    if (infoViewController == nil) {
        infoViewController = [[InfoViewController alloc] init];
        infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    //issue # 16: Use button is slow to return to this point.  I thought it was our addPhoto but maybe it's my iPhone :)
    [self dismissModalViewControllerAnimated: YES];
    
    UIImage* editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    UIImage* originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage* imageToSave;
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }    
    
    NSMutableDictionary *newEntry = [self.photos addPhoto:imageToSave withLocation: self.currentLocation];
    NSString* thumbName = [newEntry objectForKey:@"thumbnail"];
    UIImage* thumb = [[UIImage alloc] initWithContentsOfFile:thumbName];
    if (self.photoDetailViewController == nil) {
        self.photoDetailViewController = [[PhotoDetailViewController alloc] initWithImage:thumb entry:newEntry];
        self.photoDetailViewController.navigationItem.hidesBackButton = YES;
        self.photoDetailViewController.mandatoryFields = YES;
    }
    else {
        [self.photoDetailViewController changePhotoWithImage:thumb entry:newEntry];
    }
    [self.navigationController pushViewController:self.photoDetailViewController animated:YES];
}


@end
