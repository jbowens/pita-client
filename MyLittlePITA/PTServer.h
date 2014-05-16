//
//  PTServer.h
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTCritter.h"

typedef void (^ServerCompletionHandler)(NSDictionary *, NSError *);

@interface PTServer : NSObject

@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *accountKey;

/* 
 * Initializes a server object without any account authorization. This
 * should be used when the user does not yet have a My Little PITA 
 * account.
 */
- (id)init;

/*
 * Initializes a server object with account authorization data. The initialized
 * server object will use the given credentials for requests to all protected
 * enpoints.
 */
- (id)initWithAccount:(NSString *)accountId accountKey:(NSString *)accountKey;

/*
 * Creates a new account.
 */
- (void)newAccount:(NSString *)name phone:(NSString *)phone email:(NSString *)email completionHandler:(ServerCompletionHandler)completionHandler;

/*
 * Records the current account location.
 */
- (void)recordLocation:(NSNumber *)latitude longitude:(NSNumber *)longitude;

/*
 * Records an error by POSTing the error info to the server.
 */
- (void)recordError:(NSString *)message;

/*
 * Creates a random pita on the server and returns the pita's
 * properties.
 */
- (void)createRandomPita:(ServerCompletionHandler)completionHandler;

/*
 * Saves the current status of the pita to the server.
 */
- (void)savePitaStatus:(float)happiness hunger:(float)hunger sleepiness:(float)sleepiness;

/*
 * Records the hatching of a pita.
 */
- (void)recordHatch:(ServerCompletionHandler)completionHandler;

/*
 * Records the death of a pita.
 */
- (void)recordDeath:(ServerCompletionHandler)completionHandler;

/*
 * Finds nearby accounts/pitas. The latitude and longitude are optional
 * but recommended. If not provided, the account must have recorded a
 * location recently (5 minutes).
 */
- (void)findNearbyAccounts:(NSNumber *)latitude longitude:(NSNumber *)longitude completionHandler:(ServerCompletionHandler)completionHandler;

@end
