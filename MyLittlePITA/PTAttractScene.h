//
//  PTAttractScene.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/15/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PTAttractScene;

@protocol PTAttractSceneDelegate <NSObject>

- (void)attractSceneRegisteredScreenTap:(PTAttractScene *)scene;

@end

@interface PTAttractScene : SKScene

@property (nonatomic) id<PTAttractSceneDelegate> delegate;

@end