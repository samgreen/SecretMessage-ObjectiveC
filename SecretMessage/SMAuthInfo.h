//
//  SMAuthInfo.h
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SMAuthState) {
    SMAuthStateNone,
    SMAuthStateAwaitingDHKey,
    SMAuthStateAwaitingRevealSignature,
    SMAuthStateAwaitingSignature,
    SMAuthStateSetupV1,
};

@class SMPrivateKey;
@class SMAuthInfo;

typedef NSError *(^SMAuthSuccessBlock)(SMAuthInfo *info, void *data);

@interface SMAuthInfo : NSObject

/*
 * Copy relevant information from the master OtrlAuthInfo to an
 * instance OtrlAuthInfo in response to a D-H Key with a new
 * instance. The fields copied will depend on the state of the
 * master auth.
 */
+ (SMAuthInfo *)copyFromMaster:(SMAuthInfo *)info;

/*
 * Start a fresh AKE (version 2 or 3) using the given OtrlAuthInfo.  Generate
 * a fresh DH keypair to use.  If no error is returned, the message to
 * transmit will be contained in auth->lastauthmsg.
 */
- (NSError *)start;
- (NSError *)start_v3:(NSInteger)version;
- (NSError *)start_v2:(NSInteger)version;

/*
 * Start a fresh AKE (version 1) using the given OtrlAuthInfo.  If
 * our_dh is NULL, generate a fresh DH keypair to use.  Otherwise, use a
 * copy of the one passed (with the given keyid).  Use the given private
 * key to sign the message.  If no error is returned, the message to
 * transmit will be contained in auth->lastauthmsg.
 */
- (NSError *)start_v1:(id)dh
            withKeyID:(NSUInteger)keyId
        forPrivateKey:(SMPrivateKey *)key;

/*
 * Handle an incoming D-H Commit Message.  If no error is returned, the
 * message to send will be left in auth->lastauthmsg.  Generate a fresh
 * keypair to use.
 */
- (NSError *)handleCommit:(NSString *)message
              withVersion:(NSInteger)version;

/*
 * Handle an incoming D-H Key Message.  If no error is returned, and
 * *havemsgp is 1, the message to sent will be left in auth->lastauthmsg.
 * Use the given private authentication key to sign messages.
 */
- (NSError *)handleKey:(NSString *)message
                    hm:(int *)hm
        withPrivateKey:(SMPrivateKey *)key;

/*
 * Handle an incoming Reveal Signature Message.  If no error is
 * returned, and *havemsgp is 1, the message to be sent will be left in
 * auth->lastauthmsg.  Use the given private authentication key to sign
 * messages.  Call the auth_succeeded callback if authentication is
 * successful.
 */
- (NSError *)handleRevealSignature:(NSString *)message
                                hm:(int *)hm
                    withPrivateKey:(SMPrivateKey *)key
                          complete:(SMAuthSuccessBlock)block;

/*
 * Handle an incoming Signature Message.  If no error is returned, and
 * *havemsgp is 1, the message to be sent will be left in
 * auth->lastauthmsg.  Call the auth_succeeded callback if
 * authentication is successful.
 */
- (NSError *)handleSignature:(NSString *)message
                          hm:(int *)hm
                    complete:(SMAuthSuccessBlock)block;

/*
 * Handle an incoming v1 Key Exchange Message.  If no error is returned,
 * and *havemsgp is 1, the message to be sent will be left in
 * auth->lastauthmsg.  Use the given private authentication key to sign
 * messages.  Call the auth_secceeded callback if authentication is
 * successful.  If non-NULL, use a copy of the given D-H keypair, with
 * the given keyid.
 */
- (NSError *)handleKeyExchange:(NSString *)message
                            hm:(int *)hm
                     withKeyID:(NSUInteger)keyId
                      complete:(SMAuthSuccessBlock)block;

@end
