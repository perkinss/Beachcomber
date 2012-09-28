//
//  PhotoViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIScrollViewDelegate> {
    UIImageView *imageView;
    UIImage *image;
}


@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;


- (id)initWithImage:(UIImage*)initialImage;
- (void) changePhoto:(UIImage*) newImage;

@end
