//
//  OTPGen.m
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import "OTPGen.h"
#import "TOTPGenerator.h"
#import "MF_Base32Additions.h"



@implementation OTPGen

static NSInteger digits = 6;
static  NSInteger period = 30;


- (id)initWithSecret:(NSString *)secret
{
    self = [super init];
    if (self) {
        self.secret = secret;
        NSData *secretData =  [NSData dataWithBase32String:secret];

        self.generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:digits period:period];
    }
    return self;
}

-(NSString *)generateToken{
    return [self.generator generateOTPForDate:[NSDate date]];
}

@end
