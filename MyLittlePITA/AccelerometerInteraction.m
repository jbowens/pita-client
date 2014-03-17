//
//  AccelerometerInteraction.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "AccelerometerInteraction.h"

@interface AccelerometerInteraction() <UIAccelerometerDelegate>

@property (strong, nonatomic) CMMotionManager* motionManager;

@end

@implementation AccelerometerInteraction


- (id)init
{
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)startCheckingAccelerometer
{
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                        if(error){
                                            NSLog(@"%@", error);
                                        }
                                    }];
}

-(void)outputRotationData:(CMRotationRate)rotation
{    //TODO: For the movements accelormeter;
    float totalMovement = fabs(rotation.x) + fabs(rotation.y) + fabs(rotation.z);
    
    if(totalMovement > 4)
    {
        //NSLog([NSString stringWithFormat:@"Rotation: %f", totalMovement]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaAwokenByMovement" object:self];
    }
}



@end
