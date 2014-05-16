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

@property (atomic) BOOL isSleeping;

@end

@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.name = [properties objectForKey:@"name"];
        self.happiness = 255;
        self.hunger = 0;
        self.discipline = 255;
        self.sleepiness = 0;
        self.currentStatus = PTCritterStatusNormal;
    }

    NSMutableDictionary *visualProps = [[NSMutableDictionary alloc] init];
    [visualProps setObject:[properties objectForKey:kPTBodyHueKey] forKey:kPTBodyHueKey];
    _visualProperties = visualProps;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteFood)
                                                 name:@"PitaAteFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteNonFood)
                                                 name:@"PitaAteNonFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaScolded)
                                                 name:@"PitaScolded" object:nil];
    
    return self;
}

- (void)setStatus:(PTCritterStatus)status
{
    if (self.currentStatus != status) {
        self.currentStatus = status;
        NSString *notifName = @"PitaNeutral";
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
                notifName = @"PitaVeryHappy";
                break;
            case PTCritterStatusNormal:
            case PTCritterStatusListening:
            case PTCritterStatusEating:
                notifName = @"PitaNeutral";
        }
        NSLog(@"Posting pita status notification: %@", notifName);
        [[NSNotificationCenter defaultCenter] postNotificationName:notifName object:nil];
    }
}

- (void)reevaluteStatus
{
    //NSLog(@"sleepiness: %ld, hunger: %ld, happiness: %ld", (long) self.sleepiness, (long) self.hunger, (long) self.happiness);
    
    if (self.sleepiness > 200 && self.sleepiness >= self.hunger) {
        [self setStatus:PTCritterStatusSleepy];
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

- (void)modifyHappiness:(int)delta
{
    self.happiness = MIN(MAX(self.happiness + delta, 0), 255);
    [self reevaluteStatus];
}

- (void)modifyHunger:(int)delta
{
    self.hunger = MIN(MAX(self.hunger + delta, 0), 255);
    [self reevaluteStatus];
}

- (void)modifySleepiness:(int)delta
{
    self.sleepiness = MIN(MAX(self.sleepiness + delta, 0), 255);
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
    if(self.isSleeping) {
        [self modifySleepiness:-10];
    }
    else {
        [self modifySleepiness:1];
    }
    
    [self modifyHappiness:-1];
    [self modifyHunger:1];
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
