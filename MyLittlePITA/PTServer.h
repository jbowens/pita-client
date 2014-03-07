//
//  PTServer.h
//  MyLittlePITA
//
//  Created by Jackson Owens on 2/26/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 * Records an error by POSTing the error info to the server.
 */
- (void)recordError:(NSString *)message;

@end
