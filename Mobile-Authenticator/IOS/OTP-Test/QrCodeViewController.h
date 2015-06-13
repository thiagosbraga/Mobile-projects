//
//  QrCodeViewController.h
//  OTP-Test
//
//  Created by PRODUBAN on 5/27/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QrCodeDelegate.h"
@interface QrCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (strong, nonatomic) id<QrCodeDelegate> delegate;

- (id)initWithDelegate:(id<QrCodeDelegate>)delegate;
@end
