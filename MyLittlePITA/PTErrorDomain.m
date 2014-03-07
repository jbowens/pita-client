//
//  PTErrorDomain.m
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTErrorDomain.h"

@implementation PTErrorDomain

+ (NSString *)domain
{
    // lol i didn't know what was going on so i did this lol
    return @"com.mylittlepita.app.PTErrorDomain";
}

- (NSString *)domain
{
    return [[self class] domain];
}

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode
{
    return [NSError errorWithDomain:[PTErrorDomain domain]
                               code:errorCode
                           userInfo:nil];
}

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:[PTErrorDomain domain]
                               code:errorCode
                           userInfo:userInfo];
}

@end
