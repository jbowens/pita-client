//
//  PTCritterScene.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PTCritterScene;

@protocol PTCritterSceneDelegate <NSObject>

- (void)critterSceneRegisteredCameraClick:(PTCritterScene*)critterScene;

@end

@interface PTCritterScene : SKScene

@property (nonatomic) id<PTCritterSceneDelegate> delegate;

- (void)runEntranceSequence;

@end