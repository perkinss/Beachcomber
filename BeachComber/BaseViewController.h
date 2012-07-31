//
//  BaseViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-22.
//

@class PhotoData;
@class PhotoSelectionViewController;
@class PhotoTableViewController;
@class PhotoDetailViewController;
@class InfoViewController;
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BaseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate> {
    PhotoData *photos;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    PhotoTableViewController *photoTableViewController;
    PhotoSelectionViewController *photoSelectionViewController;
    PhotoDetailViewController *photoDetailViewController;
    InfoViewController *infoViewController;
}

@property (nonatomic, retain) PhotoData *photos;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;

@property (nonatomic, retain) PhotoTableViewController *photoTableViewController;
@property (nonatomic, retain) PhotoSelectionViewController *photoSelectionViewController;
@property (nonatomic, retain) InfoViewController *infoViewController;
@property (nonatomic, retain) PhotoDetailViewController *photoDetailViewController;

- (id)initWithPhotoData:(PhotoData*) photoData;

- (void) cameraButton;
- (void) dataButton;
- (void) uploadButton;
- (void) infoButton;

@end
