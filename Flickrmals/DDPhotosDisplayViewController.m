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
#import "DDAppDelegate.h"
#import "DDPhoto.h"

#define kLionTab 0
#define kTigerTab 1
#define kBearTab 2
#define kColorDarkBlueRed       75.0/255.0
#define kColorDarkBlueGreen     94.0/255.0
#define kColorDarkBlueBlue      122.0/255.0
#define kColorBaseBlueRed       176.0/255.0
#define kColorBaseBlueGreen     198.0/255.0
#define kColorBaseBlueBlue      233.0/255.0
#define kColorPaleOrangeRed     252.0/255.0
#define kColorPaleOrangeGreen   185.0/255.0
#define kColorPaleOrangeBlue    112.0/255.0
#define kDefaultNavBarColorAlpha 0.7

@interface DDPhotosDisplayViewController () <DDPhotoCollectionViewCellDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *photoSetArray;

@end



@implementation DDPhotosDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.flickrManager == nil)
    {
        self.flickrManager = [[DDFlickrManager alloc] init];
    }

    [self setUpMainViewColors];
    [self getPhotoSetUsingTabWithRefresh:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    if (self.photogID != nil)
    {
        self.tabBarController.tabBar.hidden = YES;
        self.title = (self.photogName != nil && [self.photogName length] > 0) ? self.photogName : @"Photog Work Sample";
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }

    [self getPhotoSetUsingTabWithRefresh:NO];
}


#pragma mark - DDPhotoCollectionViewCellDelegate Methods

-(void)ddCollectionViewCell:(DDPhotoCollectionViewCell *)photoCell didSelectInsetAccessoryButtonWithTag:(NSInteger)buttonTag
{
    DDPhoto *selectedPhoto = [self.photoSetArray objectAtIndex:photoCell.tag];
    if (buttonTag == kDDPhotoCollectionViewCellInsetButton0)
    {
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
    else if (buttonTag == kDDPhotoCollectionViewCellRearButton0)
    {
        switch (self.tabBarController.selectedIndex)
        {
            case kLionTab:
                [self performSegueWithIdentifier:@"PhotogWorksSegue1" sender:selectedPhoto];
                break;
            case kTigerTab:
                [self performSegueWithIdentifier:@"PhotogWorksSegue2" sender:selectedPhoto];
                break;
            case kBearTab:
                [self performSegueWithIdentifier:@"PhotogWorksSegue3" sender:selectedPhoto];
                break;
            default:
                break;
        }
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
    NSString *photoInfoString = [NSString stringWithFormat:@"\n%@\n\nFrom:\n%@\n\nTaken on:\n%@",
                                 curPhoto.photoTitle,curPhoto.photogName,curPhoto.photoDate];
//    cell.textView.text = ([curPhoto.photoDescription length] > 0) ? curPhoto.photoDescription : @"No Description Found";

    dispatch_queue_t bkgndQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bkgndQueue,^{
        NSData *newPhotoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:curPhoto.photoURL]];
        if (newPhotoData) {
            dispatch_async(dispatch_get_main_queue(),^{
                cell.imageView.image = [UIImage imageWithData:newPhotoData];
                [cell setNeedsLayout];
            });
        }
    });

    cell.textView.text = photoInfoString;
    cell.tag = indexPath.row;
    cell.titleLabel.text = ([curPhoto.photoTitle length] > 0) ? curPhoto.photoTitle : @"No Description Found";
    cell.delegate = self;

    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout Delegate Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    NSLog(@"in insetForSectionAtIndex");
    UIEdgeInsets insets;
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    {
        insets = UIEdgeInsetsMake(7.0, 5.0, 0.0, 5.0);
    }
    else
    {
        insets = UIEdgeInsetsMake(30.0, 5.0, 30.0, 5.0);
    }
    return insets;
}

#pragma mark - Device Orientation Response Methods

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"in didRotateFromInterfaceOrientation");
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        UICollectionViewFlowLayout *curFlowLayout = (UICollectionViewFlowLayout *) self.collectionViewLayout;
        curFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    else
    {
        UICollectionViewFlowLayout *curFlowLayout = (UICollectionViewFlowLayout *) self.collectionViewLayout;
        curFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }

    [self.collectionView reloadData];
}


#pragma mark - Helper Methods



- (void)getPhotoSetUsingTabWithRefresh:(BOOL)shouldRefresh
{
    if (self.photogID == nil)
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
                break;
        }
    }
    else
    {
        self.photoSetArray = [self.flickrManager getPhotoSetWithPhotogID:self.photogID withRefresh:shouldRefresh];
    }
}



- (void)setUpMainViewColors
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleBlackOpaque;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = [UIColor colorWithRed:kColorDarkBlueRed
                                          green:kColorDarkBlueGreen
                                           blue:kColorDarkBlueBlue
                                          alpha:kDefaultNavBarColorAlpha];

    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application.windows objectAtIndex:0];
    UITabBarController *tabBarController = (UITabBarController *) window.rootViewController;

    [tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

    self.collectionView.backgroundColor = [UIColor colorWithRed:kColorBaseBlueRed
                                                          green:kColorBaseBlueGreen
                                                           blue:kColorBaseBlueBlue
                                                          alpha:kDefaultNavBarColorAlpha];
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
        DDPhoto *selectedPhoto = (DDPhoto *) sender;
        DDPhotosDisplayViewController *photogWorksDisplayVC = segue.destinationViewController;
        photogWorksDisplayVC.photogID = selectedPhoto.photogID;
        photogWorksDisplayVC.photogName = selectedPhoto.photogName;
    }

}

@end
