//
//  SMMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMMessage.h"

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

@end
