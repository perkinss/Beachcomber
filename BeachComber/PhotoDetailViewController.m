//
//  PhotoDetailViewController.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import "PhotoDetailViewController.h"

@implementation PhotoDetailViewController

@synthesize croppedImage, imageView, commentField, categoryField, categoryPicker, categories, selectedCategory;

- (id)initWithImage:(UIImage*) image
{
    self = [super init];
    if (self) {
        self.croppedImage = image;
        self.categories = [NSArray arrayWithObjects:@"animal", @"wreckage", @"machinery", @"person", nil];
        [self.navigation
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSInteger currentY = 10;
    
    self.imageView = [[UIImageView alloc] initWithImage:croppedImage];
    currentY += self.imageView.frame.size.height + 10;
    
    self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,0,0)];
    self.categoryPicker.showsSelectionIndicator = YES;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerButtonDone)]];    
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerButtonCancel)]];
    [toolbar setItems:items animated:NO];
    
    UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    categoryLabel.text = @"Category:";
    currentY += categoryLabel.frame.size.height + 10;                       
    self.categoryField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    currentY += self.categoryField.frame.size.height + 30;     
    self.categoryField.borderStyle = UITextBorderStyleRoundedRect;
    self.categoryField.inputView = self.categoryPicker;
    self.categoryField.inputAccessoryView = toolbar;
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    commentLabel.text = @"Comments:";
    currentY += commentLabel.frame.size.height + 10;    
    self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    self.commentField.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    self.commentField.borderStyle =  UITextBorderStyleRoundedRect;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:categoryLabel];
    [self.view addSubview:self.categoryField];
    [self.view addSubview:commentLabel];
    [self.view addSubview:self.commentField];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return [categories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [categories objectAtIndex:row];
}


- (void) pickerButtonDone {
    self.categoryField.text = [categories objectAtIndex:[self.categoryPicker selectedRowInComponent:0]];
    [self.categoryField resignFirstResponder];
}
- (void) pickerButtonCancel {
    [self.categoryField resignFirstResponder];
    
}

@end
