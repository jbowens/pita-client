//
//  PTSocialListViewController.m
//  MyLittlePITA
//
//  Created by Hakrim Kim on 3/9/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTSocialListViewController.h"
#import "PTSocialListTableViewCell.h"

@interface PTSocialListViewController ()

@property NSInteger heightOfTableCell;

@property UITableView* listOfPitasAround;
@property UILabel* labelForTitle;
@property UILabel* labelForClose;

@property NSMutableArray* arrayOfPitasAround;

@end

@implementation PTSocialListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.heightOfTableCell = 250;
        self.arrayOfPitasAround = [[NSMutableArray alloc] init];
        
        self.listOfPitasAround = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        self.labelForClose = [[UILabel alloc] init];
        self.labelForClose.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.labelForTitle = [[UILabel alloc] init];
        [self.labelForTitle setFont:[UIFont systemFontOfSize:26]];
        self.labelForTitle.translatesAutoresizingMaskIntoConstraints = NO;
        // Custom initialization
    }
    return self;
}

- (void)testingPitas
{
    [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:@"Testing1" theImage:[UIImage imageNamed:@"sponge.png"] theMood:0]];
    [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:@"Testing2" theImage:[UIImage imageNamed:@"sponge.png"] theMood:0]];
    [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:@"Testing3" theImage:[UIImage imageNamed:@"sponge.png"] theMood:0]];
    [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:@"Testing4" theImage:[UIImage imageNamed:@"sponge.png"] theMood:0]];
    [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:@"Testing5" theImage:[UIImage imageNamed:@"sponge.png"] theMood:0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
    
    [self drawLabels];
    [self drawTable];
	// Do any additional setup after loading the view.
    
    // Request the nearby accounts from the server.
    [self reloadNearbyPitas];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadNearbyPitas];
}

- (void)reloadNearbyPitas
{
    [self.server findNearbyAccounts:nil longitude:nil completionHandler:^(NSDictionary *results, NSError *err) {
        [self.arrayOfPitasAround removeAllObjects];
        NSArray *nearbyAccounts = [results objectForKey:@"nearby_accounts"];
        NSLog(@"Nearby accounts: %@", nearbyAccounts);
        for (NSDictionary *nearbyAccount in nearbyAccounts)
        {
            NSString *accountName = [NSString stringWithFormat:@"Account #%@", [nearbyAccount objectForKey:@"aid"]];
            [self.arrayOfPitasAround addObject:[[PTSocialListPitaObject alloc] initWithTheName:accountName
                                                                                      theImage:[UIImage imageNamed:@"sponge.png"]
                                                                                       theMood:0]];
            [[self listOfPitasAround] reloadData];
        }
    }];
}

- (void)drawLabels
{
    NSInteger heightOfTitle = 48;
    NSInteger marginsForClose = 15;
    NSInteger marginsForStatusBar = 15;
    
    self.labelForTitle.text = @"Pitas Around";
    self.labelForClose.text = @"Close";
    
    [self.view addSubview:self.labelForTitle];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelForTitle
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.00
                                                           constant:marginsForStatusBar]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelForTitle
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.00
                                                           constant:0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.labelForTitle
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeHeight
                                                          multiplier:0.00
                                                            constant:heightOfTitle]];
    
    
    [self.view addSubview:self.labelForClose];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.labelForClose
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.00
                                                            constant:-marginsForClose]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.labelForClose
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.00
                                                             constant:marginsForClose+marginsForStatusBar]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackToPreviousPage)];
    self.labelForClose.userInteractionEnabled = YES;
    
    [self.labelForClose addGestureRecognizer:tapGesture];
}

- (void)drawTable
{
    self.listOfPitasAround.separatorColor = [UIColor clearColor];
    self.listOfPitasAround.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listOfPitasAround.translatesAutoresizingMaskIntoConstraints = NO;
    self.listOfPitasAround.rowHeight = self.heightOfTableCell;
    self.listOfPitasAround.scrollEnabled = YES;
    self.listOfPitasAround.showsVerticalScrollIndicator = NO;
    self.listOfPitasAround.userInteractionEnabled = YES;
    self.listOfPitasAround.bounces = NO;
    self.listOfPitasAround.delegate = self;
    self.listOfPitasAround.dataSource = self;
    [self.view addSubview:self.listOfPitasAround];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.listOfPitasAround
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.labelForTitle
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.00
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.listOfPitasAround
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.00
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.listOfPitasAround
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.00
                                                           constant:0]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.listOfPitasAround
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.00
                                                            constant:0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayOfPitasAround] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PTSocialListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pitaCell"];
    if(cell == nil)
    {
        cell = [[PTSocialListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pitaCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Get the event at the row selected and display its title
    [cell drawTheCellWithPitaObject:[[self arrayOfPitasAround] objectAtIndex:indexPath.row]];
    return cell;
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
