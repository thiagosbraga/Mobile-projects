//
//  OTPGen.h
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOTP.h"
#import "TOTPGenerator.h"

@interface OTPGen : NSObject<IOTP>

@property(strong)NSString * secret;
@property(strong) TOTPGenerator *generator;

- (id)initWithSecret:(NSString *)secret;
-(NSString *)generateToken;

@end
