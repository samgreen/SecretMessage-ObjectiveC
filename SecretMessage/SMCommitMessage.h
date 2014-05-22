//
//  SMCommitMessage.h
//  SecretMessage
//
//  Created by Sam Green on 5/22/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMessage.h"

@interface SMCommitMessage : SMMessage

@property (nonatomic, readonly) NSData *encryptedData;
@property (nonatomic, readonly) NSData *hashedData;

@end
