//
//  SMAuthInfo.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMAuthInfo.h"
#import "SMContext.h"

@interface SMAuthInfo ()

@property (nonatomic, strong) SMContext *context;
@property (nonatomic) SMAuthState state;

@end

@implementation SMAuthInfo

+ (SMAuthInfo *)copyFromMaster:(SMAuthInfo *)info {
    return nil;
}

- (instancetype)initWithContext:(SMContext *)context {
    self = [super init];
    if (self) {
        self.context = context;
        self.state = SMAuthStateNone;
    }
    return self;
}

- (NSError *)start {
    return nil;
}

- (NSError *)start:(NSInteger)version {
    return nil;
}

- (NSError *)start_v3:(NSInteger)version {
    return nil;
}

- (NSError *)start_v2:(NSInteger)version {
    return nil;
}

- (NSError *)start_v1:(id)dh withKeyID:(NSUInteger)keyId forPrivateKey:(SMPrivateKey *)key {
    return nil;
}

- (NSError *)handleCommit:(NSString *)message
              withVersion:(NSInteger)version {
    return nil;
}

- (NSError *)handleKey:(NSString *)message
                    hm:(int *)hm
        withPrivateKey:(SMPrivateKey *)key {
    return nil;
}

- (NSError *)handleRevealSignature:(NSString *)message
                                hm:(int *)hm
                    withPrivateKey:(SMPrivateKey *)key
                          complete:(SMAuthSuccessBlock)block {
    return nil;
}

- (NSError *)handleSignature:(NSString *)message
                          hm:(int *)hm
                    complete:(SMAuthSuccessBlock)block {
    NSError *error = NULL;
    
    // Base64 decode message
    
    switch (self.state) {
        case SMAuthStateAwaitingSignature:
            // Check the MAC
            // Check the auth
            // No error? Auth completed!
            break;
        case SMAuthStateNone:
        case SMAuthStateAwaitingDHKey:
        case SMAuthStateAwaitingRevealSignature:
        case SMAuthStateSetupV1:
            // Ignore this message
            break;
    }
    
    return error;
}

- (NSError *)handleKeyExchange:(NSString *)message
                            hm:(int *)hm
                     withKeyID:(NSUInteger)keyId
                      complete:(SMAuthSuccessBlock)block {
    return nil;
}

#pragma mark - Description
- (NSString *)description {
    return [super description];
    /*
    int i;
    
    fprintf(f, "  Auth info %p:\n", auth);
    fprintf(f, "    State: %d (%s)\n", auth->authstate,
            auth->authstate == OTRL_AUTHSTATE_NONE ? "NONE" :
            auth->authstate == OTRL_AUTHSTATE_AWAITING_DHKEY ? "AWAITING_DHKEY" :
            auth->authstate == OTRL_AUTHSTATE_AWAITING_REVEALSIG ?
            "AWAITING_REVEALSIG" :
            auth->authstate == OTRL_AUTHSTATE_AWAITING_SIG ? "AWAITING_SIG" :
            auth->authstate == OTRL_AUTHSTATE_V1_SETUP ? "V1_SETUP" :
            "INVALID");
    fprintf(f, "    Context: %p\n", auth->context);
    fprintf(f, "    Our keyid:   %u\n", auth->our_keyid);
    fprintf(f, "    Their keyid: %u\n", auth->their_keyid);
    fprintf(f, "    Their fingerprint: ");
    for (i=0;i<20;++i) {
        fprintf(f, "%02x", auth->their_fingerprint[i]);
    }
    fprintf(f, "\n    Initiated = %d\n", auth->initiated);
    fprintf(f, "\n    Proto version = %d\n", auth->protocol_version);
    fprintf(f, "\n    Lastauthmsg = %s\n",
            auth->lastauthmsg ? auth->lastauthmsg : "(nil)");
    fprintf(f, "\n    Commit sent time = %ld\n",
            (long) auth->commit_sent_time);
     */
}

@end
