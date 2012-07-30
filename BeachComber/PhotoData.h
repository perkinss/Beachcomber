//
//  PhotoData.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoData : NSObject {
    NSMutableArray *photos;
}

@property (nonatomic, retain) NSMutableArray *photos;
@property (nonatomic) NSInteger photoNumber;
@property (nonatomic, retain) NSString *deviceid;

- (void) saveData;
- (NSInteger) count;
- (NSString *) newFilename;
- (NSMutableDictionary* ) addPhoto:(UIImage*) image withLocation:(CLLocation*)location;

- (NSDictionary*) photoAtIndex: (NSInteger) index;
- (UIImage*) photoImageAtIndex: (NSInteger) index;
- (UIImage*) thumbImageAtIndex: (NSInteger) index;
- (BOOL) removePhotoAtIndex: (NSInteger) index;
- (BOOL) movePhotoAtIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
- (void) uploadPhotosInSet:(NSSet*) photoSet;

@end
