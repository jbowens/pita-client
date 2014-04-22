//
//  PTColorHistogram.h
//  PitaBread
//
//  Created by Flora on 1/24/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface PTColorHistogram : NSObject

- (id)init:(UIImage *)im;
- (void)delete;

@property(nonatomic, assign) unsigned char *data;
@property float *histogram;
@property int height;
@property int width;
@property BOOL doneMaking;

@end
