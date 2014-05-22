//
//  SMDiffieHellmanKeyMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMKeyMessage.h"

#define SM_Y_LENGTH_BYTES   40

@implementation SMKeyMessage

+ (SMMessageType)type {
    return SMMessageTypeKey;
}

//    gy (MPI)
//    Choose a random value y (at least 320 bits), and calculate g^y.
- (NSData *)g {
    uint8_t yBytes[SM_Y_LENGTH_BYTES];
    // Generate 320 random bits for x
    SecRandomCopyBytes(kSecRandomDefault, SM_Y_LENGTH_BYTES, yBytes);
    
    // TODO: Calcuate g^y
    
    // Return the bytes as an NSData
//    return [NSData dataWithBytes:yBytes length:SM_Y_LENGTH_BYTES];
    return nil;
}

@end
