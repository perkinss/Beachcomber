//
//  PhotoSelectionViewController.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-27.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import "PhotoSelectionViewController.h"
#import "PhotoData.h"


@implementation PhotoSelectionViewController

@synthesize photos, selection, uploadButton;

- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
        self.selection = [[NSMutableSet alloc] init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleDone target:self action:@selector(uploadEvent)];
    [[self navigationItem] setRightBarButtonItem: self.uploadButton];  
    [[self navigationItem] setTitle:@"Select photos"];
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [photos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

/*
 *      returns a table view cell for row at indexPath
 *      Assigns the image and text to the cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *photoData =  (NSDictionary*) [self.photos photoAtIndex:indexPath.row];
    cell.textLabel.text = [photoData objectForKey:@"category"];
    cell.detailTextLabel.text = [photoData objectForKey:@"comment"];
    cell.imageView.image = [self.photos thumbImageAtIndex:indexPath.row];
    return cell;
}

/*
 * Retrieves named image, and crops from center point of image to preserve 3:4 aspect ratio.
 */
- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage {
    int imgWidth = uncroppedImage.size.width;
    int imgHeight = uncroppedImage.size.height;
    int cropHeight, cropWidth, cropX, cropY;
    if (3 * imgWidth > 4 * imgHeight) {
        cropHeight = imgHeight;
        cropWidth = 4 * imgHeight / 3;
        cropY = 0;
        cropX = (imgWidth - cropWidth) / 2;
    }
    else {
        cropWidth = imgWidth;
        cropHeight = 3 * imgWidth / 4;
        cropX = 0;
        cropY = (imgHeight - cropHeight) / 2;
    }
    CGRect cropRect = CGRectMake(cropX, cropY, cropWidth, cropHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([uncroppedImage CGImage], cropRect);
    UIImage* result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if ([selection containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selection removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selection addObject:[NSNumber numberWithInt:indexPath.row]];
    }
}

- (void)uploadEvent {
    if ([self.selection count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No photos selected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.photos uploadPhotosInSet:self.selection withObserver:self];
        [self.uploadButton setEnabled:NO];
        
    }
}

- (void) _sendDidStopWithStatus: (NSString*) status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString* alertTitle = @"";
    NSString* alertMessage = @"";
    
    if (status == nil) {
        alertMessage = @"Upload completed";
        [self.selection removeAllObjects];
        for (int section = 0, sectionCount = self.tableView.numberOfSections; section < sectionCount; ++section) {
            for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:section]; row < rowCount; ++row) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else {
        alertTitle = @"Error";
        alertMessage = status;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [self.uploadButton setEnabled:YES];
}

@end