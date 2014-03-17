//
//  PTSocialListPitaObject.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTSocialListPitaObject.h"

@implementation PTSocialListPitaObject

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithTheName:(NSString*)name theImage:(UIImage*)theImage theMood:(NSInteger)moodEnum
{
    if (self = [super init])
    {
        _name = name;
        _theImage = theImage;
        _moodEnum = moodEnum;
    }
    return self;
}

@end
