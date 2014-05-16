//
//  PTHotPocketDetector.m
//  PitaBread
//
//  Created by Jackson Owens on 1/24/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import "PTHotPocketDetector.h"
#import "PTColorHistogram.h"
#import <Foundation/Foundation.h>

using namespace std;

@implementation PTHotPocketDetector

string dataFile;

- (id)init:(string) dataFile
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (bool)isHotPocket:(UIImage*)im {
    PTColorHistogram* hist = [[PTColorHistogram alloc] init:im];
    float total_red = 0;
    float total_green = 0;
    float total_blue = 0;
    for (int i=3*16; i<4*16; i++) {
        total_red += hist.histogram[i];
    }
    
//    total_red = hist.histogram[(4*16)-1];
//    for (int i=3*8;i<4*8;i++) {
//        total_green += hist.histogram[i];
//    }
//    for (int i=16;i<2*16;i++) {
//        total_blue += hist.histogram[i];
//    }
    [hist delete];
    NSLog(@"red percent: %f\n", total_red);
    if (total_red > .25) {
        return true;
    }
    return false;
}

@end
