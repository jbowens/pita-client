//
//  SpongeInteraction.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/10/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpongeInteraction : NSObject

- (UIImageView*)putSpongeInView:(UIView*)theView;
- (void)changeInSpongeLocationInX:(NSInteger)x inY:(NSInteger)y inView:(UIView*)theView;
- (void)returnToOriginalLocationInView:(UIView*)theView;

@end
