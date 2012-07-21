//
//  PhotoTableViewCell.h
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-19.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell {

    UILabel *titleLabel;
    UILabel *commentLabel;
    UIImageView *cellImage;

}

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *commentLabel;
@property(nonatomic,retain)UIImageView *cellImage;

@end