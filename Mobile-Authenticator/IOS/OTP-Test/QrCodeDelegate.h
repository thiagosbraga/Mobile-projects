//
//  QrCodeDelegate.h
//  OTP-Test
//
//  Created by PRODUBAN on 5/27/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QrCodeDelegate <NSObject>

-(void)responseQrcodeData:(NSString *)data;

@end
