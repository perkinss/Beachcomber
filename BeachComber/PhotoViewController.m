//
//  PhotoViewController.m
//  BeachComber
//  Simple view controller that presents a full screen image
//
//  Created by Jeff Proctor on 12-07-20.
//

#import "PhotoViewController.h"

@implementation PhotoViewController

@synthesize imageView, image;

- (id)initWithImage:(UIImage*)initialImage
{
    self = [super init];
    if (self) {
        self.image = initialImage;
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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    scrollView.contentSize = self.imageView.frame.size;
    scrollView.scrollEnabled = YES;

    [scrollView addSubview:self.imageView];
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

@end
