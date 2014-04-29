//
//  SocialInteractionButton.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTServer.h"

@interface SocialInteractionButton : NSObject

@property PTServer *server;

- (id)initWithServer:(PTServer *)server;
- (UIImageView*)putSocialButtonInView:(UIView*)theView;
- (void)openupSocialPage:(UIViewController*)viewController;

@end
