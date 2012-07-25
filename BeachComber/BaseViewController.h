//
//  BaseViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-22.
//

@class PhotoData;
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    PhotoData *photos;
}

@property (nonatomic, retain) PhotoData *photos;


- (id)initWithPhotoData:(PhotoData*) photoData;

- (void) cameraButton;
- (void) dataButton;

@end
