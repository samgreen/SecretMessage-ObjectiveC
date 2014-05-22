//
//  SMSecretMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMSecretMessage.h"

@interface SMSecretMessage ()

@property (nonatomic) SSLContextRef context;

@end

@implementation SMSecretMessage

+ (instancetype)sharedMessage {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.context = SSLCreateContext(NULL, kSSLClientSide, kSSLStreamType);
    }
    return self;
}

@end
