//
//  SocialInteractionButton.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "SocialInteractionButton.h"
#import "PTSocialListViewController.h"

@interface SocialInteractionButton ()

@property UIImageView* circleImage;
@property PTSocialListViewController* socialListViewController;

@end

@implementation SocialInteractionButton

- (id)initWithServer:(PTServer *)server
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.socialListViewController = [[PTSocialListViewController alloc] init];
        self.socialListViewController.server = server;
        self.circleImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.circleImage.image = [UIImage imageNamed:@"social.png"];
    }
    return self;
}

- (UIImageView*)putSocialButtonInView:(UIView*)theView
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
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.00
                                                         constant:-theView.frame.size.width/15]];
    
    [theView addConstraint: [NSLayoutConstraint constraintWithItem:self.circleImage
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:theView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.00
                                                          constant:theView.frame.size.width/10]];
    
    return self.circleImage;
}

- (void)openupSocialPage:(UIViewController*)viewController
{
    [viewController presentViewController:self.socialListViewController animated:YES completion:nil];
}


@end
