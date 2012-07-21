//
//  PhotoViewController.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGREctMake];
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.imageView.center = self.view.center;
    [self.view addSubview:self.imageView];
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
