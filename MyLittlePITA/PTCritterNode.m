//
//  PTCritterNode.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/14/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritterNode.h"

static const int kSpriteSheetAnimationFrames = 20;
static const int kSpriteSheetFramesX = 6;
static const int kSpriteSheetFramesY = 4;
static const int kSpriteSheetFrameSize = 220;

@interface PTCritterNode()

@property (nonatomic) NSDictionary *textures;
@property (nonatomic) SKSpriteNode *bodySprite;

- (void)generateTexturesFromVisualProperties:(NSDictionary *)properties;
+ (NSArray *)texturesFromSpriteSheetImageNamed:(NSString *)name;
+ (NSArray *)spriteComponentKeys;

@end

@implementation PTCritterNode

- (instancetype)initWithVisualProperties:(NSDictionary *)properties
{
    self = [super init];

    if (self) {
        [self generateTexturesFromVisualProperties:properties];
        
        for (NSString *key in [PTCritterNode spriteComponentKeys]) {
            SKTexture *componentTexture = [[self.textures objectForKey:key] objectAtIndex:0];
            SKSpriteNode *component = [SKSpriteNode spriteNodeWithTexture:componentTexture];
            [self addChild:component];
        }

        /*
        SKSpriteNode *bodySprite = [SKSpriteNode node];
        
        SKAction *idle = [SKAction animateWithTextures:[self.textures objectForKey:@"body"] timePerFrame:0.042];
        bodySprite.size = CGSizeMake(kSpriteSheetFrameSize, kSpriteSheetFrameSize);
        [bodySprite runAction:[SKAction repeatActionForever:idle]];
         */
    }
    
    return self;
}


+ (instancetype)critterNodeWithVisualProperties:(NSDictionary *)properties
{
    return [[PTCritterNode alloc] initWithVisualProperties:properties];
}

- (void)generateTexturesFromVisualProperties:(NSDictionary *)properties
{
    NSMutableDictionary *textures = [NSMutableDictionary dictionary];
    
    for (NSString *key in [PTCritterNode spriteComponentKeys]) {
        [textures setObject:[PTCritterNode texturesFromSpriteSheetImageNamed:key] forKey:key];
    }
    
    self.textures = textures;
}

+ (NSArray *)texturesFromSpriteSheetImageNamed:(NSString *)name
{
    NSMutableArray *animationTextures = [NSMutableArray array];

    SKTexture *spriteSheetTexture = [SKTexture textureWithImageNamed:name];
    NSAssert(spriteSheetTexture != nil, @"Failed to load sprite sheet texture.");
    
    int framesAdded = 0;
    for (int j = 0; j < kSpriteSheetFramesY; j++) {
        for (int i = 0; i < kSpriteSheetFramesX; i++) {
            CGRect rect = CGRectMake(i / (1.f * kSpriteSheetFramesX),
                                     j / (1.f * kSpriteSheetFramesY),
                                     1.f / kSpriteSheetFramesX,
                                     1.f / kSpriteSheetFramesY);
            SKTexture *texture = [SKTexture textureWithRect:rect inTexture:spriteSheetTexture];
            
            [animationTextures addObject:texture];
            
            ++framesAdded;
            if (framesAdded >= kSpriteSheetAnimationFrames)
                break;
        }
    }
    
    return animationTextures;
}

+ (NSArray *)spriteComponentKeys
{
    return @[@"tail", @"legs", @"body", @"face"];
}

@end
