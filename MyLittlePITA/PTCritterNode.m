//
//  PTCritterNode.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/14/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritterNode.h"
#import "PTLog.h"

static const NSString *kSpriteTailComponentKey = @"tail";
static const NSString *kSpriteBodyComponentKey = @"body";

static const NSString *kSpriteIdleAnimationKey = @"neutral";
static const NSString *kSpriteHappyAnimationKey = @"happy";
static const NSString *kSpriteMadAnimationKey = @"mad";

@interface PTCritterNode() {
    NSArray *componentKeys;
    NSArray *animationKeys;
}

@property (nonatomic) NSDictionary *textures;
@property (nonatomic) NSDictionary *components;

- (void)generateTexturesFromVisualProperties:(NSDictionary *)properties;

@end

@implementation PTCritterNode

- (instancetype)initWithVisualProperties:(NSDictionary *)properties
{
    self = [super init];
    
    componentKeys = @[kSpriteTailComponentKey, kSpriteBodyComponentKey];
    animationKeys = @[kSpriteIdleAnimationKey, kSpriteHappyAnimationKey, kSpriteMadAnimationKey];

    if (self) {
        [self generateTexturesFromVisualProperties:properties];
        
        self.components = [NSMutableDictionary dictionary];
        
        SKSpriteNode *bodySprite = [SKSpriteNode node];
        bodySprite.size = CGSizeMake(250.f, 250.f);
        [self addChild:bodySprite];
        
        for (NSString *key in componentKeys) {
            SKSpriteNode *componentSprite = [SKSpriteNode node];
            componentSprite.size = CGSizeMake(250.f, 250.f);
            
            [self.components setValue:componentSprite forKey:key];
            [self addChild:componentSprite];
        }
    }
    
    return self;
}


+ (instancetype)critterNodeWithVisualProperties:(NSDictionary *)properties
{
    return [[PTCritterNode alloc] initWithVisualProperties:properties];
}

- (void)generateTexturesFromVisualProperties:(NSDictionary *)properties
{
    DDLogInfo(@"Loading textures...");
    
    NSMutableDictionary *textures = [NSMutableDictionary dictionary];
    
    for (NSString *componentKey in componentKeys) {
        NSMutableDictionary *componentTextures = [NSMutableDictionary dictionary];
        
        for (NSString *animationKey in animationKeys) {
            NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.png", animationKey, componentKey]];
            CIImage *image = [CIImage imageWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
            NSAssert(image != nil, @"image is nil!");
            CIContext *context = [CIContext contextWithOptions:nil];
            
            NSNumber *bodyHue = [properties objectForKey:kPTBodyHueKey];
            if (bodyHue) {
                CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:
                             kCIInputImageKey, image,
                             kCIInputAngleKey, bodyHue,
                             nil];
                image = [hueAdjust valueForKey:kCIOutputImageKey];
            }
            
            CGImageRef cgImage = [context createCGImage:image fromRect:[image extent]];
            NSAssert(cgImage != NULL, @"cgImage is null!");
            [componentTextures setObject:[SKTexture textureWithCGImage:cgImage] forKey:animationKey];
            CGImageRelease(cgImage);
        }
        
        [textures setObject:componentTextures forKey:componentKey];
    }
    
    self.textures = textures;
    
    DDLogInfo(@"Done.");
}

- (void)setStatus:(PTCritterStatus)status
{
    for (NSString *componentKey in componentKeys) {
        SKTexture *atlasTexture;
        NSDictionary *componentTextures = [self.textures objectForKey:componentKey];
    
        switch (status) {
            case PTCritterStatusSad:
                atlasTexture = [componentTextures objectForKey:kSpriteIdleAnimationKey];
                break;
            case PTCritterStatusHappy:
                atlasTexture = [componentTextures objectForKey:kSpriteHappyAnimationKey];
                break;
            case PTCritterStatusNormal:
                atlasTexture = [componentTextures objectForKey:kSpriteIdleAnimationKey];
                break;
            case PTCritterStatusMad:
                atlasTexture = [componentTextures objectForKey:kSpriteMadAnimationKey];
                break;
            default:
                atlasTexture = [componentTextures objectForKey:kSpriteIdleAnimationKey];
                break;
        }
        
        NSAssert(atlasTexture != nil, @"atlasTexture is nil!    ");
        
        NSMutableArray *animationTextures = [NSMutableArray array];
        
        int atlasWidth = 5, atlasHeight = 4;
        float frameWidth = 1.f / atlasWidth, frameHeight = 1.f / atlasHeight;
        for (int j = atlasHeight - 1; j >= 0; j--) {
            for (int i = 0; i < atlasWidth; i++) {
                CGRect rect = CGRectMake(i * frameWidth, j * frameHeight, frameWidth, frameHeight);
                [animationTextures addObject:[SKTexture textureWithRect:rect inTexture:atlasTexture]];
                
                NSAssert([animationTextures lastObject] != nil, @"textureWithRect returned nil!");
            }
        }
        
        SKAction *animation = [SKAction animateWithTextures:animationTextures timePerFrame:0.042];
        [[self.components objectForKey:componentKey] runAction:[SKAction repeatActionForever:animation]];
    }
}

@end
