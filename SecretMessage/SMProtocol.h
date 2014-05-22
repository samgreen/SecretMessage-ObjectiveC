//
//  SMProtocol.h
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMessage.h"

typedef NSUInteger SMPolicy;

typedef NS_ENUM(NSUInteger, SMFragmentResult) {
    SMFragmentResultUnfragmented,
    SMFragmentResultIncomplete,
    SMFragmentResultComplete
};

typedef NS_ENUM(NSUInteger, SMFragmentPolicy) {
    SMFragmentPolicySendSkip, /* Return new message back to caller,
                               * but don't inject. */
    SMFragmentPolicySendAll,
    SMFragmentPolicySendAllExceptFirst,
    SMFragmentPolicySendAllExceptLast
};

@interface SMProtocol : NSObject

+ (NSString *)newQueryMessage:(NSString *)name withPolicy:(SMPolicy)policy;

+ (NSUInteger)versionForQuery:(NSString *)message withPolicy:(SMPolicy)policy;

+ (SMMessageType)messageType:(NSString *)message;
+ (NSInteger)messageVersion:(NSString *)version;

//+ (NSError *)newMessage:(NSString **)message

@end
