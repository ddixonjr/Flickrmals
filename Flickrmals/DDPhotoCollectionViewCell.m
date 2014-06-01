//
//  DDPhotoCollectionCell.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotoCollectionViewCell.h"

#define kDefaultAnimationDuration 0.7
#define kInsetHeightFactor 0.25
#define kInsetOriginX 0.0
#define kInsetOriginY 114
#define kInsetShowingAlpha 0.7
#define kInsetFadedAlpha 0.0
#define kDefaultLongPressDuration 0.5

@interface DDPhotoCollectionViewCell ()

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UIButton *insetButton1;
@property (strong, nonatomic) UIButton *rearViewButton;

@end

@implementation DDPhotoCollectionViewCell


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubviews];
        [self setUpGestureRecognizers];
    }
    return self;
}


- (void)flip:(UITapGestureRecognizer *)tapGestureRecognizer
{
//    NSLog(@"in flip - isFlippedOnBack on entry is %d", self.isFlippedOnBack);
    [UIView beginAnimations:@"FlipSelf" context:nil];
    [UIView setAnimationDuration:kDefaultAnimationDuration];

    self.isFlippedOnBack = !self.isFlippedOnBack;
    if (self.isFlippedOnBack)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        self.imageView.hidden = YES;
        self.textView.hidden = NO;
        self.rearViewButton.hidden = NO;
        if (self.isInsetShowing)
        {
            [self toggleInsetView:nil];
        }
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
        self.imageView.hidden = NO;
        self.textView.hidden = YES;
        self.rearViewButton.hidden = YES;

        if (self.isInsetShowing)
        {
            [self toggleInsetView:nil];
        }
    }

    [UIView commitAnimations];
//    NSLog(@"in flip - isFlippedOnBack on exit is %d", self.isFlippedOnBack);

}


- (void)toggleInsetView:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
//        NSLog(@"in toggleInsetView - isInsetShowing on entry is %d", self.isInsetShowing);

        self.isInsetShowing = !self.isInsetShowing;
        if (self.isInsetShowing)
        {
            [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                self.insetView.alpha = kInsetShowingAlpha;
                self.insetView.hidden = NO;
            }];

        }
        else
        {
            [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
                self.insetView.alpha = kInsetFadedAlpha;
                self.insetView.hidden = YES;
            }];
        }
//        NSLog(@"in toggleInsetView - isInsetShowing on exit is %d", self.isInsetShowing);
    }

}


#pragma mark - Helper Methods

- (void)setUpSubviews
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.contentView.bounds;
    self.imageView.hidden = NO;

    self.textView = [[UITextView alloc] init];
    self.textView.frame = self.contentView.bounds;
    self.textView.userInteractionEnabled = NO;
    self.textView.hidden = YES;

    self.rearViewButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    self.rearViewButton.frame = CGRectMake(126.0, 2.0, 22.0, 22.0);
    self.rearViewButton.tag = kDDPhotoCollectionViewCellRearButton0;
    [self.rearViewButton addTarget:self action:@selector(rearButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.rearViewButton];
    self.rearViewButton.hidden = YES;

    self.isInsetShowing = NO;
    self.isFlippedOnBack = NO;

    [self setUpInsetView];
}

- (void)setUpInsetView
{
    self.insetView = [[UITextView alloc] init];
    self.insetView.frame = CGRectMake(kInsetOriginX,
                                      (self.contentView.bounds.size.height-(self.contentView.bounds.size.height*kInsetHeightFactor)),
                                      self.contentView.bounds.size.width,
                                      self.contentView.bounds.size.height*kInsetHeightFactor);

    self.insetButton1 = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.insetButton1.frame = CGRectMake(121.0, 8.0, 22.0, 22.0);
    self.insetButton1.tag = 0;
    [self.insetButton1 addTarget:self action:@selector(insetButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.insetView addSubview:self.insetButton1];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(6.0, 3.0, 107.0, 34.0);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    [self.insetView addSubview:self.titleLabel];

    self.insetView.hidden = YES;
    self.insetView.backgroundColor = [UIColor blackColor];
    self.insetView.alpha = kInsetFadedAlpha;
    self.isInsetShowing = NO;
}

- (void)insetButtonPressed:(UIButton *)insetButtonPressed
{
    [self.delegate ddCollectionViewCell:self didSelectInsetAccessoryButtonWithTag:insetButtonPressed.tag];
}


- (void)rearButtonPressed:(UIButton *)rearButtonPressed
{
    [self.delegate ddCollectionViewCell:self didSelectInsetAccessoryButtonWithTag:rearButtonPressed.tag];
}


- (void)setUpGestureRecognizers
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip:)];
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(toggleInsetView:)];
    self.longPressGestureRecognizer.minimumPressDuration = kDefaultLongPressDuration;

    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.insetView];
    [self.contentView addGestureRecognizer:self.tapGestureRecognizer];
    [self.contentView addGestureRecognizer:self.longPressGestureRecognizer];
}


@end
