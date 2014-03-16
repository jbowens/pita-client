//
//  SpongeInteraction.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/10/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "SpongeInteraction.h"

@interface SpongeInteraction ()

@property UIImageView* spongeImage;

@property NSLayoutConstraint* toRightSideConstraint;

@property NSLayoutConstraint* toBottomConstraint;

@property double animationDurationMovingBack;
@property NSInteger fromRightSideOfView;
@property NSInteger fromBottomSideOfView;

@end

@implementation SpongeInteraction

- (id)init
{
    self = [super init];
    if (self) {
        self.animationDurationMovingBack = 0.2;
        self.spongeImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.spongeImage.image = [UIImage imageNamed:@"sponge.png"];
    }
    return self;
}


- (UIImageView*)putSpongeInView:(UIView*)theView
{
    self.spongeImage.translatesAutoresizingMaskIntoConstraints = NO;
    [theView addSubview:(self.spongeImage)];
    
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:self.spongeImage
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.25
                                                         constant:0]];
    
    [theView addConstraint:[NSLayoutConstraint constraintWithItem:self.spongeImage
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:0.25
                                                         constant:0]];
    
    self.fromRightSideOfView = -theView.frame.size.width/15;
    self.toRightSideConstraint = [NSLayoutConstraint constraintWithItem:self.spongeImage
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:theView
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.00
                                                         constant:self.fromRightSideOfView];
    
    self.fromBottomSideOfView = -theView.frame.size.width/15;
    self.toBottomConstraint = [NSLayoutConstraint constraintWithItem:self.spongeImage
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:theView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.00
                                                          constant:self.fromBottomSideOfView];
    
    [theView addConstraint:self.toRightSideConstraint];
    [theView addConstraint:self.toBottomConstraint];
    return self.spongeImage;
}

- (void)changeInSpongeLocationInX:(NSInteger)x inY:(NSInteger)y inView:(UIView*)theView
{
    self.toRightSideConstraint.constant = self.fromRightSideOfView + x;
    self.toBottomConstraint.constant = self.fromBottomSideOfView + y;
}

- (void)returnToOriginalLocationInView:(UIView*)theView
{
    [theView layoutIfNeeded]; // Called on parent view
    [UIView animateWithDuration:self.animationDurationMovingBack
                     animations:^{
                         self.toRightSideConstraint.constant = self.fromRightSideOfView;
                         self.toBottomConstraint.constant = self.fromBottomSideOfView;
                         [theView layoutIfNeeded]; // Called on parent view
                     } completion:^(BOOL finished){
                     }];
}

@end
