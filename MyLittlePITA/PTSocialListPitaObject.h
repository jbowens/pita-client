//
//  PTSocialListPitaObject.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTSocialListPitaObject : NSObject

@property (readonly) NSString* name;
@property (readonly) UIImage* theImage;
@property (readonly) NSInteger moodEnum;

- (id)initWithTheName:(NSString*)name theImage:(UIImage*)theImage theMood:(NSInteger)moodEnum;

@end
