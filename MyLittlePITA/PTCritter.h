//
//  PTCritter.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTCritter : NSObject

@property (nonatomic) NSString  *name;
@property (nonatomic) NSInteger happiness;
@property (nonatomic) NSInteger hunger;
@property (nonatomic) NSInteger sleepiness;
@property (nonatomic) NSInteger discipline;

@property (nonatomic, readonly) NSDictionary *visualProperties;

+ (instancetype)critterWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;
- (void)updatePitasStatistics;

@end