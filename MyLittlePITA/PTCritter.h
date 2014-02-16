//
//  PTCritter.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PTCritterAppearanceNormal,
    PTCritterAppearanceAngry,
    PTCritterAppearanceTired,
    PTCritterAppearanceHappy
} PTCritterAppearance;

@interface PTCritter : NSObject

@property (nonatomic, readonly) PTCritterAppearance currentAppearance;

+ (instancetype)critterWithProperties:(NSDictionary *)properties;
- (instancetype)initWithProperties:(NSDictionary *)properties;

@end