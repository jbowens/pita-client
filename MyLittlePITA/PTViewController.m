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

@interface PTViewController()

@property (nonatomic) PTGameScene *critterScene;
@property (strong, nonatomic) CameraInteraction* cameraInteraction;
@property (strong, nonatomic) ProximitySensorInteraction* proximityInteraction;
@property (strong, nonatomic) AudioInteraction* audioInteraction;
@property (strong, nonatomic) SocialInteractionButton* socialInteractionButton;
@property (strong, nonatomic) SpongeInteraction* spongeInteractionSponge;

@end

@implementation PTViewController

PTServer *server;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    server = [[PTServer alloc] init];
    [server newAccount:nil  phone:nil email:nil completionHandler:^(NSDictionary *results, NSError *err) {
        [server createRandomPita:^(NSDictionary *results, NSError *err) {
            if ([results objectForKey:@"pita"]) {
                // We successfully made a new pita.
                PTCritter *pita = [results objectForKey:@"pita"];
                // Configure the view.
                SKView * skView = (SKView *)self.view;
                
                //self.userCritter = [[PTCritter alloc] initWithProperties:@{kPTBodyHueKey: @2.f, kPTSpotsPresentKey: @YES, kPTSpotsHueKey: @0.2f}];
                self.userCritter = pita;
                
                PTGameScene *critterScene = [PTGameScene sceneWithSize:skView.bounds.size];
                critterScene.scaleMode = SKSceneScaleModeAspectFill;
                critterScene.critter = self.userCritter;
                [critterScene runEntranceSequence];
                
                self.critterScene = critterScene;
                
                // Present the scene.
                [skView presentScene:self.critterScene];
            }
        }];
    }];

    [self prepareAllInteractionButtons];
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
    [self presentCleaningSponge];
    [self prepareTheProximityChange];
}

- (void)prepareTheProximityChange
{
    self.proximityInteraction = [[ProximitySensorInteraction alloc] init];
    [self.proximityInteraction handleProximitySensor];
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
    }
    else if([theGesture state] == UIGestureRecognizerStateEnded)
    {
        [self.audioInteraction playRecording];
    }
}

- (void)presentTheSocialButton
{
    self.socialInteractionButton = [[SocialInteractionButton alloc] init];
    
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

- (void)presentCleaningSponge
{
    self.spongeInteractionSponge = [[SpongeInteraction alloc] init];
    
    UIImageView* spongeDrawing = [self.spongeInteractionSponge putSpongeInView:self.view];
    
    UIPanGestureRecognizer *movingSpongeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(spongeMoved:)];
    spongeDrawing.userInteractionEnabled = YES;
    
    [spongeDrawing addGestureRecognizer:movingSpongeGesture];
}

- (void)spongeMoved:(UIPanGestureRecognizer*)panGesture
{
    CGPoint translation = [panGesture translationInView:self.view];
    if([panGesture state] == UIGestureRecognizerStateBegan)
    {
    }
    else if([panGesture state] == UIGestureRecognizerStateChanged)
    {
        [self.spongeInteractionSponge changeInSpongeLocationInX:translation.x inY:translation.y inView:self.view];
    }
    else if([panGesture state] == UIGestureRecognizerStateEnded)
    {
        [self.spongeInteractionSponge returnToOriginalLocationInView:self.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.userCritter.happiness < 100) {
        self.userCritter.happiness = 0;
    } else {
        self.userCritter.happiness -= 100;
    }
}

@end
