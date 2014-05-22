//
//  SMDiffieHellmanKeyMessage.h
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "SMMessage.h"

@interface SMKeyMessage : SMMessage

@property (nonatomic, readonly) NSData *gPowY;

@end
