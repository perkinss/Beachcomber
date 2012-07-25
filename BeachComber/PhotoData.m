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
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"plist"];
        self.photos = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:plistPath] 
                                                                           options:NSPropertyListMutableContainers
                                                                            format:NULL
                                                                             error:NULL];
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

- (NSMutableDictionary* ) addPhoto:(UIImage*) image {
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
    
    [self.photos addObject:newPhoto];
    //[self saveData];  // Save every time a photo is added?
    return newPhoto;
}

- (void) saveData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"plist"];
    [self.photos writeToFile:plistPath atomically:YES];
}

@end
