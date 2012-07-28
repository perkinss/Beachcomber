//
//  PhotoDetailViewController.m
//  BeachComber
//  This view shows the photo at the top, and allows for editing the category and the comment
//
//  Created by Jeff Proctor on 12-07-20.
//

#import "PhotoDetailViewController.h"
#import "PhotoData.h"

@implementation PhotoDetailViewController

@synthesize croppedImage, imageView, commentField, categoryField, categoryPicker, compositionField, compositionPicker, categories, compositions, entry, keyboardIsShown, activeField;

- (id)initWithImage:(UIImage*) image entry:(NSMutableDictionary*)entry_par
{
    self = [super init];
    if (self) {
        self.croppedImage = image;
        self.categories = [NSArray arrayWithObjects:@"Building Material", @"Marine equipment", @"Container/Packaging", @"Vehicle parts", @"Other", nil];
        self.compositions = [NSArray arrayWithObjects:@"Plastic", @"Wood", @"Rubber", @"Metal", @"Concrete", @"Mixed/Other", nil];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.entry = entry_par;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveEvent)];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect fullScreen = [[UIScreen mainScreen] applicationFrame];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:fullScreen];
    NSInteger currentY = 10;
    
    //self.imageView = [[UIImageView alloc] initWithImage:croppedImage];
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    CGFloat maxThumbHeight = 100;
    CGSize viewSize = [self getProportion:sizeOfScreen imageToSize:croppedImage maximumHeight:maxThumbHeight];
    
    CGRect newFrame = CGRectMake(10, currentY, viewSize.width, viewSize.height);
    self.imageView = [[UIImageView alloc] initWithFrame:newFrame];
    self.imageView.image = croppedImage;
    currentY += self.imageView.frame.size.height + 10;
    
    
    self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,0,0)];
    self.categoryPicker.showsSelectionIndicator = YES;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
    UIToolbar *categoryToolbar = [[UIToolbar alloc] init];
    categoryToolbar.frame = CGRectMake(0, 0, fullScreen.size.width, 44);
    NSMutableArray *categoryItems = [[NSMutableArray alloc] init];
    [categoryItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(categoryPickerButtonDone)]];    
    [categoryItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(categoryPickerButtonCancel)]];
    [categoryToolbar setItems:categoryItems animated:NO];
    
    UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    categoryLabel.text = @"Category:";
    currentY += categoryLabel.frame.size.height + 10;                       
    self.categoryField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    currentY += self.categoryField.frame.size.height + 30;     
    self.categoryField.borderStyle = UITextBorderStyleRoundedRect;
    self.categoryField.inputView = self.categoryPicker;
    self.categoryField.inputAccessoryView = categoryToolbar;
    self.categoryField.text = [self.entry objectForKey:@"category"];
    self.categoryField.placeholder = @"Select a category ...";
    
    self.compositionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,0,0)];
    self.compositionPicker.showsSelectionIndicator = YES;
    self.compositionPicker.delegate = self;
    self.compositionPicker.dataSource = self;
    
    UIToolbar *compositionToolbar = [[UIToolbar alloc] init];
    compositionToolbar.frame = CGRectMake(0, 0, fullScreen.size.width, 44);
    NSMutableArray *compositionItems = [[NSMutableArray alloc] init];
    [compositionItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(compositionPickerButtonDone)]];    
    [compositionItems addObject:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(compositionPickerButtonCancel)]];
    [compositionToolbar setItems:compositionItems animated:NO];
    
    UILabel* compositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    compositionLabel.text = @"Composition:";
    currentY += compositionLabel.frame.size.height + 10;                       
    self.compositionField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    currentY += self.compositionField.frame.size.height + 30;     
    self.compositionField.borderStyle = UITextBorderStyleRoundedRect;
    self.compositionField.inputView = self.compositionPicker;
    self.compositionField.inputAccessoryView = compositionToolbar;
    self.compositionField.text = [self.entry objectForKey:@"composition"];
    self.compositionField.placeholder = @"What is it made of? ...";
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    commentLabel.text = @"Comments:";
    currentY += commentLabel.frame.size.height + 10;    
    self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    //self.commentField.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    self.commentField.borderStyle =  UITextBorderStyleRoundedRect;
    self.commentField.text = [self.entry objectForKey:@"comment"];
    self.commentField.delegate = self;
    self.commentField.placeholder = @"Enter other details ... ";
    currentY += self.commentField.frame.size.height + 10;
    scrollView.contentSize = CGSizeMake(fullScreen.size.width, currentY);
    
    [scrollView addSubview:self.imageView];
    [scrollView addSubview:categoryLabel];
    [scrollView addSubview:self.categoryField];
    [scrollView addSubview:compositionLabel];
    [scrollView addSubview:self.compositionField];
    [scrollView addSubview:commentLabel];
    [scrollView addSubview:self.commentField];
    
    self.view = scrollView;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register for keyboard notifications so that the scroll view frame can be resized
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
    keyboardIsShown = NO;
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.categoryPicker) {
        return [categories count];
    }
    if (pickerView == self.compositionPicker) {
        return [compositions count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.categoryPicker) {
        return [categories objectAtIndex:row];
    }
    if (pickerView == self.compositionPicker) {
        return [compositions objectAtIndex:row];
    }
    return nil;
}


- (void) categoryPickerButtonDone {
    self.categoryField.text = [categories objectAtIndex:[self.categoryPicker selectedRowInComponent:0]];
    [self.categoryField resignFirstResponder];
}
- (void) categoryPickerButtonCancel {
    [self.categoryField resignFirstResponder];
    
}





- (void) compositionPickerButtonDone {
    self.compositionField.text = [compositions objectAtIndex:[self.compositionPicker selectedRowInComponent:0]];
    [self.compositionField resignFirstResponder];
}
- (void) compositionPickerButtonCancel {
    [self.compositionField resignFirstResponder];
    
}


- (void) saveEvent {
    [self.entry setObject:self.commentField.text forKey:@"comment"];
    [self.entry setObject:self.categoryField.text forKey:@"category"];
    [self.entry setObject:self.compositionField.text forKey:@"composition"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == self.commentField) {
        [theTextField resignFirstResponder];
    }
    return YES;
} 

// need to track active field so that view will scroll to that field when keyboard opens
// NOTE: this message is not called for the text fields that use UIPickerView instead of the keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

// resizes the scroll view when the keyboard disappears
- (void)keyboardWillHide:(NSNotification *)n
{
    // get the size of the keyboard
    CGSize keyboardSize = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the scrollview so its bottom is at bottom of the screen
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = NO;
}

// resizes the scroll view when the keyboard appears
- (void)keyboardWillShow:(NSNotification *)n
{
    // do not resize if keyboard is already open
    if (keyboardIsShown) {
        return;
    }
    
    UIScrollView *scrollView = (UIScrollView*) self.view;
    // get the size of the keyboard
    CGSize keyboardSize = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the view so its bottom is at the top of the keyboard
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height -= keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
    
    if (activeField != nil) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (CGSize)getProportion:(CGSize)sizeOfScreen imageToSize:(UIImage *)theImage maximumHeight:(CGFloat)maxHeight {
    
    CGFloat ht = theImage.size.height;
    CGFloat wd = theImage.size.width;
    CGFloat maxWidth = sizeOfScreen.width - 120;
    CGFloat newHeight = 0;
    CGFloat newWidth = 0;
    
    if (ht > wd) {
        
        if (ht > maxHeight) {
            newHeight = maxHeight;
        } else {
            newHeight = ht;
        }
        newWidth = newWidth * wd / ht;        
        
    } else {
        if (wd > maxWidth) {
            newWidth = maxWidth;
        } else {
            newWidth = wd;
        }
        
        newHeight = newWidth * ht / wd;
    }
    
    return CGSizeMake(newWidth, newHeight);
}


@end
