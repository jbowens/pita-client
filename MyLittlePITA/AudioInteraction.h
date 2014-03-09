//
//  AudioInteraction.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioInteraction : NSObject

- (UIImageView*)putAudioButtonInView:(UIView*)theView;
-(void)startRecording;
-(void)playRecording;

@end
