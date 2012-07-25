//
//  PhotoTableViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//

@class PhotoData;
#import <UIKit/UIKit.h>

@interface PhotoTableViewController : UITableViewController {
    
    PhotoData *photos;
}


@property (nonatomic, retain) PhotoData *photos;

- (id)initWithPhotoData:(PhotoData*) photoData;
- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage;


@end
