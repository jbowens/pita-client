//
//  PTHotPocketDetector.m
//  PitaBread
//
//  Created by Jackson Owens on 1/24/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import "PTHotPocketDetector.h"
#import <Foundation/Foundation.h>
#include <string>

@implementation PTHotPocketDetector

std::string dataFile;

- (id)init:(std::string) dataFile
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (bool)isHotPocket:(UIImage*)im {
    float total_red = 0;

    NSLog(@"red percent: %f\n", total_red);
    if (total_red > .25) {
        return true;
    }
    return false;
}

@end
