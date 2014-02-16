//
//  PTGameViewController.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTGameViewController.h"

@interface PTGameViewController()

@property (nonatomic) PTAttractScene *attractScene;
@property (nonatomic) PTCritterScene *critterScene;

@end

@implementation PTGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    PTAttractScene *attractScene = [PTAttractScene sceneWithSize:skView.bounds.size];
    attractScene.scaleMode = SKSceneScaleModeAspectFill;
    attractScene.delegate = self;
    self.attractScene = attractScene;
    
    PTCritterScene *critterScene = [PTCritterScene sceneWithSize:skView.bounds.size];
    critterScene.scaleMode = SKSceneScaleModeAspectFill;
    critterScene.delegate = self;
    self.critterScene = critterScene;
    
    // Present the scene.
    [skView presentScene:self.attractScene];
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

- (void)attractSceneRegisteredScreenTap:(PTAttractScene *)scene;
{
    SKView * skView = (SKView *)self.view;
    
    SKTransition *doorsOpen = [SKTransition doorsOpenHorizontalWithDuration:1];
    [skView presentScene:self.critterScene transition:doorsOpen];
}

- (void)critterSceneRegisteredCameraClick:(PTCritterScene*)critterScene;
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"Failed to find camera device.");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // TODO: Use results of photo
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
