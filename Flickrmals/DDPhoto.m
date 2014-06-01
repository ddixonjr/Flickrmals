//
//  DDPhoto.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhoto.h"

@interface DDPhoto ()

@property (strong, nonatomic) UIImage *image;

@end



@implementation DDPhoto

- (id)init
{
    return [self initWithImageData:nil];  // Replace nil with a default image later
}

- (id)initWithImageData:(NSData *)imageData
{
    self = [super init];
    if (self)
    {
        self.image = [UIImage imageWithData:imageData];
    }
    return self;
}

@end
