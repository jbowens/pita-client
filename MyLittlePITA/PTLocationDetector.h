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

#define kLocationPostInterval 60.0

@interface PTLocationDetector : NSObject<CLLocationManagerDelegate>

// The location manager that we will receive location updates from
@property (nonatomic, strong) CLLocationManager *locationManager;

// The last known current location
@property CLLocation *currentLocation;

// The last location to be posted to the server.
@property CLLocation *lastPostedLocation;

// The server object to use when broadcasting the user location
@property PTServer *server;

// The timer used for periodically posting location to the server
@property (nonatomic, strong) NSTimer *postTimer;

// Has the location been posted to the server yet at all?
@property BOOL locationHasBeenPosted;

- (id)initWithServer:(PTServer *)s;

- (void)postLocationToServer;

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
