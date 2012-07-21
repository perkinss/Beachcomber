//
//  PhotoData.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-20.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoData : NSObject {
    NSMutableArray *photos;
}

@property (nonatomic, retain) NSMutableArray *photos;

- (void) saveData;
- (NSInteger) count;
- (void) addPhoto:(UIImage*) image WithTitle:(NSString*)title comment:(NSString*)comment category:(NSString*)category;
- (NSDictionary*) photoAtIndex: (NSInteger) index;

@end
