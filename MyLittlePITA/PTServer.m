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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PTServer

NSString * const ServerHost = @"api.mylittlepita.com";

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

- (void)sendRequest:(NSString *)endpoint withParams:(NSDictionary *)params
{
    NSString *fullUrlString = [NSString stringWithFormat:@"http://%@%@", ServerHost, endpoint];
    NSURL *url = [[NSURL alloc] initWithString:fullUrlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: url];
    [req setHTTPMethod: @"POST"];

    // The user has an account. Send the authentication headers too.
    if (self.accountId) {
        [req addValue:accountId forHTTPHeaderField:@"X-PITA-ACCOUNT-ID"];
        [req addValue:accountKey forHTTPHeaderField:@"X-PITA-SECRET"];
    }

    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error)
                           {
                               NSLog(@"do shit with data: %@", data); 
                           }];
}

- (BOOL)newAccount:(NSString *)name phone:(NSString *)phone email:(NSString *)email error:(NSError **)errorPtr
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

    NSDictionary *params = @{ @"name": name, @"phone": phone, @"email": email };

    [self sendRequest:@"/accounts/new" withParams:params];

    return YES;
}

@end
