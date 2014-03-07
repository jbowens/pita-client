//
//  PTGameScene.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritterNode.h"
#import "PTGameScene.h"

static const float kDefaultVerticalPosition = .6;

@interface PTGameScene ()

@property (nonatomic) PTCritterNode *critterNode;

@end

@implementation PTGameScene

-(id)initWithSize:(CGSize)size {    
    return [self initWithSize:size critterProperties:[NSDictionary dictionary]];
}

- (instancetype)initWithSize:(CGSize)size critterProperties:(NSDictionary *)properties {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithWhite:0.95 alpha:1];
        
        PTCritterNode *critterNode = [PTCritterNode critterNodeWithVisualProperties:properties];
        critterNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * kDefaultVerticalPosition);
        [self addChild:critterNode];
        
        self.critterNode = critterNode;
        
    }
    return self;
}


+ (instancetype)sceneWithSize:(CGSize)size critterProperties:(NSDictionary *)properties {
    return [[PTGameScene alloc] initWithSize:size critterProperties:properties];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)runEntranceSequence {
    [self.critterNode removeAllActions];
    
    CGPoint dest = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * kDefaultVerticalPosition);
    CGPoint src = CGPointMake(dest.x, dest.y * .9);
    
    self.critterNode.position = src;
    SKAction *moveToCenter = [SKAction moveTo:dest duration:.6];
    moveToCenter.timingMode = SKActionTimingEaseOut;
    
    SKAction *critterEntrance = [SKAction sequence:@[moveToCenter]];
    [self.critterNode runAction:critterEntrance];
}

@end
