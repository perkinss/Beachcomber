//
//  PhotoDetailViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//
@class PhotoData;

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UIImage *croppedImage;
    UIImageView *imageView;
    UITextField *commentField;
    UITextField *categoryField;
    UIPickerView *categoryPicker;
    
    NSArray *categories;
    NSString *selectedCategory;
    NSMutableDictionary *entry;
    
}

@property (nonatomic, retain) UIImage *croppedImage;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextField *commentField;
@property (nonatomic, retain) UITextField *categoryField;
@property (nonatomic, retain) UIPickerView *categoryPicker;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) NSMutableDictionary *entry;

- (id)initWithImage:(UIImage*) image entry:(NSMutableDictionary*)entry_par;

- (void) pickerButtonDone;
- (void) pickerButtonCancel;
- (void) saveEvent;
- (IBAction)textFieldReturn:(UITextField *)theTextField; 
- (IBAction)textFieldDidEndEditing:(UITextField *)textField:(id)sender;
@end
