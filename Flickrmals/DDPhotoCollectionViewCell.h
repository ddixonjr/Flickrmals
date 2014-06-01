//
//  DDPhotoCollectionCell.h
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DDPhotoCollectionViewCell;

@protocol DDPhotoCollectionViewCellDelegate

- (void)ddCollectionViewCell:(DDPhotoCollectionViewCell *)photoCell didSelectInsetAccessoryButtonWithTag:(NSInteger)buttonTag;
- (void)ddCollectionViewCell:(DDPhotoCollectionViewCell *)photoCell didRecieveLongTapWithFlippedOnBackStatus:(BOOL)isFlippedOnBack;

@end


@interface DDPhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) id<DDPhotoCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *insetView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) BOOL isFlippedOnBack;
@property (assign, nonatomic) BOOL isInsetShowing;

@end
