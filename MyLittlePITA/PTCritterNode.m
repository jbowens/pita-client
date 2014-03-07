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

static const NSString *kSpriteAnimationIdleKey = @"idle";

@interface PTCritterNode()

@property (nonatomic) NSDictionary *textures;
@property (nonatomic) NSDictionary *components;

+ (NSArray *)spriteComponentKeys;

- (void)generateTexturesFromVisualProperties:(NSDictionary *)properties;
+ (NSDictionary *)texturesFromAtlasNamed:(NSString *)name;

@end

@implementation PTCritterNode

+ (NSArray *)spriteComponentKeys
{
    return @[@"tail", @"legs", @"body", @"face"];
}

- (instancetype)initWithVisualProperties:(NSDictionary *)properties
{
    self = [super init];

    if (self) {
        
        [self generateTexturesFromVisualProperties:properties];
        
        SKSpriteNode *bodySprite = [SKSpriteNode spriteNodeWithTexture:[self.textures objectForKey:@"happy" ]];
        [self addChild:bodySprite];
        
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
    
    NSString* imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sprite_happy.png"];
    CIImage *image = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    if ([properties objectForKey:@"colorRotation"]) {
        NSNumber *colorRotation = [properties objectForKey:@"colorRotation"];
        CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:
                     kCIInputImageKey, image,
                     kCIInputAngleKey, colorRotation,
                     nil];
        image = [hueAdjust valueForKey: kCIOutputImageKey];
    }
    
    CGImageRef cgImage = [context createCGImage:image fromRect:[image extent]];
    
    [textures setObject:[SKTexture textureWithCGImage:cgImage] forKey:@"happy"];
    
    self.textures = textures;
}

+ (NSDictionary *)texturesFromAtlasNamed:(NSString *)name
{
    NSArray *spriteComponentKeys = [PTCritterNode spriteComponentKeys];
    
    NSMutableDictionary *textures = [NSMutableDictionary dictionaryWithCapacity:spriteComponentKeys.count];
    for (NSString *componentKey in spriteComponentKeys) {
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:kSpriteSheetAnimationFrames];
        for (int i = 0; i < kSpriteSheetAnimationFrames; i++) {
            int index = i + 1;
            NSString *textureName;
            if (index < 10) {
                textureName = [NSString stringWithFormat:@"%@_000%d", componentKey, index];
            } else if (index < 100) {
                textureName = [NSString stringWithFormat:@"%@_00%d", componentKey, index];
            }
            NSLog(@"%@", textureName);
            [frames addObject:[SKTexture textureWithImageNamed:textureName]];
        }
        [textures setObject:frames forKey:componentKey];
    }
    
    return textures;
}

@end
