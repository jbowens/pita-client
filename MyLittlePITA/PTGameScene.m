//
//  PTGameScene.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritterNode.h"
#import "PTGameScene.h"

static const float kDefaultVerticalPosition = .4;

@interface PTGameScene ()

@property (nonatomic) SKSpriteNode *backgroundSprite;
@property (nonatomic) PTCritterNode *critterNode;

@end

@implementation PTGameScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithWhite:0.95 alpha:1];
        self.backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"opening.png"];
        self.backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.backgroundSprite];
        
        _critter = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaHappy)
                                                     name:@"PitaHappy" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaVeryHappy)
                                                     name:@"PitaVeryHappy" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaMad)
                                                     name:@"PitaMad" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaVeryMad)
                                                     name:@"PitaVeryMad" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaSad)
                                                     name:@"PitaSad" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaSleepy)
                                                     name:@"PitaSleepy" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaAsleep)
                                                     name:@"PitaAsleep" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaNeutral)
                                                     name:@"PitaNeutral" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaDead)
                                                     name:@"PitaDead" object:nil];
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
    CGPoint src = CGPointMake(dest.x, dest.y * 0.1);
    
    self.critterNode.position = src;
    SKAction *moveToCenter = [SKAction moveTo:dest duration:.6];
    moveToCenter.timingMode = SKActionTimingEaseOut;
    
    SKAction *critterEntrance = [SKAction sequence:@[moveToCenter]];
    [self.critterNode runAction:critterEntrance];
}

- (void)pitaNeutral{
    self.critterNode.status = PTCritterStatusNormal;
}

- (void)pitaHappy{
    self.critterNode.status = PTCritterStatusHappy;
}

- (void)pitaVeryHappy{
    self.critterNode.status = PTCritterStatusVeryHappy;
}

- (void)pitaMad{
    self.critterNode.status = PTCritterStatusMad;
}

- (void)pitaVeryMad{
    self.critterNode.status = PTCritterStatusVeryMad;
}

- (void)pitaSad{
    self.critterNode.status = PTCritterStatusSad;
}

- (void)pitaSleepy{
    self.critterNode.status = PTCritterStatusSleepy;
}

- (void)pitaAsleep{
    self.critterNode.status = PTCritterStatusSleeping;
}

- (void)pitaDead{
    self.critterNode.status = PTCritterStatusDying;
}

- (void)setCritter:(PTCritter *)critter {
    PTCritterNode *critterNode = [PTCritterNode critterNodeWithVisualProperties:critter.visualProperties];
    critterNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * kDefaultVerticalPosition);
    critterNode.status = PTCritterStatusNormal;
    
    self.critterNode = critterNode;
    _critter = critter;
    
    [self.backgroundSprite runAction:[SKAction fadeAlphaTo:0.0 duration:1.0] completion:^{
        
        self.backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        self.backgroundSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.backgroundSprite];
        
        [self addChild:critterNode];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaTexturesLoaded" object:nil];
}

@end
