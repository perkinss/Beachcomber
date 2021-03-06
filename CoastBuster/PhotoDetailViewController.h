//
//  PhotoDetailViewController.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//
@class PhotoData;

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UIImage *thumb;
    UIImageView *imageView;
    UITextField *commentField;
    UITextField *categoryField;
    UIPickerView *categoryPicker;
    
    UITextField *compositionField;
    UIPickerView *compositionPicker;
    
    UITextField *activeField;
    
    NSArray *categories;
    NSArray *compositions;
    NSMutableDictionary *entry;
    
    BOOL keyboardIsShown;
    BOOL mandatoryFields;
    
    PhotoData *photos;
}

@property (nonatomic, retain) UIImage *thumb;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextField *commentField;
@property (nonatomic, retain) UITextField *categoryField;
@property (nonatomic, retain) UIPickerView *categoryPicker;

@property (nonatomic, retain) UITextField *compositionField;
@property (nonatomic, retain) UIPickerView *compositionPicker;

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *compositions;
@property (nonatomic, retain) NSMutableDictionary *entry;

@property (nonatomic, retain) UITextField *activeField;

@property (nonatomic) BOOL keyboardIsShown;
@property (nonatomic) BOOL mandatoryFields;

@property (nonatomic, retain) PhotoData *photos;

- (id)initWithImage:(UIImage*) image entry:(NSMutableDictionary*)entry_par;
- (void) changePhotoWithImage:(UIImage*) image entry:(NSMutableDictionary*) entry;

- (void) categoryPickerButtonDone;
- (void) categoryPickerButtonCancel;

- (void) compositionPickerButtonDone;
- (void) compositionPickerButtonCancel;
- (void) saveEvent;
- (void) setBackAsCancel;
@end
