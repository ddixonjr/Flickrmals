//
//  DDPhotosDisplayViewController.h
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFlickrManager.h"


@interface DDPhotosDisplayViewController : UICollectionViewController

@property (strong, nonatomic) DDFlickrManager *flickrManager;

@end
