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
#include <CFNetwork/CFNetwork.h>
#define photoPlist @"photo.plist"


@implementation PhotoData

@synthesize photos;
@synthesize photoNumber = _photoNumber;
@synthesize deviceid = _deviceid;

@synthesize imageFTPStream, imageInputStream, dataFTPStream, dataInputStream, dataBufferOffset, dataBufferLimit, imageBufferOffset, imageBufferLimit, uploadNotifyTarget, uploadSet, uploadSetIndex;

- (uint8_t *)imageBuffer
{
    return self->_image_buffer;
}

- (uint8_t *)dataBuffer
{
    return self->_data_buffer;
}

- (id)init {
    self = [super init];
    if (self) {

        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *fileError = [[NSError alloc] init];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [NSString stringWithFormat:@"%@/photos.plist", docDir ];
       
        if ([fileManager fileExistsAtPath:plistPath]) {
            
            NSDictionary *appData = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:plistPath] 
                                                                              options:NSPropertyListMutableContainers
                                                                               format:NULL
                                                                                error:&fileError];
            self.photos = [appData objectForKey:@"photos"];
            self.photoNumber = [[appData objectForKey:@"photoNumber"] intValue];
            self.deviceid = [appData objectForKey:@"deviceid"];
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


// TODO: this function should also delete the thumbnail images
- (BOOL) removePhotoAtIndex: (NSInteger) index {
    if (index >= [self.photos count] || index < 0) {
        return NO;
    }
    NSMutableDictionary *entry = [self.photos objectAtIndex: index];
    NSString *imageFile = [entry objectForKey:@"imageFile"];
    NSString *thumb = [entry objectForKey:@"thumbnail"];
    
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    [fileMgr removeItemAtPath:imageFile error:&error];
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not delete image" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    [fileMgr removeItemAtPath:thumb error:&error];
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not delete thumb" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.photos removeObjectAtIndex:index];
    return YES;
}

- (BOOL) removePhoto: (NSDictionary*) entry {
    for (int i = [self.photos count] - 1; i >= 0; i++) {
        NSDictionary* cursor = [self.photos objectAtIndex:i];
        NSString* cursorFile = [cursor objectForKey:@"imageFile"];
        NSString* entryFile = [entry objectForKey:@"imageFile"];
        if ([cursorFile isEqualToString:entryFile]) {
            return [self removePhotoAtIndex:i];
        }
    }
    return NO;
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
        
    //fileName: docDir/deviceid_photoNumber.png or .thumb.png
    NSString *baseName = [self newFilename];
    NSString *thumbName = [baseName stringByAppendingPathExtension: @"thumb"];
    NSString *fullFilename = [[docDir stringByAppendingPathComponent:baseName] stringByAppendingPathExtension: @"jpg"];
    NSString *thumbFilename = [[docDir stringByAppendingPathComponent:thumbName] stringByAppendingPathExtension: @"thumb.jpg"];
	NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0)];
    //it may need to be written atomically if there's a chance an attempt could be made to upload a file while it's still being written
    [data writeToFile:fullFilename atomically:NO];    
    
    UIImage* thumb = [self makeThumb:image];
    NSData *thumbData = [NSData dataWithData:UIImageJPEGRepresentation(thumb, 0)];
    [thumbData writeToFile:thumbFilename atomically:NO];
    
    [newPhoto setObject: thumbFilename forKey:@"thumbnail"];
    [newPhoto setObject: fullFilename forKey:@"imageFile"];
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

    [format setDateFormat:@"yyyyMMdd'T'HHmmss.SSS'Z'"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString* dateString = [format stringFromDate:[NSDate date]];
    [newPhoto setObject:latitudeString forKey:@"latitude"];
    [newPhoto setObject:longitudeString forKey:@"longitude"];
    [newPhoto setObject:dateString forKey:@"timestamp"];
    
    [self.photos addObject:newPhoto];
    return newPhoto;
}

- (void) saveData {
   
    NSNumber *photonum = [NSNumber numberWithInteger:_photoNumber];
    NSDictionary *appData = [NSDictionary dictionaryWithObjectsAndKeys:self.photos, @"photos", photonum, @"photoNumber", _deviceid, @"deviceid", nil];      NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [[docDir stringByAppendingPathComponent:@"photos" ] stringByAppendingPathExtension: @"plist"];
    [appData writeToFile:plistPath atomically:YES];
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


- (UIImage*) makeThumb: (UIImage *) fullImage {
    CGSize imageSize = [fullImage size];
    int shortestEdge = MIN(imageSize.width, imageSize.height);
    
    CGRect rect = CGRectMake((imageSize.width - shortestEdge)/2, (imageSize.height - shortestEdge)/2, shortestEdge, shortestEdge);
    CGImageRef imageRef = CGImageCreateWithImageInRect([fullImage CGImage], rect);
    UIImage *thumb = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
    CGSize thumbsize = CGSizeMake(180, 180);
    UIGraphicsBeginImageContext(thumbsize);
    [thumb drawInRect:CGRectMake(0, 0, thumbsize.width, thumbsize.height)];
    UIImage *scaledThumb = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    return scaledThumb;
}

- (NSString *)newFilename {
    
    NSString *nameString = [[NSString alloc] init];
    _photoNumber++;
    nameString = [NSString stringWithFormat:@"%@_%05d",_deviceid,_photoNumber];
    return nameString;
}



/* ********************** UPLOADING FUNCTIONS  **************************/
// TODO: run uploading in separate run loop

- (void) uploadPhotosInSet:(NSArray*) photoSet withObserver:(id)target{
    self.uploadNotifyTarget = target;
    self.uploadSet = photoSet;
    self.uploadSetIndex = 0;
    NSInteger index = [[self.uploadSet objectAtIndex:self.uploadSetIndex] intValue];
    [self _startSendAtIndex: index];
}



- (NSString*) getDataFileStringForIndex:(NSInteger) index {
    NSArray *keys = [NSArray arrayWithObjects:@"category", @"composition", @"comment", @"longitude", @"latitude", @"timestamp", nil];
    NSString *output = @"";
    NSDictionary *entry = [self.photos objectAtIndex:index];
    for (int i = 0; i < [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [entry objectForKey:key];
        output = [output stringByAppendingFormat:@"%@=%@\n", key, value];
    }
    return output;
}


- (void)_startSendAtIndex:(NSInteger) index
{
    NSDictionary *photoEntry = [self.photos objectAtIndex:index];
    NSString* imageFilePath = [photoEntry objectForKey:@"imageFile"];
    NSString* imageFile = [imageFilePath lastPathComponent];
    NSString* rootFTPURL = @"ftp://ncftp.neptune.uvic.ca/ios_test";
    
    BOOL                    success;
    NSURL *                 url;
    CFWriteStreamRef        ftpStream;
    
    assert(imageFilePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]);
    assert( [imageFilePath.pathExtension isEqual:@"jpg"]);
    
    assert(self.imageFTPStream == nil);      // don't tap send twice in a row!
    assert(self.imageInputStream == nil);         // ditto
    
    
    // open image input
    self.imageInputStream = [NSInputStream inputStreamWithFileAtPath:imageFilePath];
    assert(self.imageInputStream != nil);
    [self.imageInputStream open];
    
    // open data input
    NSString* dataString = [self getDataFileStringForIndex:index];
    NSData* data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    self.dataInputStream = [NSInputStream inputStreamWithData:data];
    assert(self.dataInputStream != nil);
    [self.dataInputStream open];
    
    // open image output
    url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", rootFTPURL, imageFile]];
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    assert(ftpStream != NULL);
    
    self.imageFTPStream = (__bridge_transfer NSOutputStream *) ftpStream;
    success = [self.imageFTPStream setProperty:@"beachcomber" forKey:(id)kCFStreamPropertyFTPUserName];
    assert(success);
    success = [self.imageFTPStream setProperty:@"deZ6cHeS" forKey:(id)kCFStreamPropertyFTPPassword];
    assert(success);
    
    self.imageFTPStream.delegate = self;
    [self.imageFTPStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.imageFTPStream open];
    
    // open data output
    NSString *dataFileName = [[imageFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
    url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", rootFTPURL, dataFileName]];
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url);
    assert(ftpStream != NULL);
    
    self.dataFTPStream = (__bridge_transfer NSOutputStream *)ftpStream;
    success = [self.dataFTPStream setProperty:@"beachcomber" forKey:(id)kCFStreamPropertyFTPUserName];
    assert(success);
    success = [self.dataFTPStream setProperty:@"deZ6cHeS" forKey:(id)kCFStreamPropertyFTPPassword];
    assert(success);
    
    self.dataFTPStream.delegate = self;
    [self.dataFTPStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.dataFTPStream open];
}



- (void)_stopStream:(NSStream*) stream status:(NSString *)statusString
{
    if (stream == self.imageFTPStream) {
        if (self.imageFTPStream != nil) {
            [self.imageFTPStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.imageFTPStream.delegate = nil;
            [self.imageFTPStream close];
            self.imageFTPStream = nil;
        }
        if (self.imageInputStream != nil) {
            [self.imageInputStream close];
            self.imageInputStream = nil;
        }
    }
    else if (stream == self.dataFTPStream) {
        if (self.dataFTPStream != nil) {
            [self.dataFTPStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            self.dataFTPStream.delegate = nil;
            [self.dataFTPStream close];
            self.dataFTPStream = nil;
        }
        if (self.dataInputStream != nil) {
            [self.dataInputStream close];
            self.dataInputStream = nil;
        }
    }
    else {
        assert(NO);
    }
    if (statusString != nil) {
        // TODO: show alert upon failure
        NSLog(@"FTP error: %@", statusString);
    }
    
    // when both image and data have finished:
    if (self.imageFTPStream == nil && self.dataFTPStream == nil) {
        self.uploadSetIndex++;
        if (self.uploadSetIndex < [self.uploadSet count]) {
            // start the next upload if there is another
            NSInteger index = [[self.uploadSet objectAtIndex:self.uploadSetIndex] intValue];
            [self _startSendAtIndex: index];
        }
        else {
            // TODO: end upload loop.
            SEL didStopSelector = @selector(_sendDidStopWithStatus:);
            if ([self.uploadNotifyTarget respondsToSelector:didStopSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.uploadNotifyTarget performSelector:didStopSelector withObject:statusString];
#pragma clang diagnostic pop         
            }
            self.uploadSet = nil;
            self.uploadSetIndex = 0;
            self.uploadNotifyTarget = nil;
        }
    }

}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our 
// network stream.
{
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            // ignore. Could add update function to notify of connection opened:
            //[self _updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSInputStream *inputStream;
            NSOutputStream *outputStream;
            size_t buffer_offset_tmp;
            size_t buffer_limit_tmp;
            uint8_t *buffer_ref;
            if (aStream == self.imageFTPStream) {
                inputStream = self.imageInputStream;
                outputStream = self.imageFTPStream;
                buffer_offset_tmp = self.imageBufferOffset;
                buffer_limit_tmp = self.imageBufferLimit;
                buffer_ref = self.imageBuffer;
            }
            else if (aStream == self.dataFTPStream) {
                inputStream = self.dataInputStream;
                outputStream = self.dataFTPStream;
                buffer_offset_tmp = self.dataBufferOffset;
                buffer_limit_tmp = self.dataBufferLimit;
                buffer_ref = self.dataBuffer;
            }
            else {
                assert(NO);
            }
            
            // If we don't have any data buffered, go read the next chunk of data.
            if (buffer_offset_tmp == buffer_limit_tmp) {
                NSInteger   bytesRead;
                
                bytesRead = [inputStream read:buffer_ref maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self _stopStream: aStream status:@"File read error"];
                } else if (bytesRead == 0) {
                    [self _stopStream: aStream status:nil];
                } else {
                    buffer_offset_tmp = 0;
                    buffer_limit_tmp  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            if (buffer_offset_tmp != buffer_limit_tmp) {
                NSInteger   bytesWritten;
                bytesWritten = [outputStream write:&buffer_ref[buffer_offset_tmp] maxLength:buffer_limit_tmp - buffer_offset_tmp];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self _stopStream: aStream status:@"Network write error"];
                } else {
                    buffer_offset_tmp += bytesWritten;
                }
            }
            
            if (aStream == self.imageFTPStream) {
                self.imageBufferOffset = buffer_offset_tmp;
                self.imageBufferLimit = buffer_limit_tmp;
            }
            else if (aStream == self.dataFTPStream) {                
                self.dataBufferOffset = buffer_offset_tmp;
                self.dataBufferLimit = buffer_limit_tmp;
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopStream: aStream status:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}


@end
