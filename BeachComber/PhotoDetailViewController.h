//
//  PhotoDetailViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
    UIImage *croppedImage;
    UIImageView *imageView;
    UITextField *commentField;
    UITextField *categoryField;
    UIPickerView *categoryPicker;
    
    NSArray *categories;
    NSString *selectedCategory;
    
}

@property (nonatomic, retain) UIImage *croppedImage;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextField *commentField;
@property (nonatomic, retain) UITextField *categoryField;
@property (nonatomic, retain) UIPickerView *categoryPicker;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSString *selectedCategory;

- (id)initWithImage:(UIImage*) image;

- (void) pickerButtonDone;
- (void) pickerButtonCancel;
@end
