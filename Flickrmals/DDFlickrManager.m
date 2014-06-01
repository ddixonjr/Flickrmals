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

- (NSArray *)getPhotoSetWithSearchKeyword:(NSString *)searchKeyword
{

}


- (NSArray *)getPhotoSetWithPhotogID:(NSString *)flickrPhotogID
{

}


- (NSArray *)refreshPhotoSetWithSearchKeyword:(NSString *)searchKeyword
{

}


- (NSArray *)refreshPhotoSetWithPhotogID:(NSString *)flickrPhotogID
{

}


#pragma mark - Private/Helper Methods

- (void)pullPhotoSetOfType:(DDFlickrPhotoSetRequestType)photoSetRequestType withSearchString:(NSString *)searchString
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
        for (NSDictionary *photoDictionary in rawPhotoSetArray)
        {
            NSData *newPhotoData = [NSData dataWithContentsOfURL:[photoDictionary objectForKey:@"url_q"]];
            // Add error checking here??
            DDPhoto *newDDPhoto = [[DDPhoto alloc] initWithImageData:newPhotoData];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
            newDDPhoto.photoTitle = [photoDictionary objectForKey:@""];
        }
    }
    else
    {
        NSLog(@"DDFlickrManager: error pulling photoset dictionary");
    }

}

@end
