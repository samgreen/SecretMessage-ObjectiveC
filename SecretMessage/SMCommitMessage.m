//
//  SMCommitMessage.m
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMCommitMessage.h"
#import "BigInteger.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

#define SM_R_LENGTH_BYTES   kCCKeySizeAES128
#define SM_X_LENGTH_BYTES   40

@interface SMCommitMessage ()

@property (nonatomic) NSData *r;
@property (nonatomic) NSData *x;
@property (nonatomic) NSData *gx;
@property (nonatomic, strong) BigInteger *gxBigInt;

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
    self.x = [NSData dataWithBytes:xBytes length:SM_X_LENGTH_BYTES];

    // TODO: Serialize gx
    self.gxBigInt = [BigInteger bigintWithRandomNumberOfSize:SM_X_LENGTH_BYTES exact:YES];
    NSUInteger numBytes = self.gxBigInt.bitCount * 8;
    
    uint8_t gxBytes[numBytes];
    [self.gxBigInt getBytes:gxBytes length:numBytes];
    
    
    uint8_t encryptedBytes[CC_SHA256_DIGEST_LENGTH];
    size_t dataOutAvailable = 0, dataOutMoved = 0;
    // Encrypt gx (AES128-CTR), should be the same size as gx
    CCCrypt(kCCEncrypt, kCCAlgorithmAES, 0, self.r.bytes, self.r.length, NULL,
            gxBytes, numBytes, encryptedBytes, dataOutAvailable, &dataOutMoved);
    // Return an NSData pointing to the encrypted bytes
    return [NSData dataWithBytes:encryptedBytes length:dataOutMoved];
    
    /*
    gcry_error_t err = gcry_error(GPG_ERR_NO_ERROR);
    const enum gcry_mpi_format format = GCRYMPI_FMT_USG;
    size_t npub;
    gcry_cipher_hd_t enc = NULL;
    unsigned char ctr[16];
    unsigned char *buf, *bufp;
    size_t buflen, lenp;
    
    // Clear out this OtrlAuthInfo and start over
    otrl_auth_clear(auth);
    auth->initiated = 1;
    auth->protocol_version = version;
    auth->context->protocol_version = version;
    
    otrl_dh_gen_keypair(DH1536_GROUP_ID, &(auth->our_dh));
    auth->our_keyid = 1;
    
    // Pick an encryption key
    gcry_randomize(auth->r, 16, GCRY_STRONG_RANDOM);
    
    // Allocate space for the encrypted g^x
    gcry_mpi_print(format, NULL, 0, &npub, auth->our_dh.pub);
    auth->encgx = malloc(4+npub);
    if (auth->encgx == NULL) goto memerr;
    auth->encgx_len = 4+npub;
    bufp = auth->encgx;
    lenp = auth->encgx_len;
    write_mpi(auth->our_dh.pub, npub, "g^x");
    assert(lenp == 0);
    
    // Hash g^x
    gcry_md_hash_buffer(GCRY_MD_SHA256, auth->hashgx, auth->encgx,
                        auth->encgx_len);
    
    // Encrypt g^x using the key r
    err = gcry_cipher_open(&enc, GCRY_CIPHER_AES, GCRY_CIPHER_MODE_CTR,
                           GCRY_CIPHER_SECURE);
    if (err) goto err;
    
    err = gcry_cipher_setkey(enc, auth->r, 16);
    if (err) goto err;
    
    memset(ctr, 0, 16);
    err = gcry_cipher_setctr(enc, ctr, 16);
    if (err) goto err;
    
    err = gcry_cipher_encrypt(enc, auth->encgx, auth->encgx_len, NULL, 0);
    if (err) goto err;
    
    gcry_cipher_close(enc);
    enc = NULL;
    */
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
