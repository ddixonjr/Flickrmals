//
//  DDPhotosDisplayViewController.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotosDisplayViewController.h"
#import "DDPhotoMapViewController.h"
#import "DDPhotoCollectionCell.h"
#import "DDPhoto.h"

#define kLionTab 0
#define kTigerTab 1
#define kBearTab 2

@interface DDPhotosDisplayViewController ()

@property (strong, nonatomic) NSArray *photoSetArray;
@property (strong, nonatomic) DDPhoto *selectedPhoto;

@end

@implementation DDPhotosDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.flickrManager == nil)
    {
        self.flickrManager = [[DDFlickrManager alloc] init];
    }

    switch (self.tabBarController.selectedIndex)
    {
        case kLionTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Lion" withRefresh:YES];
            break;
        case kTigerTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Tiger" withRefresh:YES];
            break;
        case kBearTab:
            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Bear" withRefresh:YES];
            break;
        default:
//            self.photoSetArray = [self.flickrManager getPhotoSetWithSearchKeyword:@"Lion" withRefresh:YES];
            break;
    }

}


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
    DDPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    DDPhoto *curPhoto = [self.photoSetArray objectAtIndex:indexPath.row];

    cell.imageView.image = curPhoto.image;


    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDPhotoCollectionCell *selectedCell = (DDPhotoCollectionCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];

//    self.selectedPhoto = [self.photoSetArray objectAtIndex:indexPath.row];
    [UIView beginAnimations:@"PhotoSelectAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    selectedCell.imageView.image = nil;
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:selectedCell cache:NO];
    [UIView commitAnimations];


//    A test of the photo mapping functionality -- it works!
//    switch (self.tabBarController.selectedIndex)
//    {
//        case kLionTab:
//            [self performSegueWithIdentifier:@"PhotoMapSegue1" sender:nil];
//            break;
//        case kTigerTab:
//            [self performSegueWithIdentifier:@"PhotoMapSegue2" sender:nil];
//            break;
//        case kBearTab:
//            [self performSegueWithIdentifier:@"PhotoMapSegue3" sender:nil];
//            break;
//        default:
//            break;
//    }


}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PhotoMapSegue1"] ||
        [segue.identifier isEqualToString:@"PhotoMapSegue2"] ||
        [segue.identifier isEqualToString:@"PhotoMapSegue3"])
    {
        DDPhotoMapViewController *photoMapVC = segue.destinationViewController;
        photoMapVC.photo = self.selectedPhoto;
    }
    else if ([segue.identifier isEqualToString:@"PhotogWorksSegue1"] ||
             [segue.identifier isEqualToString:@"PhotogWorksSegue2"] ||
             [segue.identifier isEqualToString:@"PhotogWorksSegue3"])
    {

    }

}

@end
