//
//  DDPhoto.h
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPhoto : NSObject

@property (strong, readonly, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *photogID;
@property (strong, nonatomic) NSString *photogName;
@property (strong, nonatomic) NSString *photoID;
@property (strong, nonatomic) NSString *photoDescription;
@property (strong, nonatomic) NSString *photoTitle;
@property (assign, nonatomic) double photoLatitude;
@property (assign, nonatomic) double photoLongitude;

- (id)initWithImageData:(NSData *)imageData;

@end
