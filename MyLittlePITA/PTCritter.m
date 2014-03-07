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
        self.happiness = 255;
        NSNumber *happiness = [properties objectForKey:@"happiness"];
        if (happiness && [happiness respondsToSelector:@selector(unsignedIntegerValue)]) {
            self.happiness = [happiness unsignedIntegerValue];
        }
    }
    
    _visualProperties = properties;
    
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
