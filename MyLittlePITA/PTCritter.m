//
//  PTCritter.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritter.h"

@interface PTCritter()

@property NSDictionary *properties;

@end

@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.properties = properties;
        _currentStatus = PTCritterStatusIdle;
    }
    
    return self;
}


+ (instancetype)critterWithProperties:(NSDictionary *)properties
{
    return [[PTCritter alloc] initWithProperties:properties];
}

@end
