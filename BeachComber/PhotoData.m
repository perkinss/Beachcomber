//
//  PhotoData.m
//  BeachComber
//  Data structure for storing photos and their meta data
//  includes functionality for writing and reading photo metadata to disk
//
//  Created by Jeff Proctor on 12-07-20.\
//

#import "PhotoData.h"
#define photoPlist @"photo.plist"

@implementation PhotoData

@synthesize photos;

- (id)init {
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *fileError = [[NSError alloc] init];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [NSString stringWithFormat:@"%@/photos.plist", docDir ];
      
        if ([fileManager fileExistsAtPath:plistPath]) {
            
            self.photos = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:plistPath] 
                                                                    options:NSPropertyListMutableContainers
                                                                     format:NULL
                                                                      error:&fileError];
            if([fileError localizedFailureReason] != nil) {
                NSString *err = [fileError localizedFailureReason]; 
                NSLog(@"Error: %@",err);
            }
        } else {
            self.photos = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (NSDictionary*) photoAtIndex: (NSInteger) index {
    return [self.photos objectAtIndex: index];
}

- (BOOL) removePhotoAtIndex: (NSInteger) index {
    if (index >= [self.photos count] || index < 0) {
        return NO;
    }
    NSMutableDictionary *entry = [self.photos objectAtIndex: index];
    NSString *imageFile = [entry objectForKey:@"imageFile"];
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    [fileMgr removeItemAtPath:imageFile error:&error];
    if (error != nil) {
        // This deletion procedure currently does not work for default images.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not delete image" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.photos removeObjectAtIndex:index];
    return YES;
}

- (BOOL) movePhotoAtIndex:(NSInteger)fromIndex to:(NSInteger)toIndex {
    if (fromIndex >= [self.photos count] || fromIndex < 0 || toIndex >= [self.photos count] || toIndex < 0 || fromIndex == toIndex) {
        return NO;
    }
    NSMutableDictionary *entry = [self.photos objectAtIndex:fromIndex];
    [self.photos removeObjectAtIndex:fromIndex];
    [self.photos insertObject:entry atIndex:toIndex];
    
    return YES;
}

- (NSInteger) count {
    return [photos count];
}

- (NSMutableDictionary* ) addPhoto:(UIImage*) image withLocation:(CLLocation*)location {
    NSMutableDictionary *newPhoto = [[NSMutableDictionary alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *existingFiles = [fileManager contentsOfDirectoryAtPath:docDir error:nil];
    NSString *uniqueFilename;
    do {
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        
        uniqueFilename = [[docDir stringByAppendingPathComponent:(__bridge NSString *)newUniqueIdString] stringByAppendingPathExtension: @"png"];
        
        CFRelease(newUniqueId);
        CFRelease(newUniqueIdString);
    } while ([existingFiles containsObject:uniqueFilename]);
    
    //NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
	NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:uniqueFilename atomically:YES];
    
    [newPhoto setObject: uniqueFilename forKey:@"imageFile"];
    [newPhoto setObject: @"" forKey:@"comment"];
    [newPhoto setObject: @"" forKey:@"category"];
    [newPhoto setObject: @"" forKey:@"composition"];
    NSString *latitudeString = @"";
    NSString *longitudeString = @"";
    if (location != nil) {
        latitudeString = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        longitudeString = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateString = [format stringFromDate:[NSDate date]];
    [newPhoto setObject:latitudeString forKey:@"latitude"];
    [newPhoto setObject:longitudeString forKey:@"longitude"];
    [newPhoto setObject:dateString forKey:@"timestamp"];
    
    [self.photos addObject:newPhoto];
    //[self saveData];  // Save every time a photo is added?
    return newPhoto;
}

- (void) saveData {
   
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"%@/photos.plist", docDir ];
    [self.photos writeToFile:plistPath atomically:YES];
}

- (UIImage*) photoImageAtIndex: (NSInteger) index {
    NSMutableDictionary* entry = [self.photos objectAtIndex:index];
    NSString* fileName = [entry objectForKey:@"imageFile"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:fileName];
    return image;
}


- (void) uploadPhotosInSet:(NSSet*) photoSet {
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"beachcomber" create:NO];
    NSString* uid = pasteboard.string;
}


@end
