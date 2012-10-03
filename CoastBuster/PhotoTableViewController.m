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
@synthesize uploadTaskID;
@synthesize deleteAfterUpload;

- (id)initWithPhotoData:(PhotoData*) photoData
{
    self = [super init];
    if (self) {
        self.photos = photoData;
        self.photoViewController = nil;
        self.detailViewController = nil;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        self.uploadTaskID = UIBackgroundTaskInvalid;
        self.deleteAfterUpload = NO;
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

#pragma mark - Table view delegate


/*
 *      Event handler for row selection. presents full screen image
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    UIAlertView *deletePrompt = [[UIAlertView alloc] init];
    [deletePrompt setTitle:@"Confirm"];
	[deletePrompt setMessage:@"Delete uploaded photos from phone?"];
	[deletePrompt setDelegate:self];
	[deletePrompt addButtonWithTitle:@"Yes"];
	[deletePrompt addButtonWithTitle:@"No"];
	[deletePrompt show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.deleteAfterUpload = YES;
    }
    else {
        self.deleteAfterUpload = NO;
    }
    
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
        self.uploadTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.uploadTaskID];
            self.uploadTaskID = UIBackgroundTaskInvalid;
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.uploadButton setEnabled:NO];
        [self.deleteButton setEnabled:NO];
        [self.photos uploadPhotosInSet:integerSelections withObserver:self];
    }
}

- (void) _sendDidStopWithStatus: (NSString*) status{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString* alertMessage = @"";
    
    if (status == nil) {
        alertMessage = @"Upload completed";
        if (deleteAfterUpload) {
            [self multipleDelete];
        }
        else {
            NSArray *selections = [self.tableView indexPathsForSelectedRows];
            for (int i = 0; i < [selections count]; i++) {
                [self.tableView deselectRowAtIndexPath:[selections objectAtIndex:i] animated:YES];
            }
        }
    }
    else {
        alertMessage = @"Upload failed";
    }

    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate             = nil;
        localNotif.hasAction            = NO;
        localNotif.alertBody            = alertMessage;
        localNotif.soundName            = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CoastBuster" message:alertMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    [self.uploadButton setEnabled:YES];
    [self.deleteButton setEnabled:YES];
    [[UIApplication sharedApplication] endBackgroundTask:self.uploadTaskID];
    self.uploadTaskID = UIBackgroundTaskInvalid;
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





@end
