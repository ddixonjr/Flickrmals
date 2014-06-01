//
//  DDPhotosDisplayViewController.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotosDisplayViewController.h"


@interface DDPhotosDisplayViewController ()



@end

@implementation DDPhotosDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.flickrManager == nil)
    {
        self.flickrManager = [[DDFlickrManager alloc] init];
    }
    [self.flickrManager getPhotoSetWithSearchKeyword:@"Lion" withRefresh:YES];
    [self.flickrManager getPhotoSetWithPhotogID:@"92269745@N00" withRefresh:YES];
    [self.flickrManager getPhotoSetWithSearchKeyword:@"Tiger" withRefresh:YES];
    [self.flickrManager getPhotoSetWithSearchKeyword:@"Bear" withRefresh:YES];

}


@end
