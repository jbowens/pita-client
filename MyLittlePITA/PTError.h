//
//  PTError.h
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTErrorDomain.h"

@interface PTError : PTErrorDomain

+ (NSError *)alreadyAuthenticated;
+ (NSError *)internetUnavailable;

@end

extern NSString * const PTErrorDomainConst;

typedef enum PTErrorCode {
    PTErrorCode_Undefined = 0,
    PTErrorCode_AlreadyAuthenticated,
    PTErrorCode_internetUnavailable
} PTErrorCode;
