//
//  PTLocationDetector.h
//  MyLittlePITA
//
//  Created by Jackson Owens on 3/22/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PTServer.h"

@interface PTLocationDetector : NSObject<CLLocationManagerDelegate>

// The location manager that we will receive location updates from
@property (nonatomic, strong) CLLocationManager *locationManager;

// The last known current location.
@property CLLocation *currentLocation;

// The server object to use when broadcasting the user location
@property PTServer *server;

- (id)initWithServer:(PTServer *)s;

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

@end
