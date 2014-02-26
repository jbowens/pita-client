//
//  PTErrorDomain.h
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTErrorDomain : NSObject

+ (NSString *)domain;
- (NSString *)domain;

+ (NSError *)errorWithErrorCode:(NSInteger)errorCode;
+ (NSError *)errorWithErrorCode:(NSInteger)errorCode userInfo:(NSDictionary *)userInfo;

@end
