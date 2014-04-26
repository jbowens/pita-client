//
//  PTCritter.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCritter : NSObject

@property (nonatomic) NSUInteger happiness;
@property (nonatomic) NSUInteger hunger;
@property (nonatomic) NSUInteger sleepiness;
@property (nonatomic) NSUInteger discipline;

@property (nonatomic, readonly) NSDictionary *visualProperties;

+ (instancetype)critterWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;
- (void)updatePitasStatistics;

@end