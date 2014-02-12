//
//  PTGameViewController.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "PTCritterScene.h"

@interface PTGameViewController : UIViewController
    <PTCritterSceneDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
