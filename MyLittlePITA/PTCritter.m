//
//  PTCritter.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritter.h"
#import "PTCritterNode.h"

@interface PTCritter()

/*
 * A special status is a status that has to be manually
 * removed. For ex. sleeping, eating
 */
@property (atomic) PTCritterStatus specialStatus;

/*
 * The current status is the natural status that the pita is
 * in barring any present special statuses. Once the special
 * status is removed, this is the status it will return to.
 */
@property (atomic) PTCritterStatus currentStatus;

@property (atomic) NSTimer *sleepTimer;

@end

@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.name = [properties objectForKey:@"name"];
        self.happiness = 200.0;
        self.hunger = 0;
        self.discipline = 255;
        self.sleepiness = 0;
        self.currentStatus = PTCritterStatusNormal;
        self.specialStatus = PTCritterStatusNormal;
    }

    NSMutableDictionary *visualProps = [[NSMutableDictionary alloc] init];
    [visualProps setObject:[properties objectForKey:kPTBodyHueKey] forKey:kPTBodyHueKey];
    _visualProperties = visualProps;
    
    self.sleepTimer = nil;
    
    // Begin the game tick timer for recording gradual changes in mode over time.
    NSTimer *gameTickTimer = [NSTimer timerWithTimeInterval:0.25
                                                 target:self
                                               selector:@selector(updatePitasStatistics)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:gameTickTimer forMode:NSDefaultRunLoopMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteFood)
                                                 name:@"PitaAteFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteNonFood)
                                                 name:@"PitaAteNonFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaScolded)
                                                 name:@"PitaScolded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaTexturesReady)
                                                 name:@"PitaTexturesLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaWoken)
                                                 name:@"PitaAwokenByMovement" object:nil];
    
    return self;
}

- (void)pitaTexturesReady
{
    [self emitCurrentStatusNotif];
}

- (void)emitCurrentStatusNotif
{
    NSString *notifName = @"PitaNeutral";

    if (self.specialStatus != PTCritterStatusNormal) {
        // There's currently a special status in effect, so we should
        // use that.
        switch (self.specialStatus) {
            case PTCritterStatusTemporarilyHappy:
                notifName = @"PitaVeryHappy";
                break;
            case PTCritterStatusSleeping:
                notifName = @"PitaAsleep";
                break;
            default:
                break;
        }
    } else {
        switch (self.currentStatus) {
            case PTCritterStatusSleepy:
                notifName = @"PitaSleepy";
                break;
            case PTCritterStatusSad:
            case PTCritterStatusHungry:
                notifName = @"PitaSad";
                break;
            case PTCritterStatusMad:
                notifName = @"PitaMad";
                break;
            case PTCritterStatusVeryMad:
                notifName = @"PitaVeryMad";
                break;
            case PTCritterStatusHappy:
                notifName = @"PitaHappy";
                break;
            case PTCritterStatusVeryHappy:
            case PTCritterStatusTemporarilyHappy:
                notifName = @"PitaVeryHappy";
                break;
            case PTCritterStatusNormal:
            case PTCritterStatusListening:
            case PTCritterStatusEating:
            case PTCritterStatusSleeping:
                notifName = @"PitaNeutral";
        }
    }
    NSLog(@"Notification: %@", notifName);
    [[NSNotificationCenter defaultCenter] postNotificationName:notifName object:nil];
}

- (void)startSpecialStatus:(PTCritterStatus)specialStatus
{
    self.specialStatus = specialStatus;
    [self emitCurrentStatusNotif];
}

- (void)setStatus:(PTCritterStatus)status
{
    if (self.currentStatus != status) {
        self.currentStatus = status;
        [self emitCurrentStatusNotif];
    }
}

- (void)reevaluteStatus
{    
    if (self.sleepiness > 200 && self.sleepiness >= self.hunger) {
        [self setStatus:PTCritterStatusSleepy];
        [self runSleepTimer];
        return;
    } else if (self.hunger > 200) {
        [self setStatus:PTCritterStatusMad];
        return;
    }
    
    if (self.happiness < 65) {
        [self setStatus:PTCritterStatusSad];
        return;
    }
    
    if (self.happiness > 220) {
        [self setStatus:PTCritterStatusVeryHappy];
        return;
    }
    
    if (self.happiness > 180) {
        [self setStatus:PTCritterStatusHappy];
        return;
    }

    [self setStatus:PTCritterStatusNormal];
}

- (void)modifyHappiness:(float)delta
{
    self.happiness = MIN(MAX(self.happiness + delta, 0), 255.0);
    [self reevaluteStatus];
}

- (void)modifyHunger:(float)delta
{
    self.hunger = MIN(MAX(self.hunger + delta, 0), 255.0);
    [self reevaluteStatus];
}

- (void)modifySleepiness:(float)delta
{
    self.sleepiness = MIN(MAX(self.sleepiness + delta, 0), 255.0);
    if (self.specialStatus == PTCritterStatusSleeping) {
        // The pita is currently asleep. If they're rested, we should
        // awake them.
        if (self.sleepiness <= 20) {
            [self pitaWoken];
        }
    }
    [self reevaluteStatus];
}

- (void)pitaAteNonFood
{
    [self modifyHappiness:-200];
}

- (void)pitaAteFood
{
    [self modifyHunger:-200];
}

- (void)pitaScolded
{
    [self modifyHappiness:-50];
}

- (void)updatePitasStatistics
{
    //NSLog(@":) %f, :D: %f, Zzz: %f", self.happiness, self.hunger, self.sleepiness);

    if(self.specialStatus == PTCritterStatusSleeping) {
        [self modifySleepiness:-3];
    }
    else {
        [self modifySleepiness:2.0];
    }
    
    [self modifyHappiness:-0.25];
    [self modifyHunger:1.0];
}

- (void)runSleepTimer
{
    if (!self.sleepTimer) {
        // There's no current sleep timer, so we should start one.
        self.sleepTimer = [NSTimer timerWithTimeInterval:20
                                                  target:self
                                                selector:@selector(goToSleep)
                                                userInfo:nil
                                                 repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.sleepTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)goToSleep
{
    NSLog(@"Going to sleep");
    [self startSpecialStatus:PTCritterStatusSleeping];
    self.sleepTimer = nil;
}

- (void)pitaWoken
{
    if (self.specialStatus == PTCritterStatusSleeping) {
        NSLog(@"Ending sleep.");
        self.specialStatus = PTCritterStatusNormal;
        [self emitCurrentStatusNotif];
    } else if (self.sleepTimer) {
        NSLog(@"Delaying sleep timer because of movement.");
        [self.sleepTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:20]];
    }
}

+ (instancetype)critterWithProperties:(NSDictionary *)properties
{
    return [[PTCritter alloc] initWithProperties:properties];
}

- (id)valueForKey:(NSString *)key
{
    if ([key isEqualToString:@"happiness"]) {
        return [NSNumber numberWithUnsignedInteger:self.happiness];
    }
    
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"happiness"] && [value respondsToSelector:@selector(unsignedIntegerValue)]) {
        self.happiness = [value unsignedIntegerValue];
    }
}

@end
