//
//  SMMessage.h
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SMMessageType) {
    SMMessageTypeNotOTR,
    SMMessageTypeTaggedPlainText,
    SMMessageTypeQuery,
    SMMessageTypeDHCommit,
    SMMessageTypeDHKey,
    SMMessageTypeRevealSignature,
    SMMessageTypeSignature,
    SMMessageTypeV1KeyExchange,
    SMMessageTypeData,
    SMMessageTypeError,
    SMMessageTypeUnknown
};

@interface SMMessage : NSObject

@property (nonatomic, readonly) short version;
@property (nonatomic) SMMessageType type;

@property (nonatomic) NSInteger senderInstance;
@property (nonatomic) NSInteger receiverInstance;

@end
