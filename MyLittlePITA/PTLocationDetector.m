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
    self.locationHasBeenPosted = NO;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    self.currentLocation = nil;

    // Begin listening for location updates.
    [self.locationManager startUpdatingLocation];

    // Start the timer so that we periodically post the current location
    // to the server.
    self.postTimer = [NSTimer timerWithTimeInterval:kLocationPostInterval target:self selector:@selector(postLocationToServer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.postTimer forMode:NSRunLoopCommonModes];

    return self;
}

- (void)postLocationToServer
{
    if (self.currentLocation && self.currentLocation != self.lastPostedLocation)
    {
        self.locationHasBeenPosted = YES;
        self.lastPostedLocation = self.currentLocation;
        NSLog(@"Recording loc (%f, %f)",
              self.currentLocation.coordinate.latitude,
              self.currentLocation.coordinate.longitude);
        [self.server recordLocation:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude]
                          longitude:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude]];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    self.currentLocation = loc;
    if (!self.locationHasBeenPosted)
    {
        // We've never posted a location before, so let's fire the
        // timer early and post the current location.
        [self.postTimer fire];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Received CLLocationManager error %@", error);
    // TODO: Figure out why this sometimes is called on startup, fucking
    // everything up.
}

@end
