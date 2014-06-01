//
//  DDPhotoCollectionCell.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotoCollectionCell.h"

@implementation DDPhotoCollectionCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = self.contentView.bounds;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
