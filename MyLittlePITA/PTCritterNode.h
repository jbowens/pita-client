//
//  PTCritterNode.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/14/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    PTCritterStatusSad,
    PTCritterStatusHappy,
    PTCritterStatusNormal,
    PTCritterStatusEating,
    PTCritterStatusHungry,
    PTCritterStatusSleeping,
    PTCritterStatusListening,
    PTCritterStatusMad
} PTCritterStatus;

const static NSString *kPTBodyHueKey        = @"body_hue";

@interface PTCritterNode : SKNode

@property (nonatomic) PTCritterStatus status;

- (instancetype)initWithVisualProperties:(NSDictionary *)properties;
+ (instancetype)critterNodeWithVisualProperties:(NSDictionary *)properties;

@end
