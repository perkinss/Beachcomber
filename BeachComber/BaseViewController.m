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
#import "PhotoData.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreLocation/CoreLocation.h>

@implementation BaseViewController
@synthesize photos, locationManager, currentLocation;


- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startMonitoringSignificantLocationChanges];
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
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame = CGRectMake(10, 10, 250, 50);
    [photoButton addTarget:self action:@selector(cameraButton) forControlEvents:UIControlEventTouchDown];
    [photoButton setTitle:@"Take a photo" forState:UIControlStateNormal];

    UIButton *tableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tableButton.frame = CGRectMake(10, 70, 250, 50);
    [tableButton addTarget:self action:@selector(dataButton) forControlEvents:UIControlEventTouchDown];
    [tableButton setTitle:@"View images" forState:UIControlStateNormal];
    
    [self.view addSubview:photoButton];
    [self.view addSubview:tableButton];
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


//  called when new location data is received
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
}

- (void) cameraButton {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        // Displays a control that allows the user to choose picture or
        // movie capture, if both are available:
        cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
    
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = YES;
    
        cameraUI.delegate = self;
    
        [self presentModalViewController: cameraUI animated: YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera not available on this device" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    //return YES;
}

- (void) dataButton {
    PhotoTableViewController *tableViewController = [[PhotoTableViewController alloc] initWithPhotoData:self.photos];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated: YES];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    // TODO: check that media type is image
    //NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
    //    == kCFCompareEqualTo) {
        
    //}
    
    UIImage* editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    UIImage* originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage* imageToSave;
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    [self dismissModalViewControllerAnimated: YES];
    
    NSMutableDictionary *newEntry = [self.photos addPhoto:imageToSave withLocation: self.currentLocation];
    PhotoDetailViewController *detailView = [[PhotoDetailViewController alloc] initWithImage:imageToSave entry:newEntry];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
