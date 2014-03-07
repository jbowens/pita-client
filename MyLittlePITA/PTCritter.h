//
//  PTCritter.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCritter : NSObject

@property (atomic) NSNumber *happiness;
@property (nonatomic, readonly) NSDictionary *visualProperties;

+ (instancetype)critterWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;

@end