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
// #include <opencv2/highgui/highgui.hpp>
// #include <opencv2/ml/ml.hpp>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

using namespace std;
// using namespace cv;

@implementation PTHotPocketDetector

- (id)init:(std::string) dataFile
{
    self = [super init];
    if (self) {
        [self readSVMData:dataFile];
    }
    return self;
}

- (void) readSVMData:(std::string) fileName {
    vector<float> svmB;
    vector<float> svmG;
    vector<float> svmR;
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
        
        NSLog(@"svmB size: %lu\n", svmB.size());
        NSLog(@"svmG size: %lu\n", svmG.size());
        NSLog(@"svmR size: %lu\n", svmR.size());
        
//        data.push_back( record );
    }
}

- (bool)isHotPocket:(UIImage*)im {
    float total_red = 0;

    NSLog(@"red percent: %f\n", total_red);
    if (total_red > .25) {
        return true;
    }
    return false;
}

@end
