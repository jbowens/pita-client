//
//  PTServer.m
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTServer.h"
#import "PTError.h"
#import "Reachability.h"

@implementation PTServer

Reachability *reachability;
BOOL networkAvailable;

@synthesize accountId;
@synthesize accountKey;

- (id)init
{
    self = [super init];
    if (self) {
        self.accountId = nil;
        self.accountKey = nil;
        [self setupReachability];
    }
    return self;
}

- (id)initWithAccount:(NSString *)accountId accountKey:(NSString *)accountKey
{
    self = [super init];
    if (self) {
        self.accountId = accountId;
        self.accountKey = accountKey;
        [self setupReachability];
    }
    return self;
}

- (void)setupReachability
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(networkChanged:)
                                                name:kReachabilityChangedNotification
                                              object:nil];

    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    networkAvailable = (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN);
    NSLog(@"network is %@", networkAvailable ? @"available" : @"unavailable");
}

- (void)networkChanged:(NSNotification *)notification
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];

    if(remoteHostStatus == NotReachable)
    {
        networkAvailable = NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN ||
             remoteHostStatus == ReachableViaWiFi)
    {
        networkAvailable = YES;
    }
    NSLog(@"network is %@", networkAvailable ? @"available" : @"unavailable");
}

- (BOOL)newAccount:(NSError **)errorPtr
{
    if (self.accountId != nil || self.accountKey != nil) {
        if (errorPtr) {
            *errorPtr = [PTError alreadyAuthenticated];
        }
        return NO;
    }

    if (!networkAvailable) {
        if (errorPtr) {
            *errorPtr = [PTError internetUnavailable];
        }
        return NO;
    }

    return YES;
}

@end
