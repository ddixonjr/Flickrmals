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
    NSLog(@"DDFlickrManager: in getPhotoSetWithSearchKeyword:withRefresh:");

    NSArray *requestedPhotoSet = [self.photoSetsDictionary objectForKey:searchKeyword];
    if (refreshRequested || requestedPhotoSet == nil)
    {
        if (![self pullPhotoSetOfType:DDFlickrPhotoSetRequestSearchKeywordType withSearchString:searchKeyword])
        {
            return nil;
        }
        requestedPhotoSet = [self.photoSetsDictionary objectForKey:searchKeyword];
    }

    NSLog(@"photoSetsDictionary contains: %@", self.photoSetsDictionary);
    return requestedPhotoSet;
}


- (NSArray *)getPhotoSetWithPhotogID:(NSString *)flickrPhotogID withRefresh:(BOOL)refreshRequested
{
    NSLog(@"DDFlickrManager: in getPhotoSetWithPhotogID:withRefresh:");

    NSArray *requestedPhotoSet = [self.photoSetsDictionary objectForKey:flickrPhotogID];
    if (refreshRequested || requestedPhotoSet == nil)
    {
        if (![self pullPhotoSetOfType:DDFlickrPhotoSetRequestPhotogType withSearchString:flickrPhotogID])
        {
            return nil;
        }
    }

    requestedPhotoSet = [self.photoSetsDictionary objectForKey:flickrPhotogID];

    NSLog(@"photoSetsDictionary contains: %@", self.photoSetsDictionary);
    return requestedPhotoSet;
}


#pragma mark - Private/Helper Methods

- (BOOL)pullPhotoSetOfType:(DDFlickrPhotoSetRequestType)photoSetRequestType withSearchString:(NSString *)searchString
{
    NSString *searchParamPrefix = (photoSetRequestType == DDFlickrPhotoSetRequestSearchKeywordType) ? kFlickrAPISearchKeywordRESTParamPrefix : kFlickrAPIPhotogWorksRESTParamPrefix;

    NSString *photoSetURLString = [NSString stringWithFormat:@"%@%@%@",kFlickrAPIPhotoSearchBaseRESTURL,searchParamPrefix,searchString];

    NSURL *photoSetURL = [NSURL URLWithString:photoSetURLString];
    NSError *dataPullError = [[NSError alloc] init];
    NSData *photoSetData = [NSData dataWithContentsOfURL:photoSetURL options:NSDataReadingUncached error:&dataPullError];
    NSError *photoSetPullError = [[NSError alloc] init];
    NSDictionary *rawPhotoSetContainer = [NSJSONSerialization JSONObjectWithData:photoSetData options:NSJSONReadingAllowFragments error:&photoSetPullError];
    NSDictionary *rawPhotoSetDictionary = [rawPhotoSetContainer objectForKey:@"photos"];
    NSArray *rawPhotoSetArray = [rawPhotoSetDictionary objectForKey:@"photo"];

    if (photoSetPullError.userInfo != nil)
    {
        NSMutableArray *newPhotoSet = [[NSMutableArray alloc] init];
        NSString *curPhotogID = nil;
        for (NSDictionary *photoDictionary in rawPhotoSetArray)
        {
            NSString *newPhotoURLString = [photoDictionary objectForKey:@"url_q"];
            NSData *newPhotoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newPhotoURLString]];

            if (newPhotoData != nil)
            {
                DDPhoto *newDDPhoto = [[DDPhoto alloc] initWithImageData:newPhotoData];
                newDDPhoto.photoTitle = [photoDictionary objectForKey:@"title"];
                newDDPhoto.photoID = [photoDictionary objectForKey:@"id"];
                newDDPhoto.photoDate = [photoDictionary objectForKey:@"datetaken"];
                newDDPhoto.photogName = [photoDictionary objectForKey:@"ownername"];
                newDDPhoto.photogID = [photoDictionary objectForKey:@"owner"];
                NSDictionary *descriptionDictionary = [photoDictionary objectForKey:@"description"];
                newDDPhoto.photoDescription = [descriptionDictionary objectForKey:@"description"];

                NSNumber *coordinatePoint = [photoDictionary objectForKey:@"latitude"];
                newDDPhoto.photoLongitude = [coordinatePoint doubleValue];
                coordinatePoint = [photoDictionary objectForKey:@"longitude"];
                newDDPhoto.photoLongitude = [coordinatePoint doubleValue];

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


- (NSMutableDictionary *)photoSetsDictionary
{
    if (_photoSetsDictionary == nil)
    {
        _photoSetsDictionary = [[NSMutableDictionary alloc] init];
    }
    return _photoSetsDictionary;
}

@end
