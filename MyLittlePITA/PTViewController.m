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

@interface PTViewController()

@property (nonatomic) PTGameScene *critterScene;
@property (strong, nonatomic) CameraInteraction* cameraInteraction;

@end

@implementation PTViewController

PTServer *server;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraInteraction = [[CameraInteraction alloc] init];
    
    server = [[PTServer alloc] init];
    [server newAccount: @"Jackson" phone:@"4402892895" email:@"jackson_owens@brown.edu" completionHandler:^(NSDictionary *results, NSError *err) {
        // TODO: Hook this up to an actual UI for the user to enter details with.
    }];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    self.userCritter = [[PTCritter alloc] initWithProperties:@{kPTBodyHueKey: @2.f, kPTSpotsPresentKey: @YES, kPTSpotsHueKey: @0.2f}];

    PTGameScene *critterScene = [PTGameScene sceneWithSize:skView.bounds.size];
    critterScene.scaleMode = SKSceneScaleModeAspectFill;
    critterScene.critter = self.userCritter;
    [critterScene runEntranceSequence];
    
    self.critterScene = critterScene;
    
    // Present the scene.
    [skView presentScene:self.critterScene];
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

- (void)presentTheCameraButton
{
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.userCritter.happiness < 100) {
        self.userCritter.happiness = 0;
    } else {
        self.userCritter.happiness -= 100;
    }
}

@end
