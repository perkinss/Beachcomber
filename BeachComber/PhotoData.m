//
//  PhotoData.m
//  BeachComber
//  Data structure for storing photos and their meta data
//  includes functionality for writing and reading photo metadata to disk
//
//  Created by Jeff Proctor on 12-07-20.\
//

#import "PhotoData.h"
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/CGImageSource.h>
#define photoPlist @"photo.plist"


@implementation PhotoData

@synthesize photos;
@synthesize photoNumber = _photoNumber;
@synthesize deviceid = _deviceid;

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
            self.photoNumber = 0;
            UIDevice *device = [UIDevice currentDevice];
            self.deviceid = device.uniqueIdentifier;
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
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename;
    NSString *thumbnail;
    
    //fileName: docDir/deviceid_photoNumber.png or thumb.png
    filename = [[docDir stringByAppendingPathComponent:[self newFilename]] stringByAppendingPathExtension: @"png"];
    thumbnail = [[docDir stringByAppendingPathComponent:[self newFilename]] stringByAppendingPathExtension: @"thumb.png"];
    
    //NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
	NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    //it may need to be written atomically if there's a chance an attempt could be made to upload a file while it's still being written.
    [data writeToFile:filename atomically:NO];    
    
    UIImage *thumb = [self makeThumb:image imageData:(__bridge CFDataRef) data];
    NSData *thumbdata = [NSData dataWithData:UIImagePNGRepresentation(thumb)];
    [thumbdata writeToFile:thumbnail atomically:NO];
    
    [newPhoto setObject: thumbnail forKey:@"thumbnail"];
    [newPhoto setObject: filename forKey:@"imageFile"];
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

- (UIImage*) thumbImageAtIndex: (NSInteger) index {
    NSMutableDictionary* entry = [self.photos objectAtIndex:index];
    NSString* fileName = [entry objectForKey:@"thumbnail"];
    UIImage* thumb = [[UIImage alloc] initWithContentsOfFile:fileName];
    return thumb;
}


- (void) uploadPhotosInSet:(NSSet*) photoSet {
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"beachcomber" create:NO];
    NSString* uid = pasteboard.string;
}

- (UIImage *) makeThumb: (UIImage *)theImage imageData: (CFDataRef)theImageData {
   
    NSNumber *pixelSize = [NSNumber numberWithInteger:(NSInteger)120];
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                         (id)kCFBooleanFalse, (id)kCGImageSourceCreateThumbnailWithTransform, 
                                                         (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent, 
                                                         (id)pixelSize, (id)kCGImageSourceThumbnailMaxPixelSize, nil];

    CGImageSourceRef imageSource = CGImageSourceCreateWithData(theImageData, options);
    CGImageRef thumbRef;
    UIImage* thumb = nil;
    UIImageOrientation imageOrientation = theImage.imageOrientation;
    if (imageSource) {
        thumbRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
        if (thumbRef) {
            CGImageSourceCopyProperties(imageSource, options);
            CGFloat ascale = 0.5;
            thumb = [UIImage imageWithCGImage:thumbRef scale:ascale orientation:imageOrientation];
            //+ (UIImage *)imageWithCGImage:(CGImageRef)imageRef scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
            
/*          // log section if needed
            UIImageOrientation thumbOrientation = thumb.imageOrientation;
            switch (thumbOrientation) {
                case UIImageOrientationUp:
                    NSLog(@"Thumb up");
                    break;
                case UIImageOrientationDown:
                    NSLog(@"Thumb down");
                    break;
                case UIImageOrientationLeft:
                    NSLog(@"Thumb left");
                    break;
                    
                default:
                    NSLog(@"Thumb must be right");
                    break;
            } 
            switch (imageOrientation) {
                case UIImageOrientationUp:
                    NSLog(@"Image up");
                    break;
                case UIImageOrientationDown:
                    NSLog(@"Image down");
                    break;
                case UIImageOrientationLeft:
                    NSLog(@"Image left");
                    break;
                    
                default:
                    NSLog(@"Image must be right");
                    break;
            }
 */
                
        }
 //Only use this if we are not doing ARC:           
//        CFRelease(imageSource);
//        CFRelease(thumbRef);
//        CFRelease(options);
    } 
    return thumb;
}

- (NSString *)newFilename {
    
    NSString *nameString = [[NSString alloc] init];
    _photoNumber++;
    nameString = [NSString stringWithFormat:@"%@_%05d",_deviceid,_photoNumber];
    return nameString;
}

@end
