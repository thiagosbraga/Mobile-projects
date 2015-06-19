//
//  OTP.m
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import "OTP.h"

@implementation OTP

- (id)initWithClientID:(NSString *)clientId AndIssuer:(NSString *)issuer Algorith:(NSString *) algorithm AndSecret:(NSString *)secret
{
    self = [super init];
    if (self) {
        _clientId = clientId;
        _issuer = issuer;
        _algorithm=algorithm;
        _secret=secret;
    }
    return self;
}

@end
