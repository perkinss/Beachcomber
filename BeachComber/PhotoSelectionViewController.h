//
//  PhotoSelectionViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-27.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoData;

@interface PhotoSelectionViewController : UITableViewController {
    
    PhotoData *photos;
    NSMutableSet *selection;
    
    UIBarButtonItem *uploadButton;
}

@property (nonatomic, retain) PhotoData *photos;
@property (nonatomic, retain) NSMutableSet *selection;
@property (nonatomic, retain) UIBarButtonItem *uploadButton;

- (id)initWithPhotoData:(PhotoData*) photoData;
- (void)uploadEvent;
- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage;

- (void) _sendDidStopWithStatus: (NSString*) status;

@end
