//
//  PTSocialListViewController.h
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTServer.h"

@interface PTSocialListViewController : UIViewController

@property PTServer *server;

- (void)reloadNearbyPitas;

@end
