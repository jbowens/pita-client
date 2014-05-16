//
//  PTViewController.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTCritter.h"
#import "PTCritterNode.h"
#import "PTViewController.h"
#import "PTServer.h"
#import "CameraInteraction.h"
#import "ProximitySensorInteraction.h"
#import "AudioInteraction.h"
#import "SocialInteractionButton.h"
#import "SpongeInteraction.h"
#import "AccelerometerInteraction.h"

@interface PTViewController()

@property (nonatomic) PTGameScene *critterScene;
@property (nonatomic) NSTimer *saveTimer;
@property (strong, nonatomic) CameraInteraction* cameraInteraction;
@property (strong, nonatomic) ProximitySensorInteraction* proximityInteraction;
@property (strong, nonatomic) AccelerometerInteraction* accelerometerInteraction;
@property (strong, nonatomic) AudioInteraction* audioInteraction;
@property (strong, nonatomic) SocialInteractionButton* socialInteractionButton;
@property (strong, nonatomic) SpongeInteraction* spongeInteractionSponge;

@end

@implementation PTViewController

PTServer *server;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveTimer = [NSTimer timerWithTimeInterval:30
                                             target:self
                                           selector:@selector(savePitaToServer)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.saveTimer forMode:NSDefaultRunLoopMode];
    
    server = [[PTServer alloc] init];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    PTGameScene *critterScene = [PTGameScene sceneWithSize:skView.bounds.size];
    critterScene.scaleMode = SKSceneScaleModeAspectFill;
    
    self.critterScene = critterScene;

    // Present the scene.
    [skView presentScene:self.critterScene];    
    [self prepareAllInteractionButtons];

    [server newAccount:nil  phone:nil email:nil completionHandler:^(NSDictionary *results, NSError *err) {
        if (err) {
            // TODO: Handle more gracefully.
            NSLog(@"Account creation resulted in error: %@", err);
        } else {
            // We now have a valid account to send authorized requests to the server.
            // It's now safe to start updating locations, retrieving Pitas, etc.
            [self serverAuthenticated];
        }
    }];
}

// Called as soon as we have valid account data through which we
// can make authorized server requests. This does a lot of setup
// that should wait until we have authorized access to the server.
- (void)serverAuthenticated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pitaDeath)
                                                 name:@"pitadeath" object:nil];
    
    // For the beta, create a random pita.
    [server createRandomPita:^(NSDictionary *results, NSError *err) {
        if ([results objectForKey:@"pita"]) {
            // We successfully made a new pita.
            PTCritter *pita = [results objectForKey:@"pita"];

            self.userCritter = pita;
            
            // For now, we're always going to skip the egg stage and
            // go straight to being alive.
            [server recordHatch:nil];

            self.critterScene.critter = self.userCritter;
            [self.critterScene runEntranceSequence];
        }
    }];

    // Begin monitoring the user location. The location detector must be initialized on
    // the main thread.
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.locationDetector = [[PTLocationDetector alloc] initWithServer:server];
    });
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)prepareAllInteractionButtons
{
    [self presentTheCameraButton];
    [self presentTheAudioButton];
    [self presentTheSocialButton];
    [self prepareTheProximityChange];
    [self prepareTheAccelerometer];
}

- (void)prepareTheProximityChange
{
    self.proximityInteraction = [[ProximitySensorInteraction alloc] init];
    [self.proximityInteraction handleProximitySensor];
}

- (void)prepareTheAccelerometer
{
    self.accelerometerInteraction = [[AccelerometerInteraction alloc] init];
    [self.accelerometerInteraction startCheckingAccelerometer];
}

- (void)presentTheCameraButton
{
    self.cameraInteraction = [[CameraInteraction alloc] init];
    
    UIImageView* cameraButton = [self.cameraInteraction putCameraButtonInView:self.view];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transitionToCameraView)];
    singleTap.numberOfTapsRequired = 1;
    cameraButton.userInteractionEnabled = YES;
    
    [cameraButton addGestureRecognizer:singleTap];
}

- (void)transitionToCameraView
{
    [self.cameraInteraction transitionToCameraView:self];
}

- (void)presentTheAudioButton
{
    self.audioInteraction = [[AudioInteraction alloc] init];
    
    UIImageView* audioButton = [self.audioInteraction putAudioButtonInView:self.view];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAudio:)];
    audioButton.userInteractionEnabled = YES;
    
    [audioButton addGestureRecognizer:panGesture];
}

- (void)handleAudio:(UIPanGestureRecognizer*)theGesture
{
    if([theGesture state] == UIGestureRecognizerStateBegan)
    {
        [self.audioInteraction startRecording];
        [self.userCritter startSpecialStatus:PTCritterStatusListening];
    }
    else if([theGesture state] == UIGestureRecognizerStateEnded)
    {
        [self.audioInteraction stopRecording];
        [self.userCritter startSpecialStatus:PTCritterStatusNormal];
    }
}

- (void)presentTheSocialButton
{
    self.socialInteractionButton = [[SocialInteractionButton alloc] initWithServer:server];
    
    UIImageView* socialButton = [self.socialInteractionButton putSocialButtonInView:self.view];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestSocialPage)];
    tapGesture.numberOfTapsRequired = 1;
    socialButton.userInteractionEnabled = YES;
    
    [socialButton addGestureRecognizer:tapGesture];
}

- (void)requestSocialPage
{
    [self.socialInteractionButton openupSocialPage:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.userCritter startSpecialStatus:PTCritterStatusTemporarilyHappy];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.userCritter modifyHappiness:3.0];
    //[self.userCritter startSpecialStatus:PTCritterStatusNormal];
}

- (void)pitaDeath
{
    [server recordDeath:nil];
}

- (void)savePitaToServer
{
    if (self.userCritter) {
        [server savePitaStatus:self.userCritter.happiness
                        hunger:self.userCritter.hunger
                    sleepiness:self.userCritter.sleepiness];
    }
}

@end
