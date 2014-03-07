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

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithWhite:0.95 alpha:1];
        
    }
    return self;
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

- (void)setCritter:(PTCritter *)critter {
    PTCritterNode *critterNode = [PTCritterNode critterNodeWithVisualProperties:critter.visualProperties];
    critterNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * kDefaultVerticalPosition);
    critterNode.status = PTCritterNodeStatusVeryHappy;

    [self addChild:critterNode];
    self.critterNode = critterNode;
}

@end
