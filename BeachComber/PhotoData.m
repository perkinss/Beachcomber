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

- (NSInteger) count {
    return [photos count];
}

- (NSMutableDictionary* ) addPhoto:(UIImage*) image withComment:(NSString*)comment category:(NSString*)category{
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
    [newPhoto setObject: comment forKey:@"comment"];
    [newPhoto setObject: category forKey:@"category"];
    
    [self.photos addObject:newPhoto];
    //[self saveData];  // Save every time a photo is added?
    return newPhoto;
}

- (void) saveData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"plist"];
    [self.photos writeToFile:plistPath atomically:YES];
}

@end
