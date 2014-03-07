//
//  PTGameScene.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PTCritter.h"

@interface PTGameScene : SKScene

@property (nonatomic) PTCritter *critter;

- (void)runEntranceSequence;

@end