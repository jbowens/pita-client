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
    PTCritterStatusVeryHappy,
    PTCritterStatusNormal,
    PTCritterStatusMad
} PTCritterStatus;

@interface PTCritterNode : SKNode

@property (nonatomic) PTCritterStatus status;

- (instancetype)initWithVisualProperties:(NSDictionary *)properties;
+ (instancetype)critterNodeWithVisualProperties:(NSDictionary *)properties;

@end
