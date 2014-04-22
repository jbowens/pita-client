//
//  PTBackgroundView.h
//  PitaBread
//
//  Created by Jacob Stern on 1/25/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTBackgroundView : UIView

@property NSMutableArray *circles;

- (void)drawRect:(CGRect)rect;
- (void)nextFrame;
- (void)initializeCircles;

@end
