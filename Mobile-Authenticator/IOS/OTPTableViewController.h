//
//  OTPTableViewController.h
//  OTP-Test
//
//  Created by PRODUBAN on 6/18/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QrCodeDelegate.h"
#import "OTPController.h"
@interface OTPTableViewController : UITableViewController<QrCodeDelegate>

@property(strong ,nonatomic) OTPController *controller;
@property(strong ,nonatomic) NSMutableArray *list;

@end
