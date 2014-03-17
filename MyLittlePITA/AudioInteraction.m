//
//  AudioInteraction.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "AudioInteraction.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioUnit/AudioUnit.h>

@interface AudioInteraction() <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioRecorder* recorder;
@property (strong, nonatomic) UIImageView* circleImage;

@property (strong, nonatomic) NSTimer* timerUpdate;
@property (atomic) NSInteger counterForAngryScreaming;

@end

@implementation AudioInteraction

- (id)init
{
    self = [super init];
    if (self) {
        self.circleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.circleImage.image = [UIImage imageNamed:@"microphone.png"];
        self.counterForAngryScreaming = 0;
    }
    return self;
}

- (void)prepareTheAudio
{
    [self checkMicrophonePermission];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMin],         AVEncoderAudioQualityKey,
                              nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSError *error;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:settings error:&error];
    self.recorder.delegate = self;
    
    if (self.recorder) {
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
        [self.recorder record];
        
        
    } else{
        NSLog([error description]);
    }
}

- (UIImageView*)putAudioButtonInView:(UIView*)theView
{
    [self prepareTheAudio];
    self.circleImage.translatesAutoresizingMaskIntoConstraints = NO;
    [theView addSubview:(self.circleImage)];
    
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleImage
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.15
                                                         constant:0]];
    
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleImage
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.15
                                                         constant:0]];
    
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:self.circleImage
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.00
                                                         constant:theView.frame.size.width/15 * 2 + theView.frame.size.width * 0.15]];
    
    [theView addConstraint: [NSLayoutConstraint constraintWithItem:self.circleImage
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:theView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.00
                                                          constant:-theView.frame.size.width/15]];
    
    return self.circleImage;
}

-(void)startRecording
{
    NSLog(@"Record1");
    self.recorder.meteringEnabled = YES;
    [self.recorder record];
    
    self.timerUpdate = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(trackAudio) userInfo:nil repeats:YES];
    NSLog(@"Record2");
    self.circleImage.image =[UIImage imageNamed:@"microphoneRecording.png"];
}

- (void) trackAudio {
    [self.recorder updateMeters];
    float averageLevel = [self.recorder averagePowerForChannel:0];
    float peakLevel = [self.recorder peakPowerForChannel:0];
    
    if(averageLevel > -15 && averageLevel < -8 && peakLevel > -1.0)
    {
        self.counterForAngryScreaming ++;
    }
    else
    {
        if(self.counterForAngryScreaming < 3 && self.counterForAngryScreaming > 1)
        {
            NSLog(@"Average: %f", averageLevel);
            NSLog(@"Peak: %f", peakLevel);
            NSLog(@"ANGRY!!");
        }
        self.counterForAngryScreaming = 0;
    }
}

-(void)stopRecording
{
    NSLog(@"Testing");
    [self.timerUpdate invalidate];
    [self.recorder stop];
    [self.recorder prepareToRecord];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Done Playing");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Done Recording");

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    if (!self.recorder.recording){
        NSLog(@"Testing2");
        
        self.circleImage.image =[UIImage imageNamed:@"microphone.png"];
    }
    
}

- (void)checkMicrophonePermission
{
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                NSLog(@"User will not be able to use the microphone!");
            }
        }];
    }
}


@end
