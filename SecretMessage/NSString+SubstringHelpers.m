//
//  NSString+SubstringHelpers.m
//  SecretMessage
//
//  Created by Sam Green on 5/21/14.
//  Copyright (c) 2014 Detonation Games. All rights reserved.
//

#import "NSString+SubstringHelpers.h"

@implementation NSString (SubstringHelpers)

- (BOOL)containsString:(NSString *)substring {
    return ([self rangeOfString:substring].location != NSNotFound);
}

@end
