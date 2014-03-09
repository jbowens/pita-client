//
//  CameraInteraction.h
//  MyLittlePitaTests
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 Hakrim Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraInteraction : NSObject

- (UIImageView*)putCameraButtonInView:(UIView*)theView;
- (void)transitionToCameraView:(UIViewController*)theViewController;

@end
