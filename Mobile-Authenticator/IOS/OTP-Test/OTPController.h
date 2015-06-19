//
//  OTPController.h
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTP.h"
@interface OTPController : NSObject



-(bool)saveOTP:(NSString *)otp;

-(NSMutableArray *)getAllOTOP;

-(bool)deleteOTP:(NSManagedObject *)otp;

-(bool)updateOTP:(OTP *)otp;

@end
