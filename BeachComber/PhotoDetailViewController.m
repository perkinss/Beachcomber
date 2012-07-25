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

@synthesize croppedImage, imageView, commentField, categoryField, categoryPicker, categories, selectedCategory, entry;

- (id)initWithImage:(UIImage*) image entry:(NSMutableDictionary*)entry_par
{
    self = [super init];
    if (self) {
        self.croppedImage = image;
        self.categories = [NSArray arrayWithObjects:@"animal", @"wreckage", @"machinery", @"person", nil];
        //[self.navigation
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
    
    self.imageView = [[UIImageView alloc] initWithImage:croppedImage];
    currentY += self.imageView.frame.size.height + 10;
    
    self.categoryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,0,0)];
    self.categoryPicker.showsSelectionIndicator = YES;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, fullScreen.size.width, 44);
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
    self.categoryField.text = [self.entry objectForKey:@"category"];
    
    UILabel* commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, 300, 30)];
    commentLabel.text = @"Comments:";
    currentY += commentLabel.frame.size.height + 10;    
    self.commentField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentY, 300, 40)];
    self.commentField.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    self.commentField.borderStyle =  UITextBorderStyleRoundedRect;
    self.commentField.text = [self.entry objectForKey:@"comment"];
    self.commentField.delegate = self;
    scrollView.contentSize = CGSizeMake(fullScreen.size.width,currentY + self.commentField.frame.size.height + 10);
    
    [scrollView addSubview:self.imageView];
    [scrollView addSubview:categoryLabel];
    [scrollView addSubview:self.categoryField];
    [scrollView addSubview:commentLabel];
    [scrollView addSubview:self.commentField];
    
    self.view = scrollView;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if (theTextField == self.commentField) {
        [theTextField resignFirstResponder];
    }
    return YES;
} 
                      

- (void) saveEvent {
    [self.entry setObject:self.commentField.text forKey:@"comment"];
    [self.entry setObject:self.categoryField.text forKey:@"category"];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
