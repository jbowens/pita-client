//
//  PTSocialListViewController.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTSocialListViewController.h"

@interface PTSocialListViewController ()

@property UITableView* listOfPitasAround;

@end

@implementation PTSocialListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.listOfPitasAround = [[UITableView alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackToPreviousPage)];
    tapGesture.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    
    [self.view addGestureRecognizer:tapGesture];
	// Do any additional setup after loading the view.
}

- (void)goBackToPreviousPage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
