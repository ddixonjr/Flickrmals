//
//  DDFlickrManager.h
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    DDFlickrPhotoSetRequestPhotogType,
    DDFlickrPhotoSetRequestSearchKeywordType
}DDFlickrPhotoSetRequestType;

@protocol DDFlickrManagerDelegate

- (void)didCompletePhotoSetLoad:(NSArray *)photoset;

@end



@interface DDFlickrManager : NSObject

@property (strong, nonatomic) id<DDFlickrManagerDelegate> delegate;

-(NSArray *)getPhotoSetWithSearchKeyword:(NSString *)searchKeyword withRefresh:(BOOL)refreshRequested;
-(NSArray *)getPhotoSetWithPhotogID:(NSString *)flickrPhotogID withRefresh:(BOOL)refreshRequested;

@end
