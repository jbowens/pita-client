//
//  CameraInteraction.m
//  MyLittlePitaTests
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 Hakrim Kim. All rights reserved.
//

#import "CameraInteraction.h"
#import "PTHotPocketDetector.h"

@interface CameraInteraction ()<UIImagePickerControllerDelegate>

@property UIImagePickerController* picker;
@property UIImageView* circleImage;
@property UILabel* cancelLabel;
@property PTHotPocketDetector* hotpocketDetector;

@end

@implementation CameraInteraction


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.picker = [[UIImagePickerController alloc] init];
        
        self.circleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.circleImage.image = [UIImage imageNamed:@"camera.png"];
        
        self.cancelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.cancelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.cancelLabel.userInteractionEnabled = YES;
        
        self.hotpocketDetector = [[PTHotPocketDetector alloc] init];
    }
    return self;
}

- (UIImageView*)putCameraButtonInView:(UIView*)theView
{
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
                                                              constant:theView.frame.size.width/15]];
    
    [theView addConstraint: [NSLayoutConstraint constraintWithItem:self.circleImage
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:theView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.00
                                                               constant:-theView.frame.size.width/15]];
    
    [self prepareThePicker];
    
    NSInteger radius = 60;
    NSInteger lCurrentWidth = theView.frame.size.width;
    NSInteger lCurrentHeight = theView.frame.size.height;
    [self drawCaptureCircle:lCurrentWidth/2 - radius/2 :lCurrentHeight -  radius - 20 :radius :[self.picker view]];
    [self drawTheCancelLabelToView:[self.picker view]];
    
    return self.circleImage;
}

- (void)prepareThePicker
{
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //Create camera overlay
        CGRect f = self.picker.view.bounds;
        f.size.height -= self.picker.navigationBar.bounds.size.height;
        CGFloat barHeight = (f.size.height - f.size.width) / 2;
        UIGraphicsBeginImageContext(f.size);
        
        UILabel *label1 =  [[UILabel alloc] initWithFrame: CGRectMake(80, 30, f.size.width-40, 50)];
        label1.text = @"FEED ME!";
        label1.textColor = [UIColor whiteColor];
        [label1 setFont:[UIFont systemFontOfSize:34]];
        [self.picker.view addSubview:label1];
        
        [[UIColor blackColor] set];
        UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
        UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight), kCGBlendModeNormal);
        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        UILabel *label2 =  [[UILabel alloc] initWithFrame: CGRectMake(50, f.size.height - barHeight + 10, f.size.width-40,  50)];
        label2.text = @"HOT POCKETS!";
        label2.textColor = [UIColor whiteColor];
        [label2 setFont:[UIFont systemFontOfSize:34]];
        [self.picker.view addSubview:label2];
        
        UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
        overlayIV.image = overlayImage;
        [self.picker.cameraOverlayView addSubview:overlayIV];
    }
}


-(void)drawCaptureCircle:(NSInteger)x :(NSInteger)y :(NSInteger)radius :(UIView*)addingView{
    
    NSInteger borderRadius = 10;
    UIView* circleBorder = [[UIView alloc] initWithFrame:CGRectMake(x-borderRadius/2,y-borderRadius/2,radius+borderRadius,radius+borderRadius)];
    circleBorder .alpha = 1.0;
    circleBorder.layer.cornerRadius = (radius+borderRadius)/2;
    circleBorder.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [addingView addSubview:(circleBorder)];
    
    UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(x,y,radius,radius)];
    circleView.alpha = 1.0;
    circleView.layer.cornerRadius = radius/2;
    circleView.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [addingView addSubview:(circleView)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureButtonTapped)];
    singleTap.numberOfTapsRequired = 1;
    circleView.userInteractionEnabled = YES;
    [circleView addGestureRecognizer:singleTap];
}

- (void)pictureButtonTapped
{
    [self.picker removeFromParentViewController];
    [self.picker takePicture];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        UIImage *anImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        CGSize imageSize = anImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        if (width != height) {
            CGFloat newDimension = MIN(width, height);
            CGFloat widthOffset = (width - newDimension) / 2;
            CGFloat heightOffset = (height - newDimension) / 2;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
            [anImage drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                       blendMode:kCGBlendModeCopy
                           alpha:1.];
            anImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaEating" object:self];
        
        if( [self.hotpocketDetector isHotPocket:anImage] )
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaAteFood" object:self];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PitaAteNonFood" object:self];
        }
        
        [self.picker removeFromParentViewController];
    });
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self closeCameraPicker];
}

- (void)drawTheCancelLabelToView:(UIView*)addingView
{
    self.cancelLabel.text = @"Cancel";
    self.cancelLabel.textColor = [UIColor whiteColor];
    [self.cancelLabel setFont:[UIFont systemFontOfSize:26]];
    
    NSInteger marginsForSides = 30;
    
    [addingView addSubview:self.cancelLabel];
    
    [addingView addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelLabel
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:addingView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.00
                                                         constant:-marginsForSides]];
    
    [addingView addConstraint: [NSLayoutConstraint constraintWithItem:self.cancelLabel
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:addingView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.00
                                                          constant:-marginsForSides]];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCameraPicker)];
    [self.cancelLabel addGestureRecognizer:tapGesture];
}

- (void)closeCameraPicker
{
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)transitionToCameraView:(UIViewController*)theViewController
{
    [theViewController presentViewController:self.picker animated:YES completion:NULL];
}

@end
