//
//  SMProtocol.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMProtocol.h"
#import "NSString+SubstringHelpers.h"

/* If we ever see this sequence in a plaintext message, we'll assume the
 * other side speaks OTR, and try to establish a connection. */
static NSString *const kSMMessageTagBase    = @"";
/* The following must each be of length 8 */
static NSString *const kSMMessageTagV1      = @" \t \t  \t ";
static NSString *const kSMMessageTagV2      = @"  \t\t  \t ";
static NSString *const kSMMessageTagV3      = @"  \t\t  \t\t";

static NSString *const kSMTagPrefixV1       = @"?OTR:AAE";
static NSString *const kSMTagPrefixV2       = @"?OTR:AAI";
static NSString *const kSMTagPrefixV3       = @"?OTR:AAM";

/*
 "?OTR?"
 Version 1 only
 "?OTRv2?"
 Version 2 only
 "?OTRv23?"
 Versions 2 and 3
 "?OTR?v2?"
 Versions 1 and 2
 "?OTRv24x?"
 Version 2, and hypothetical future versions identified by "4" and "x"
 "?OTR?v24x?"
 Versions 1, 2, and hypothetical future versions identified by "4" and "x"
 "?OTR?v?"
 Also version 1 only
 "?OTRv?"
 A bizarre claim that Alice would like to start an OTR conversation, but is unwilling to speak any version of the protocol
 */
static NSString *const kSMTagPrefixQuery        = @"?OTR?";
static NSString *const kSMTagPrefixQueryV       = @"?OTRv";
static NSString *const kSMTagPrefixKeyExchange  = @"?OTR:AAEK";
static NSString *const kSMTagPrefixData         = @"?OTR:AAED";
static NSString *const kSMTagPrefixError        = @"?OTR Error:";

@implementation SMProtocol

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialize Diffie-Hellman

        // Initialize SM
    }
    return self;
}

+ (SMMessageType)messageType:(NSString *)message {
    if (![message containsString:@"?OTR"]) {
        
        if (![message containsString:kSMMessageTagBase]) {
            return SMMessageTypeTaggedPlainText;
        } else {
            return SMMessageTypeNotOTR;
        }
    }
    
    if (![message containsString:kSMTagPrefixV3] || ![message containsString:kSMTagPrefixV2]) {
        // Version 1
        /*
         switch(*(otrtag + 8)) {
         case 'C': return OTRL_MSGTYPE_DH_COMMIT;
         case 'K': return OTRL_MSGTYPE_DH_KEY;
         case 'R': return OTRL_MSGTYPE_REVEALSIG;
         case 'S': return OTRL_MSGTYPE_SIGNATURE;
         case 'D': return OTRL_MSGTYPE_DATA;
         }
         */
    } else {
        
        if ([message containsString:kSMTagPrefixQuery]) return SMMessageTypeQuery;
        if ([message containsString:kSMTagPrefixQueryV]) return SMMessageTypeQuery;
        if ([message containsString:kSMTagPrefixKeyExchange]) return SMMessageTypeV1KeyExchange;
        if ([message containsString:kSMTagPrefixData]) return SMMessageTypeData;
        if ([message containsString:kSMTagPrefixError]) return SMMessageTypeError;
    }
    
    
    return SMMessageTypeUnknown;
}

+ (NSInteger)messageVersion:(NSString *)version {
    if (![version containsString:@"?OTR"]) {
        // Invalid message
        return 0;
    }
    
    // Version prefixes
    if ([version containsString:kSMTagPrefixV3]) {
        return 3;
    }
    if ([version containsString:kSMTagPrefixV2]) {
        return 2;
    }
    if ([version containsString:kSMTagPrefixV1]) {
        return 1;
    }
    
    // Unknown version
    return 0;
}

@end
