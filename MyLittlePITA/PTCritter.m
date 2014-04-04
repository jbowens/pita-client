//
//  PTCritter.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritter.h"
#import "PTCritterNode.h"

@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.happiness = 255;
        NSNumber *happiness = [properties objectForKey:@"happiness"];
        if (happiness && [happiness respondsToSelector:@selector(unsignedIntegerValue)]) {
            self.happiness = [happiness unsignedIntegerValue];
        }
    }

    NSMutableDictionary *visualProps = [[NSMutableDictionary alloc] init];
    [visualProps setObject:[properties objectForKey:kPTBodyHueKey] forKey:kPTBodyHueKey];
    [visualProps setObject:[properties objectForKey:kPTSpotsHueKey] forKey:kPTSpotsHueKey];
    NSNumber *spots = @NO;
    if ([properties objectForKey:kPTSpotsPresentKey])
        spots = @YES;
    [visualProps setObject:spots forKey:kPTSpotsPresentKey];
        
    _visualProperties = visualProps;
    
    return self;
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
