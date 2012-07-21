//
//  PhotoData.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import "PhotoData.h"
#define photoPlist @"photo.plist"

@implementation PhotoData

@synthesize photos;

- (id)init {
    self = [super init];
    if (self) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"plist"];
        self.photos = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return self;
}

- (NSDictionary*) photoAtIndex: (NSInteger) index {
    return [self.photos objectAtIndex: index];
}

- (NSInteger) count {
    return [photos count];
}

- (void) addPhoto:(UIImage*) image WithTitle:(NSString*)title comment:(NSString*)comment category:(NSString*)category{
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
    [newPhoto setObject: title forKey:@"title"];
    [newPhoto setObject: comment forKey:@"comment"];
    [newPhoto setObject: category forKey:@"category"];
    
    [self.photos addObject:newPhoto];
    [self saveData];  // Save every time a photo is added?
}

- (void) saveData {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"plist"];
    [self.photos writeToFile:plistPath atomically:YES];
}

@end
