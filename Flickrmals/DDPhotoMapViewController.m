//
//  DDPhotoMapViewController.m
//  Flickrmals
//
//  Created by Dennis Dixon on 5/31/14.
//  Copyright (c) 2014 Appivot LLC. All rights reserved.
//

#import "DDPhotoMapViewController.h"
#import <MapKit/MapKit.h>


@interface DDPhotoMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *photoMapView;

@end

@implementation DDPhotoMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.photo.photoLatitude, self.photo.photoLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(7.0,7.0);
    MKCoordinateRegion region = MKCoordinateRegionMake(pointAnnotation.coordinate,span);
    [self.photoMapView addAnnotation:pointAnnotation];
    [self.photoMapView setRegion:region animated:YES];
}


- (IBAction)onDismissButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
