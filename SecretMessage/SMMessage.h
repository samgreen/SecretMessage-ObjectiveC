//
//  SMMessage.h
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import <Foundation/Foundation.h>

// Should be a byte (8 bit int)
typedef NS_ENUM(int8_t, SMMessageType) {
    SMMessageTypeNotOTR = 0x01,
    SMMessageTypeCommit = 0x02,
    SMMessageTypeTaggedPlainText,
    SMMessageTypeQuery,
    SMMessageTypeKey = 0x0a,
    SMMessageTypeRevealSignature = 0x11,
    SMMessageTypeSignature = 0x12,
    SMMessageTypeV1KeyExchange,
    SMMessageTypeData = 0x03,
    SMMessageTypeError,
    SMMessageTypeUnknown
};

typedef NS_ENUM(int16_t, SMProtocolVersion) {
    SMProtocolVersion1 = 0x001,
    SMProtocolVersion2,
    SMProtocolVersion3,
};

@interface SMMessage : NSObject

+ (instancetype)message;
+ (SMMessageType)type;

@property (nonatomic, readonly) SMProtocolVersion version;

@property (nonatomic) NSInteger senderInstance;
@property (nonatomic) NSInteger receiverInstance;

@end
