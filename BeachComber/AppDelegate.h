//
//  AppDelegate.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

@class PhotoTableViewController;
@class PhotoData;
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PhotoTableViewController *photoViewController;
    PhotoData *photoData;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) PhotoTableViewController *photoViewController;
@property (nonatomic, retain) PhotoData *photoData;

@end
