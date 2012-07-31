//
//  AppDelegate.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-18.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "PhotoData.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize baseController;
@synthesize photoData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.photoData = [[PhotoData alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"%@/photos.plist", docDir ];
    if ( ![fileManager fileExistsAtPath:plistPath] ) {
        //only need to do this for the demo, and for testing the views without camera, as with the Simulator.
        if ([self.photoData count] == 0) {
            NSMutableDictionary *entry;
            entry = [self.photoData addPhoto:[UIImage imageNamed:@"image1.png"] withLocation:nil];
            [entry setObject:@"comment" forKey:@"comment"];
            [entry setObject:@"Building Material" forKey:@"category"];
            [entry setObject:@"Concrete" forKey:@"composition"];
            
            
            entry = [self.photoData addPhoto:[UIImage imageNamed:@"image2.png"] withLocation:nil];
            [entry setObject:@"comment" forKey:@"comment"];
            [entry setObject:@"Animal" forKey:@"category"];
            [entry setObject:@"Other/Mixed" forKey:@"composition"];
            
            
            entry = [self.photoData addPhoto:[UIImage imageNamed:@"image3.png"] withLocation:nil];
            [entry setObject:@"comment" forKey:@"comment"];
            [entry setObject:@"Animal" forKey:@"category"];
            [entry setObject:@"Other/Mixed" forKey:@"composition"];
            
            
            entry = [self.photoData addPhoto:[UIImage imageNamed:@"image4.png"] withLocation:nil];
            [entry setObject:@"comment" forKey:@"comment"];
            [entry setObject:@"Building Material" forKey:@"category"];
            [entry setObject:@"Concrete" forKey:@"composition"];
        }
    }
    
    baseController = [[BaseViewController alloc] initWithPhotoData:photoData];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: self.baseController];
    
    self.window.rootViewController = navController;
    //[self.window addSubview:photoViewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
        [self.photoData saveData];

    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //this doesn't usually get called :(
    [self.photoData saveData];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
