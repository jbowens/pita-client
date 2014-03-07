//
//  PTGameScene.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PTGameScene;

@interface PTGameScene : SKScene

- (instancetype)initWithSize:(CGSize)size critterProperties:(NSDictionary *)properties;
+ (instancetype)sceneWithSize:(CGSize)size critterProperties:(NSDictionary *)properties;

- (void)runEntranceSequence;

@end