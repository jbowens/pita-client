//
//  PTError.m
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTError.h"

NSString * const PTErrorDomainConst = @"com.mylittlepita.app.PTErrorDomain";

@implementation PTError

+ (NSString *)domain
{
    return PTErrorDomainConst;
}

+ (NSError *)alreadyAuthenticated
{
    return [self errorWithErrorCode:PTErrorCode_AlreadyAuthenticated];
}

+ (NSError *)internetUnavailable
{
    return [self errorWithErrorCode:PTErrorCode_internetUnavailable];
}

@end
