//
//  PTColorHistogram.m
//  PitaBread
//
//  Created by Flora on 1/24/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import "PTColorHistogram.h"

@implementation PTColorHistogram

- (id)init:(UIImage *)im
{
    self = [super init];
    self.doneMaking = FALSE;
    [self extractPixelData:im];
    [self makeHistogram];
    while(!self.doneMaking){
        sleep(2);
    }
    [self normalizeHistogram];
    return self;
}

- (void)delete {
    free(self.data);
    free(self.histogram);
}

- (unsigned char *)extractPixelData:(UIImage *)im
{
    // First get the image into your data buffer
    CGImageRef image = [im CGImage];
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    self.data = rawData;
    self.height = height;
    self.width = width;
    return rawData;
}

- (void)makeHistogram
{
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_group_t group = dispatch_group_create();
    
    float *histogram = malloc(64 * sizeof(float));
    memset(histogram, 0, 64*sizeof(float));
    for (int i=0; i<self.height; i++) {
        dispatch_group_async(group,queue, ^{
            for (int j=0; j<self.width/2; j++) {
                    int byteIndex = (self.width * i * 4) + j * 4;
                    int red = self.data[byteIndex];
                    int green = self.data[byteIndex + 1];
                    int blue = self.data[byteIndex + 2];
                    int redBucket = red / 256.0 * 4.0;
                    int greenBucket = green / 256.0 * 4.0;
                    int blueBucket = blue / 256.0 * 4.0;
                    int bucketIndex = redBucket*16 + greenBucket*4 + blueBucket;
                    histogram[bucketIndex]++;
            }
        });
        
        dispatch_group_async(group,queue, ^{
            for (int j=self.width/2; j<self.width; j++) {
                int byteIndex = (self.width * i * 4) + j * 4;
                int red = self.data[byteIndex];
                int green = self.data[byteIndex + 1];
                int blue = self.data[byteIndex + 2];
                int redBucket = red / 256.0 * 4.0;
                int greenBucket = green / 256.0 * 4.0;
                int blueBucket = blue / 256.0 * 4.0;
                int bucketIndex = redBucket*16 + greenBucket*4 + blueBucket;
                histogram[bucketIndex]++;
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        self.histogram = histogram;
        self.doneMaking = TRUE;
    });
}

- (void)normalizeHistogram
{
    for (int i=0; i<64; i++) {
        self.histogram[i] = self.histogram[i]/(self.height*self.width);
    }
}

@end
