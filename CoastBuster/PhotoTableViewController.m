//
//  PhotoTableViewController.m
//  BeachComber
//  Presents all photos as a table view with a thumbnail on the left, and the category/comment on the right
//
//  Created by Jeff Proctor on 12-07-18.
//

#import "PhotoTableViewController.h"
#import "PhotoViewController.h"
#import "PhotoDetailViewController.h"
#import "PhotoData.h"


@implementation PhotoTableViewController

@synthesize photos, photoViewController, detailViewController;
@synthesize startEditButton, endEditButton;
@synthesize deleteButton, uploadButton;

- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
        self.photoViewController = nil;
        self.detailViewController = nil;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
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
    
    self.startEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(startEditing)];
    
    self.endEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(endEditing)];
    [[self navigationItem] setRightBarButtonItem:self.startEditButton];
    
    //[[self navigationItem] setRightBarButtonItem: [self editButtonItem]];  
    [[self navigationItem] setTitle:@"Photos"];
    
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(multipleDelete)];
    
    self.uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStyleBordered target:self action:@selector(multipleUpload)];
    NSArray *items = [[NSArray alloc] initWithObjects:self.deleteButton, self.uploadButton, nil];
    [self setToolbarItems: items animated:NO];

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
    [self.tableView reloadData];
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
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    NSDictionary *photoData =  (NSDictionary*) [photos photoAtIndex:indexPath.row];
    cell.textLabel.text = [photoData objectForKey:@"category"];
    cell.detailTextLabel.text = [photoData objectForKey:@"comment"];
    cell.imageView.image = [photos thumbImageAtIndex:indexPath.row];
    
    return cell;
}

/*
 * Retrieves named image, and crops from center point of image to preserve 3:4 aspect ratio.
 */
//- (UIImage *)getCroppedImageFromImage:(UIImage *)uncroppedImage {
//    int imgWidth = uncroppedImage.size.width;
//    int imgHeight = uncroppedImage.size.height;
//    int cropHeight, cropWidth, cropX, cropY;
//    if (3 * imgWidth > 4 * imgHeight) {
//        cropHeight = imgHeight;
//        cropWidth = 4 * imgHeight / 3;
//        cropY = 0;
//        cropX = (imgWidth - cropWidth) / 2;
//    }
//    else {
//        cropWidth = imgWidth;
//        cropHeight = 3 * imgWidth / 4;
//        cropX = 0;
//        cropY = (imgHeight - cropHeight) / 2;
//    }
//    CGRect cropRect = CGRectMake(cropX, cropY, cropWidth, cropHeight);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([uncroppedImage CGImage], cropRect);
//    UIImage* result = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return result;
//}

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


/*
 *      Event handler for row selection. presents full screen image
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: change this so it doesn't create a new UIViewController each time?
    // ...leading to possible memory leak... should check with the tools to see whether it gets released.
    if (!self.tableView.isEditing) {
        UIImage* imageToShow = [self.photos photoImageAtIndex:indexPath.row];
        if (self.photoViewController == nil) {
            self.photoViewController = [[PhotoViewController alloc] initWithImage:imageToShow];
        }
        else {
            [self.photoViewController changePhoto:imageToShow];
        }
        [self.navigationController pushViewController:self.photoViewController animated:YES];
    }
}

/*
 *      Event handler for accessory button selection (the blue button with arrow on right side of row).
 *      Presents editing view
 *
 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *photoData =  (NSMutableDictionary*) [photos photoAtIndex:indexPath.row];
    NSString* fileName = [photoData objectForKey:@"thumbnail"];
    UIImage* thumb = [[UIImage alloc] initWithContentsOfFile:fileName];
    if (self.detailViewController == nil) {
        self.detailViewController = [[PhotoDetailViewController alloc] initWithImage:thumb entry:photoData];
    }
    else {
        [self.detailViewController changePhotoWithImage:thumb entry:photoData];
    }
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}




// =======================   EDITING

- (void)startEditing {
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self setEditing:YES animated:YES];
    [[self navigationItem] setRightBarButtonItem:self.endEditButton];
}

- (void)endEditing {
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self setEditing:NO animated:YES];
    [[self navigationItem] setRightBarButtonItem: self.startEditButton];
}

- (void) multipleDelete {
    NSArray *selections = [self.tableView indexPathsForSelectedRows];
    if ([selections count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No photos selected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else {
        for (int i = 0; i < [selections count]; i++) {
            int row = [[selections objectAtIndex:i] row];
            [self.photos removePhotoAtIndex:row];
        }
        [self.tableView deleteRowsAtIndexPaths:selections withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) multipleUpload {
    NSArray *selections = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *integerSelections = [[NSMutableArray alloc] init];
    for (int i = 0; i < [selections count]; i++) {
        [integerSelections addObject:[NSNumber numberWithInt:[[selections objectAtIndex:i] row] ] ];
    }
    
    if ([integerSelections count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No photos selected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.photos uploadPhotosInSet:integerSelections withObserver:self];
        [self.uploadButton setEnabled:NO];
        [self.deleteButton setEnabled:NO];
        
    }
}

- (void) _sendDidStopWithStatus: (NSString*) status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString* alertTitle = @"";
    NSString* alertMessage = @"";
    
    if (status == nil) {
        alertMessage = @"Upload completed";
        NSArray *selections = [self.tableView indexPathsForSelectedRows];
        for (int i = 0; i < [selections count]; i++) {
            [self.tableView deselectRowAtIndexPath:[selections objectAtIndex:i] animated:YES];
        }
    }
    else {
        alertTitle = @"Error";
        alertMessage = status;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [self.uploadButton setEnabled:YES];
    [self.deleteButton setEnabled:YES];
}

// allow editing for all rows
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// allow moving for all rows
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// event handler for moving row 
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.photos movePhotoAtIndex:fromIndexPath.row to:toIndexPath.row];
}

// event handler for deleting or inserting row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // row change is a deletion
        [self.photos removePhotoAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
