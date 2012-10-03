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

@interface PhotoTableViewController : UITableViewController <UIAlertViewDelegate> {
    
    PhotoData *photos;
    
    PhotoViewController       *photoViewController;
    PhotoDetailViewController *detailViewController;
    
    UIBarButtonItem *startEditButton;
    UIBarButtonItem *endEditButton;
    UIBarButtonItem *deleteButton;
    UIBarButtonItem *uploadButton;
    
    UIBackgroundTaskIdentifier uploadTaskID;
    
    BOOL deleteAfterUpload;
}


@property (nonatomic, retain) PhotoData *photos;

@property (nonatomic, retain) PhotoViewController       *photoViewController;
@property (nonatomic, retain) PhotoDetailViewController *detailViewController;

@property (nonatomic, retain) UIBarButtonItem *startEditButton;
@property (nonatomic, retain) UIBarButtonItem *endEditButton;

@property (nonatomic, retain) UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIBarButtonItem *uploadButton;

@property (nonatomic) UIBackgroundTaskIdentifier uploadTaskID;

@property (nonatomic) BOOL deleteAfterUpload;

- (id)initWithPhotoData:(PhotoData*) photoData;
//- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage;

- (void)startEditing;
- (void)endEditing;
- (void) multipleDelete;
- (void) multipleUpload;

@end
