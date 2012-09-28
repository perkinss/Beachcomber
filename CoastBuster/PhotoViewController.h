//
//  PhotoViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController {
    UIImageView *imageView;
    UIImage *image;
    UIScrollView *scrollView;
}


@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIScrollView *scrollView;


- (id)initWithImage:(UIImage*)initialImage;
- (void) changePhoto:(UIImage*) newImage;

@end
