//
//  DDFlickrManager.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDFlickrManager.h"
#import "DDPhoto.h"


#define kFlickrAPIPhotoSearchBaseRESTURL @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=9ec85ee4629fef5fd8426f5a0ad87358&safe_search=1&content_type=1&has_geo=1&extras=description%2C+date_upload%2C+date_taken%2C+owner_name%2C+last_update%2C+geo%2C+url_q&per_page=10&page=1&format=json&nojsoncallback=1"

#define kFlickrAPISearchKeywordRESTParamPrefix @"&text="
#define kFlickrAPIPhotogWorksRESTParamPrefix @"&user_id="



@interface DDFlickrManager ()

@property (strong,nonatomic) NSMutableDictionary *photoSetsDictionary;

@end



@implementation DDFlickrManager


#pragma mark - Public/API Methods

- (NSArray *)getPhotoSetWithSearchKeyword:(NSString *)searchKeyword withRefresh:(BOOL)refreshRequested
{
    NSArray *requestedPhotoSet = [self.photoSetsDictionary objectForKey:searchKeyword];
    if (refreshRequested || requestedPhotoSet == nil)
    {
        [self pullPhotoSetOfType:DDFlickrPhotoSetRequestPhotogType withSearchString:searchKeyword];
    };
    return [self.photoSetsDictionary objectForKey:searchKeyword];
}


- (NSArray *)getPhotoSetWithPhotogID:(NSString *)flickrPhotogID withRefresh:(BOOL)refreshRequested
{
    NSArray *requestedPhotoSet = [self.photoSetsDictionary objectForKey:searchKeyword];
    if (refreshRequested || requestedPhotoSet == nil)
    {
        [self pullPhotoSetOfType:DDFlickrPhotoSetRequestPhotogType withSearchString:searchKeyword];
    };
    return [self.photoSetsDictionary objectForKey:searchKeyword];
}


#pragma mark - Private/Helper Methods

- (BOOL)pullPhotoSetOfType:(DDFlickrPhotoSetRequestType)photoSetRequestType withSearchString:(NSString *)searchString
{
    NSString *searchParamPrefix = (photoSetRequestType == DDFlickrPhotoSetRequestSearchKeywordType) ? kFlickrAPISearchKeywordRESTParamPrefix : kFlickrAPIPhotogWorksRESTParamPrefix;

    NSString *photoSetURLString = [NSString stringWithFormat:@"%@%@%@",kFlickrAPIPhotoSearchBaseRESTURL,searchParamPrefix,searchString];

    NSURL *photoSetURL = [NSURL URLWithString:photoSetURLString];
    NSData *photoSetData = [NSData dataWithContentsOfURL:photoSetURL];
    NSError *photoSetPullError = [[NSError alloc] init];
    NSDictionary *rawPhotoSetDictionary = [NSJSONSerialization JSONObjectWithData:photoSetData options:NSJSONReadingAllowFragments error:&photoSetPullError];
    NSArray *rawPhotoSetArray = [rawPhotoSetDictionary objectForKey:@"photo"];

    if (!photoSetPullError)
    {
        NSMutableArray *newPhotoSet = [[NSMutableArray alloc] init];
        NSString *curPhotogID = nil;
        for (NSDictionary *photoDictionary in rawPhotoSetArray)
        {
            NSData *newPhotoData = [NSData dataWithContentsOfURL:[photoDictionary objectForKey:@"url_q"]];
            if (newPhotoData != nil)
            {
                DDPhoto *newDDPhoto = [[DDPhoto alloc] initWithImageData:newPhotoData];
                newDDPhoto.photoTitle = [photoDictionary objectForKey:@"title"];
                newDDPhoto.photoID = [photoDictionary objectForKey:@"id"];
                newDDPhoto.photoLatitude = [photoDictionary objectForKey:@"latitude"];
                newDDPhoto.photoLongitude = [photoDictionary objectForKey:@"longitude"];
                newDDPhoto.photogName = [photoDictionary objectForKey:@"ownername"];
                newDDPhoto.photogID = [photoDictionary objectForKey:@"owner"];
                curPhotogID = newDDPhoto.photogID;
                [newPhotoSet addObject:newDDPhoto];
            }
        }

        if (photoSetRequestType == DDFlickrPhotoSetRequestSearchKeywordType)
        {
            [self.photoSetsDictionary setValue:newPhotoSet forKey:searchString];
        }
        else if (photoSetRequestType == DDFlickrPhotoSetRequestPhotogType)
        {
            [self.photoSetsDictionary setValue:newPhotoSet forKey:curPhotogID];
        }
        return YES;
    }
    else
    {
        NSLog(@"DDFlickrManager: error pulling photoset dictionary");
        return NO;
    }
    return NO;
}

@end
