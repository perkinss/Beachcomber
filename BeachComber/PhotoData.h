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

- (void) saveData;
- (NSInteger) count;
- (NSMutableDictionary* ) addPhoto:(UIImage*) image withLocation:(CLLocation*)location;

- (NSDictionary*) photoAtIndex: (NSInteger) index;
- (UIImage*) photoImageAtIndex: (NSInteger) index;
- (BOOL) removePhotoAtIndex: (NSInteger) index;
- (BOOL) movePhotoAtIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
- (void) uploadPhotosInSet:(NSSet*) photoSet;

@end
