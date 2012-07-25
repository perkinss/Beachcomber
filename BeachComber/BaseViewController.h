//
//  BaseViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-22.
//

@class PhotoData;
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BaseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate> {
    PhotoData *photos;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (nonatomic, retain) PhotoData *photos;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;



- (id)initWithPhotoData:(PhotoData*) photoData;

- (void) cameraButton;
- (void) dataButton;

@end
