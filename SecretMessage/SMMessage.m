//
//  SMMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMMessage.h"

@interface SMMessage ()

@property (nonatomic) short version;

@end

@implementation SMMessage

+ (instancetype)message {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Defaulting to version 3
        self.version = 0x003;
    }
    return self;
}

@end
