//
//  PTCritterScene.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritterNode.h"
#import "PTCritterScene.h"

@interface PTCritterScene ()

@property (nonatomic) PTCritterNode *critterNode;

@end

@implementation PTCritterScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithWhite:0.95 alpha:1];
        
        PTCritterNode *critterNode = [PTCritterNode critterNodeWithVisualProperties:nil];
        [self addChild:critterNode];
        
        self.critterNode = critterNode;

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [self.delegate critterSceneRegisteredCameraClick:self];
    
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
     */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)runEntranceSequence {
    [self.critterNode removeAllActions];
    
    CGPoint start = CGPointMake(CGRectGetMidX(self.frame), -100);
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    self.critterNode.position = start;

    SKAction *moveToCenter = [SKAction moveTo:center duration:1];
    moveToCenter.timingMode = SKActionTimingEaseOut;
    
    SKAction *critterEntrance = [SKAction sequence:@[moveToCenter]];
    [self.critterNode runAction:critterEntrance];
}

@end
