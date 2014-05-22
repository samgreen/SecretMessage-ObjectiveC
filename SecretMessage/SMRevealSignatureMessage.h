//
//  SMRevealSignatureMessage.h
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMMessage.h"

@interface SMRevealSignatureMessage : SMMessage

@property (nonatomic) NSData *r;
@property (nonatomic, readonly) NSData *encryptedSignature;

@end
