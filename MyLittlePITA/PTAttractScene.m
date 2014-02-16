//
//  PTAttractScene.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/15/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTAttractScene.h"

@interface PTAttractScene ()

@property (nonatomic) SKSpriteNode *logoSprite;

@end

@implementation PTAttractScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.92 blue:0.95 alpha:1.0];
        
        SKSpriteNode *logoSprite = [SKSpriteNode spriteNodeWithImageNamed:@"logo_cropped"];
        logoSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) * .7);
        [self addChild:logoSprite];
        
        self.logoSprite = logoSprite;

    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate attractSceneRegisteredScreenTap:self];
}

- (void)fadeOutContentWithDuration:(NSTimeInterval)sec completion:(void (^)(void))block {
    SKAction *fadeOut = [SKAction fadeOutWithDuration:sec];
    [self.logoSprite runAction:fadeOut completion:block];
}

@end
