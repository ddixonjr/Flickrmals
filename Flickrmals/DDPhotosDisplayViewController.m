//
//  DDPhotosDisplayViewController.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotosDisplayViewController.h"
#import "DDPhotoMapViewController.h"
#import "DDPhotoCollectionViewCell.h"
#import "DDPhoto.h"

#define kLionTab 0
#define kTigerTab 1
#define kBearTab 2
#define kColorDarkBlueRed       75.0/255.0
#define kColorDarkBlueGreen     94.0/255.0
#define kColorDarkBlueBlue      122.0/255.0
#define kColorBaseBlueRed       131.0/255.0
#define kColorBaseBlueGreen     144.0/255.0
#define kColorBaseBlueBlue      164.0/255.0
#define kColorPaleOrangeRed     252.0/255.0
#define kColorPaleOrangeGreen   185.0/255.0
#define kColorPaleOrangeBlue    112.0/255.0

@interface DDPhotosDisplayViewController () <DDPhotoCollectionViewCellDelegate>

@property (strong, nonatomic) NSArray *photoSetArray;

@end

@implementation DDPhotosDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor colorWithRed:kColorBaseBlueRed
                                                                           green:kColorBaseBlueGreen
                                                                            blue:kColorBaseBlueBlue
                                                                           alpha:0.7];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:kColorDarkBlueRed
                                                          green:kColorDarkBlueGreen
                                                           blue:kColorDarkBlueBlue
                                                          alpha:0.7];

    if (self.flickrManager == nil)
    {
        self.flickrManager = [[DDFlickrManager alloc] init];
    }

    [self getPhotoSetUsingTabWithRefresh:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self getPhotoSetUsingTabWithRefresh:NO];
}


-(void)ddCollectionViewCell:(DDPhotoCollectionViewCell *)photoCell didRecieveLongTapWithFlippedOnBackStatus:(BOOL)isFlippedOnBack
{



}

-(void)ddCollectionViewCell:(DDPhotoCollectionViewCell *)photoCell didSelectInsetAccessoryButtonWithTag:(NSInteger)buttonTag
{
    DDPhoto *selectedPhoto = [self.photoSetArray objectAtIndex:photoCell.tag];
    switch (self.tabBarController.selectedIndex)
    {
        case kLionTab:
            [self performSegueWithIdentifier:@"PhotoMapSegue1" sender:selectedPhoto];
            break;
        case kTigerTab:
            [self performSegueWithIdentifier:@"PhotoMapSegue2" sender:selectedPhoto];
            break;
        case kBearTab:
            [self performSegueWithIdentifier:@"PhotoMapSegue3" sender:selectedPhoto];
            break;
        default:
            break;
    }
}


#pragma mark - UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoSetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    DDPhoto *curPhoto = [self.photoSetArray objectAtIndex:indexPath.row];
    NSString *photoInfoString = [NSString stringWithFormat:@"%@\n\nFrom:\n%@\n\nTaken on:\n%@",
                                 curPhoto.photoTitle,curPhoto.photogName,curPhoto.photoDate];
//    cell.textView.text = ([curPhoto.photoDescription length] > 0) ? curPhoto.photoDescription : @"No Description Found";
    cell.textView.text = photoInfoString;
    cell.imageView.image = curPhoto.image;
    cell.tag = indexPath.row;
    cell.titleLabel.text = ([curPhoto.photoTitle length] > 0) ? curPhoto.photoTitle : @"No Description Found";
    cell.delegate = self;

    return cell;
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    DDPhotoCollectionViewCell *selectedCell =   (DDPhotoCollectionViewCell *)
//                                                [self.collectionView cellForItemAtIndexPath:indexPath];
//    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
//
//    [selectedCell flip];
//}


#pragma mark - Helper Methods

- (void)getPhotoSetUsingTabWithRefresh:(BOOL)shouldRefresh
{
    switch (self.tabBarController.selectedIndex)
    {
        case kLionTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Lion" withRefresh:shouldRefresh];
            break;
        case kTigerTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Tiger" withRefresh:shouldRefresh];
            break;
        case kBearTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Bear" withRefresh:shouldRefresh];
            break;
        default:
            //            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Lion" withRefresh:YES];
            break;
    }
}


#pragma mark - UIStoryboard Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PhotoMapSegue1"] ||
        [segue.identifier isEqualToString:@"PhotoMapSegue2"] ||
        [segue.identifier isEqualToString:@"PhotoMapSegue3"])
    {
        DDPhotoMapViewController *photoMapVC = segue.destinationViewController;
        photoMapVC.photo = (DDPhoto *) sender;
    }
    else if ([segue.identifier isEqualToString:@"PhotogWorksSegue1"] ||
             [segue.identifier isEqualToString:@"PhotogWorksSegue2"] ||
             [segue.identifier isEqualToString:@"PhotogWorksSegue3"])
    {

    }

}

@end
