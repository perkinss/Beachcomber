//
//  PhotoTableViewCell.m
//  BeachComber
//
//  Created by Jeff Proctor on 12-07-19.
//  Copyright (c) 2012 University of British Columbia. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

@synthesize titleLabel, commentLabel, cellImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        commentLabel = [[UILabel alloc]init];
        commentLabel.textAlignment = UITextAlignmentLeft;
        commentLabel.font = [UIFont systemFontOfSize:8];
        commentLabel.backgroundColor = [UIColor clearColor];
        
        cellImage = [[UIImageView alloc]init];
        
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:commentLabel];
        [self.contentView addSubview:cellImage];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame= CGRectMake(boundsX+10 ,0, 50, 50);
    titleLabel.frame = frame;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
