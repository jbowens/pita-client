//
//  PTViewController.h
//  MyLittlePITA
//

//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "PTCritter.h"
#import "PTScrubViewController.h"
#import "PTGameScene.h"

@interface PTViewController : UIViewController
    <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property PTCritter *userCritter;
@property PTScrubViewController *scrubViewController;

@end