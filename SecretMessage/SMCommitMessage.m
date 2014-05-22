//
//  SMCommitMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMCommitMessage.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

#define SM_R_LENGTH_BYTES   kCCKeySizeAES128
#define SM_X_LENGTH_BYTES   40

@interface SMCommitMessage ()

@property (nonatomic) NSData *r;
@property (nonatomic) NSData *x;
@property (nonatomic) NSData *gx;

@end

@implementation SMCommitMessage

+ (SMMessageType)type {
    return SMMessageTypeCommit;
}

/*
 Encrypted gx
 
 Produce this field as follows:
     Choose a random value r (128 bits)
     Choose a random value x (at least 320 bits)
     Serialize gx as an MPI, gxmpi. [gxmpi will probably be 196 bytes long, starting with "\x00\x00\x00\xc0".]
     Encrypt gxmpi using AES128-CTR, with key r and initial counter value 0. The result will be the same length as gxmpi.
 */
- (NSData *)encryptedData {
    uint8_t rBytes[SM_R_LENGTH_BYTES];
    // Generate 128 random bits for r
    SecRandomCopyBytes(kSecRandomDefault, SM_R_LENGTH_BYTES, rBytes);
    // Save the bytes as an NSData
    self.r = [NSData dataWithBytes:rBytes length:SM_R_LENGTH_BYTES];
    
    uint8_t xBytes[SM_X_LENGTH_BYTES];
    // Generate 320 random bits for x
    SecRandomCopyBytes(kSecRandomDefault, SM_X_LENGTH_BYTES, xBytes);
    // Save the bytes as an NSData
    self.x = [NSData dataWithBytes:xBytes length:SM_R_LENGTH_BYTES];

    // TODO: Serialize gx
    
    
    uint8_t encryptedBytes[self.gx.length];
    size_t dataOutAvailable = 0, dataOutMoved = 0;
    // Encrypt gx (AES128-CTR), should be the same size as gx
    CCCrypt(kCCEncrypt, kCCAlgorithmAES, 0, self.r.bytes, SM_R_LENGTH_BYTES, NULL,
            self.gx.bytes, self.gx.length, encryptedBytes, dataOutAvailable, &dataOutMoved);
    // Return an NSData pointing to the encrypted bytes
    return [NSData dataWithBytes:encryptedBytes length:dataOutMoved];
}

/*
 Hashed gx
 
 This is the SHA256 hash of gxmpi.
 */
- (NSData *)hashedData {
    // Create store for the SHA256
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // Hash the gx value
    CC_SHA256(self.gx.bytes, (CC_LONG)self.gx.length, digest);
    
    // Return an NSData pointing to the bytes
    return [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
}

@end
