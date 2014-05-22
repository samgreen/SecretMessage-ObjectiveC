//
//  SMRevealSignatureMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMRevealSignatureMessage.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

#define SM_MB_LENGTH_BYTES                      kCCKeySizeAES128
#define SM_TRUNCATED_SIGNATURE_LENGTH_BYTES     40

@interface SMRevealSignatureMessage ()

@property (nonatomic) NSData *m1;
@property (nonatomic) NSData *m2;

@end

@implementation SMRevealSignatureMessage

+ (SMMessageType)type {
    return SMMessageTypeRevealSignature;
}

/*
 Encrypted signature
     This field is calculated as follows:
         Compute the Diffie-Hellman shared secret s.
         Use s to compute an AES key c and two MAC keys m1 and m2, as specified below.
         Select keyidB, a serial number for the D-H key computed earlier. It is an INT, and must be greater than 0.
         Compute the 32-byte value MB to be the SHA256-HMAC of the following data, using the key m1:
             gx (MPI)
             gy (MPI)
             pubB (PUBKEY)
             keyidB (INT)
 
         Let XB be the following structure:
             pubB (PUBKEY)
             keyidB (INT)
             sigB(MB) (SIG)
         This is the signature, using the private part of the key pubB, of the 32-byte MB (which does not need to be hashed again to produce the signature).
         Encrypt XB using AES128-CTR with key c and initial counter value 0.
 */
- (NSData *)encryptedSignature {
    // s - shared secret
    // c - AES key
    
    // m1 - MAC key
//    self.m1
    
    // m2 - MAC key
//    self.m2
    
    // keyidB - serial for DH key > 0
    
    // Compute MB (SHA256-HMAC: gx, gy, pubB, keyidB)
//    uint8_t mb[SM_MB_LENGTH_BYTES];
//    CCHmac(kCCHmacAlgSHA256, self.m1.bytes, self.m1.length, <#const void *data#>, <#size_t dataLength#>, mb);
    
    // Encrypt XB
//    CCCrypt(kCCEncrypt, kCCAlgorithmAES, 0, <#const void *key#>, <#size_t keyLength#>, <#const void *iv#>, <#const void *dataIn#>, <#size_t dataInLength#>, <#void *dataOut#>, <#size_t dataOutAvailable#>, <#size_t *dataOutMoved#>)
    
    return nil;
}

/*
 MAC'd signature
     This is the SHA256-HMAC-160 (that is, the first 160 bits of the SHA256-HMAC) of the encrypted signature field (including the four-byte length), using the key m2.
 */
- (NSData *)signatureHmac {
    uint8_t mac[CC_SHA256_DIGEST_LENGTH];
    // Calculate the hmac of the first 40 bytes of the signature
    CCHmac(kCCHmacAlgSHA256, self.m2.bytes, self.m2.length,
           self.encryptedSignature.bytes, self.encryptedSignature.length, mac);
    // Return the first 160 bits of the MAC
    return [NSData dataWithBytes:mac length:SM_TRUNCATED_SIGNATURE_LENGTH_BYTES];
}

@end
