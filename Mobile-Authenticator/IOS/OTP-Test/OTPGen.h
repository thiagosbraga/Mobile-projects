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
#import "OTP.h"
#import "KAProgressLabel.h"
#import "OTPTableViewCell.h"
@interface OTPGen : NSObject


@property(strong) TOTPGenerator *generator;


- (id)initWithSecret:(NSManagedObject *)otpManModel andOTPTableViewCELL:(OTPTableViewCell *)cell;


-(NSString *)generateToken;

@end
