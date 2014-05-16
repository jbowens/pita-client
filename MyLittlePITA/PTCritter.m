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

@property (atomic) BOOL isSleeping;
@property (atomic) NSInteger currentMoodState;

@end

@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.name = [properties objectForKey:@"name"];
        self.happiness = 255;
        self.hunger = 255;
        self.discipline = 255;
        self.sleepiness = 255;
    }

    NSMutableDictionary *visualProps = [[NSMutableDictionary alloc] init];
    [visualProps setObject:[properties objectForKey:kPTBodyHueKey] forKey:kPTBodyHueKey];
    _visualProperties = visualProps;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteFood)
                                                 name:@"PitaAteFood" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAteNonFood)
                                                 name:@"PitaAteNonFood" object:nil];
    
    return self;
}

- (void)modifyHappiness:(int)delta
{
    self.happiness = MIN(MAX(self.happiness + delta, 0), 255);
}

- (void)modifyHunger:(int)delta
{
    self.hunger = MIN(MAX(self.hunger + delta, 0), 255);
}

- (void)pitaAteNonFood
{
    self.happiness -= 200;
    self.currentMoodState = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaMad" object:nil];
}

- (void)pitaAteFood
{
    self.hunger += 200;
    self.currentMoodState = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaHappy" object:nil];
}

- (void)pitaNeutral
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaNeutral" object:nil];
}

- (void)updatePitasStatistics
{
    if(self.isSleeping)
    {
        self.sleepiness += 10;
    }
    else
    {
        self.sleepiness -= 1;
    }
    self.happiness -= 1;
    self.hunger -= 1;
    self.discipline -= 1;
    
    if(self.currentMoodState == 500)
    {
        [self pitaNeutral];
    }
    self.currentMoodState ++;
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
