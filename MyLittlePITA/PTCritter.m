//
//  PTCritter.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritter.h"


@implementation PTCritter

- (instancetype)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    
    if (self) {
        self.happiness = @255;
        if ([properties objectForKey:@"happiness"]) {
            self.happiness = [properties objectForKey:@"happiness"];
        }
    }
    
    return self;
}


+ (instancetype)critterWithProperties:(NSDictionary *)properties
{
    return [[PTCritter alloc] initWithProperties:properties];
}

@end
