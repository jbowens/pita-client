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
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaWokenUp)
                                                 name:@"PitaAwokenByMovement" object:nil];
}

- (void)pitaWokenUp
{
    [self.timerForSleep invalidate];
    NSLog(@"Pita Woken up");
}

- (void)pitaFellAsleep
{
    NSLog(@"Pita Fell asleep");
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
