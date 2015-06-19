//
//  OTP.h
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTP : NSObject

@property(strong) NSString * clientId;
@property(strong) NSString * issuer;
@property(strong) NSString * algorithm;
@property (strong) NSString * secret;

- (id)initWithClientID:(NSString *)clientId AndIssuer:(NSString *)issuer Algorith:(NSString *) algorithm AndSecret:(NSString *)secret;

@end
