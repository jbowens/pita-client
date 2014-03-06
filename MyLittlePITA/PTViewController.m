//
//  PTViewController.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 2/11/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTViewController.h"
#import "PTServer.h"

@interface PTViewController()

@property (nonatomic) PTGameScene *critterScene;

@end

@implementation PTViewController

PTServer *server;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    server = [[PTServer alloc] init];
    [server newAccount: @"Jackson" phone:@"4402892895" email:@"jackson_owens@brown.edu" error:nil];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    PTGameScene *critterScene = [PTGameScene sceneWithSize:skView.bounds.size];
    critterScene.scaleMode = SKSceneScaleModeAspectFill;    self.critterScene = critterScene;
    
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

- (void)critterSceneRegisteredCameraClick:(PTGameScene*)critterScene;
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
