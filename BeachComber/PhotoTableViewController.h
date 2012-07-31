//
//  PhotoTableViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//

@class PhotoData;
@class PhotoViewController;
@class PhotoDetailViewController;
#import <UIKit/UIKit.h>

@interface PhotoTableViewController : UITableViewController {
    
    PhotoData *photos;
    
    PhotoViewController       *photoViewController;
    PhotoDetailViewController *detailViewController;
}


@property (nonatomic, retain) PhotoData *photos;

@property (nonatomic, retain) PhotoViewController       *photoViewController;
@property (nonatomic, retain) PhotoDetailViewController *detailViewController;

- (id)initWithPhotoData:(PhotoData*) photoData;
//- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage;


@end
