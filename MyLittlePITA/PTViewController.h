//
//  PTViewController.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "PTCritter.h"
#import "PTGameScene.h"
#import "PTLocationDetector.h"

@interface PTViewController : UIViewController
    <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property PTLocationDetector *locationDetector;
@property PTCritter *userCritter;

@end