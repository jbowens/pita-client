//
//  PTBackgroundView.m
//  PitaBread
//
//  Created by Jacob Stern on 1/25/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import "PTBackgroundView.h"

typedef struct _PTBackgroundCircle {
    CGFloat x, y, size;
    CGFloat velocity;
    CGFloat r, g, b, a;
} PTBackgroundCircle;

static const int kCirclesCount = 30;

PTBackgroundCircle GenerateCircle(CGFloat xMin, CGFloat xMax, CGFloat y)
{
    float velocity = (rand() / (float)RAND_MAX) * 0.5 + 0.1;
    float size = (rand() / (float)RAND_MAX) * 5.0 + 15.0;
    float green = ((rand() % 2) * 0.05) + 0.92;
    PTBackgroundCircle circle = {
        .x = xMin + ((xMax + 60.0 - xMin) * (rand() / (float)RAND_MAX)),
        .y = y, .size = size, .velocity = velocity,
        .r = 0.94, .g = green, .b = 1.00, .a = 0.99
    };
    
    return circle;
}

@implementation PTBackgroundView

- (void)awakeFromNib
{
    [self initializeCircles];
}

- (void)initializeCircles
{
    self.circles = [[NSMutableArray alloc] init];
    for (int i = 0; i < kCirclesCount; i++) {
        PTBackgroundCircle circle = GenerateCircle(0, self.bounds.size.width, self.bounds.size.height * (float)(i + 1) / kCirclesCount);
        id value = [NSValue valueWithBytes:&circle objCType:@encode(PTBackgroundCircle)];
        [self.circles addObject:value];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    CGContextSaveGState(ctx);
    
    // CGContextSetLineWidth(ctx,5);
    for (int i = 0; i < self.circles.count; i++) {
        NSValue *value = [self.circles objectAtIndex:i];
        PTBackgroundCircle circle;
        [value getValue:&circle];
        if (circle.y + circle.size >= 0) {
            CGContextSetRGBFillColor(ctx, circle.r, circle.g, circle.b, circle.a);
            CGContextAddArc(ctx, circle.x, circle.y, circle.size, 0.0, M_PI*2, YES);
            CGContextFillPath(ctx);
        }
    }

}

- (void)nextFrame
{
   for (int i = 0; i < self.circles.count; i++) {
       NSValue *value = [self.circles objectAtIndex:i];
       PTBackgroundCircle circle;
       [value getValue:&circle];
       if (circle.y - circle.size > self.bounds.size.height) {
           circle = GenerateCircle(0.0, self.bounds.size.width, -30.0);
       }
       circle.y = circle.y + circle.velocity;
       value = [NSValue valueWithBytes:&circle objCType:@encode(PTBackgroundCircle)];
       self.circles[i] = value;
   }
}

@end
