//
//  PTHotPocketDetector.m
//  PitaBread
//
//  Created by Jackson Owens on 1/24/14.
//  Copyright (c) 2014 Team Name Optional. All rights reserved.
//

#import "PTHotPocketDetector.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <dirent.h>
// #include <ios>
// #include <stdexcept>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/ml/ml.hpp>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <ios>
#include <stdexcept>


using namespace std;
using namespace cv;

static string dataFile = "hotpocket_svm.csv";

static const cv::Size trainImgSize = cv::Size(200, 56);
static const cv::Size blockSize = cv::Size(16, 16);
static const cv::Size blockStride = cv::Size(8, 8);
static const cv::Size cellSize = cv::Size(8, 8);
static const cv::Size winStride = cv::Size(16,16);
static const int nbins = 9;

vector<float> svmB;
vector<float> svmG;
vector<float> svmR;

HOGDescriptor hogB;
HOGDescriptor hogG;
HOGDescriptor hogR;

@implementation PTHotPocketDetector

- (id)init
{
    self = [super init];
    if (self) {
        NSBundle    * AppBundle =    [NSBundle mainBundle];
        NSString    * Path =    [AppBundle pathForResource: @ "hotpocket_svm" ofType: @ "csv"];
        std::string *str = new std::string([Path UTF8String]);
        [self readSVMData: *str];
        [self setupHOG];
        
//        NSString    * testImPath =    [AppBundle pathForResource: @ "test" ofType: @ "jpg"];
//        UIImage    * testIm =    [[UIImage alloc] initWithContentsOfFile: testImPath];
//        bool isHotPocket = [self isHotPocket:testIm];
//        NSLog(@"is hot pocket?: %d\n", isHotPocket);
//        
//        testImPath =    [AppBundle pathForResource: @ "test_false" ofType: @ "jpg"];
//        testIm =    [[UIImage alloc] initWithContentsOfFile: testImPath];
//        isHotPocket = [self isHotPocket:testIm];
//        NSLog(@"is hot pocket?: %d\n", isHotPocket);
    }
    return self;
}

- (void) setupHOG {
    hogB.winSize = trainImgSize;
    hogB.blockSize = blockSize; //TODO : CHANGE THESE VALUES TO THOSE DESCRIBED BELOW
    hogB.blockStride = blockStride;
    hogB.cellSize = cellSize;
    hogB.nbins = nbins;
    
    hogG.winSize = trainImgSize;
    hogG.blockSize = blockSize; //TODO : CHANGE THESE VALUES TO THOSE DESCRIBED BELOW
    hogG.blockStride = blockStride;
    hogG.cellSize = cellSize;
    hogG.nbins = nbins;
    
    hogR.winSize = trainImgSize;
    hogR.blockSize = blockSize; //TODO : CHANGE THESE VALUES TO THOSE DESCRIBED BELOW
    hogR.blockStride = blockStride;
    hogR.cellSize = cellSize;
    hogR.nbins = nbins;
    
    NSLog(@"setting up hog svm detector");
    hogB.setSVMDetector(svmB);
    hogG.setSVMDetector(svmG);
    hogR.setSVMDetector(svmR);
    
    NSLog(@"setup done");
    
}

- (void) readSVMData:(std::string) fileName {

    ifstream infile( fileName );
    
    while (infile)
    {
        string s;
        if (!getline( infile, s )) break;
        
        istringstream ss( s );
        vector <float> record;
        
        while (ss)
        {
            string s;
            if (!getline( ss, s, ',' )) break;
            record.push_back( stof(s) );
        }
        
        if (!svmB.size()) {
            svmB = record;
        } else if (!svmG.size()) {
            svmG = record;
        } else {
            svmR = record;
        }
        record.clear();
        vector<float>().swap(record);
    }
    
}

- (bool)isHotPocket:(UIImage*)im {
    cv::Mat imData = [self cvMatFromUIImage:im];
    
    Mat imDataResized;
    resize(imData, imDataResized, cv::Size(600,600), 0, 0, INTER_CUBIC);
    
    bool foundB = [self findHotPocketInstances:hogB imData:imDataResized];
    bool foundG = [self findHotPocketInstances:hogG imData:imDataResized];
    bool foundR = [self findHotPocketInstances:hogR imData:imDataResized];
    
    imData.release();
    
    return (foundB && foundG && foundR);
}

- (bool)findHotPocketInstances:(const HOGDescriptor&) hog imData:(Mat&) imageData {
    vector<cv::Rect> found;
    int groupThreshold = 5;
    cv::Size padding(cv::Size(0, 0));
    double hitThreshold = 1; // tolerance
    hog.detectMultiScale(imageData, found, hitThreshold, winStride, padding, 1.05, groupThreshold);
    if (found.size() > 0) {
        found.clear();
        vector<cv::Rect>().swap(found);
        NSLog(@"hot pockets!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return true;
    } else {
        found.clear();
        vector<cv::Rect>().swap(found);
        NSLog(@"no pockets :(");
        return false;
    }
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
        
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    cv::Mat bgrMat(rows, cols, CV_8UC3);
    
    cv::cvtColor(cvMat , bgrMat , CV_RGBA2RGB);
    
    cvMat.release();
    
    return bgrMat;
}

@end
