//
//  SMMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMMessage.h"

#define SM_HEADER_LENGTH_BYTES		3
#define SM_B64_HEADER_LENGTH_BYTES	4

@interface SMMessage ()

@property (nonatomic) SMProtocolVersion version;

@end

@implementation SMMessage

+ (instancetype)message {
    return [[self alloc] initWithType:[self.class type]];
}

+ (SMMessageType)type {
    return SMMessageTypeUnknown;
}

- (instancetype)initWithType:(SMMessageType)type {
    self = [super init];
    if (self) {
        // Default to latest, v3
        self.version = SMProtocolVersion3;
    }
    return self;
}

- (NSData *)createData {
    // Write the header
    uint8_t data[SM_HEADER_LENGTH_BYTES];
    [[self createHeaderData] getBytes:data length:1];
    
    // Write instance tags
    data[1] = self.receiverInstance;
    data[2] = self.senderInstance;
    
    return [NSData dataWithBytes:data length:SM_HEADER_LENGTH_BYTES];
}

- (NSData *)createHeaderData {
    uint8_t *header = calloc(SM_HEADER_LENGTH_BYTES, sizeof(uint8_t));
    header[0] = '\x02';
    return [NSData dataWithBytes:header length:SM_HEADER_LENGTH_BYTES];
}

- (NSUInteger)calculateHeaderSize {
    BOOL isVersion3 = (self.version == SMProtocolVersion3);
    return SM_HEADER_LENGTH_BYTES + (isVersion3 ? 8 : 0) + 4;
}


@end
