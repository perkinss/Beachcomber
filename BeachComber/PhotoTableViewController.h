//
//  PhotoTableViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

@class PhotoData;
#import <UIKit/UIKit.h>

@interface PhotoTableViewController : UITableViewController {
    
    PhotoData *photos;
}


@property (nonatomic, retain) PhotoData *photos;

- (UIImage *)getCroppedImageFromName:(NSString *)name;
@end
