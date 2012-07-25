//
//  AppDelegate.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//

@class BaseViewController;
@class PhotoData;
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BaseViewController *baseController;
    PhotoData *photoData;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) BaseViewController *baseController;
@property (nonatomic, retain) PhotoData *photoData;

@end
