//
//  PTLocationDetector.m
//  MyLittlePITA
//
//  Created by Jackson Owens on 3/22/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTLocationDetector.h"

@implementation PTLocationDetector

- (id) initWithServer:(PTServer *)s
{
    if (![super init])
    {
        return nil;
    }
    self.server = s;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    self.currentLocation = nil;

    // Begin listening for location updates.
    NSLog(@"Starting to listen for CLLocationManager updates");
    [self.locationManager startUpdatingLocation];

    return self;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Now at %@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Received locations: %@", locations);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Received CLLocationManager error %@", error);
    // TODO: Handle error case gracefully.
}

@end
