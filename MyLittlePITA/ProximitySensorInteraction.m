//
//  ProximitySensorInteraction.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "ProximitySensorInteraction.h"

@interface ProximitySensorInteraction ()

@property (strong, nonatomic) NSTimer* timerForSleep;

@end

@implementation ProximitySensorInteraction


- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)handleProximitySensor
{
    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaWokenUp)
                                                 name:@"PitaAwokenByMovement" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)pitaWokenUp
{
    [self.timerForSleep invalidate];
    NSLog(@"Pita Woken up");
}

- (void)pitaFellAsleep
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaFellAsleep" object:self];
    NSLog(@"Pita Fell asleep");
}

- (void)orientationChanged:(NSNotificationCenter *)notification
{
    if( [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceDown)
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
    else
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        [self.timerForSleep invalidate];
        
        self.timerForSleep = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(pitaFellAsleep) userInfo:nil repeats:NO];
        NSLog(@"Device is close to user.");
    }
    else
    {
        [self.timerForSleep invalidate];
        NSLog(@"Device is ~not~ closer to user.");
    }
}

@end
