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

@synthesize photos;

- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
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
    cell.imageView.image = [self getCroppedImageFromName:[photoData objectForKey:@"imageFile"]];
    
    return cell;
}

/*
 * Retrieves named image, and crops from center point of image to preserve 3:4 aspect ratio.
 */
- (UIImage *)getCroppedImageFromName:(NSString *)name {
    UIImage* uncroppedImage = [UIImage imageNamed:name];
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
    // Navigation logic may go here. Create and push another view controller.
    // TODO: change this so it doesn't create a new UIViewController each time?
    NSMutableDictionary *photoData =  (NSMutableDictionary*) [photos photoAtIndex:indexPath.row];
    UIImage* imageToShow = [UIImage imageNamed: [photoData objectForKey:@"imageFile"]];
    PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithImage:imageToShow];

     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:photoViewController animated:YES];
    
}

// placeholder: handler for accessory button (blue arrow button on right side of table view)
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *photoData =  (NSMutableDictionary*) [photos photoAtIndex:indexPath.row];
    UIImage* imageToShow = [self getCroppedImageFromName:[photoData objectForKey:@"imageFile"]];
    PhotoDetailViewController *photoDetailViewController = [[PhotoDetailViewController alloc] initWithImage:imageToShow entry:photoData];
    
    
    [self.navigationController pushViewController:photoDetailViewController animated:YES];
}




@end
