//
//  OtpViewController.h
//  OTP-Test
//
//  Created by PRODUBAN on 5/26/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QrCodeDelegate.h"
#import "KAProgressLabel.h"

@interface OtpViewController : UIViewController<QrCodeDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblOTP;

- (void)lerCodigo;

@property (weak, nonatomic) IBOutlet UIButton *btnCopiar;
@property (weak, nonatomic) IBOutlet KAProgressLabel *viewCOunting;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;

- (IBAction)copiarToken:(id)sender;


@end
