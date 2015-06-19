//
//  OTPTableViewCell.h
//  OTP-Test
//
//  Created by PRODUBAN on 6/18/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"

@interface OTPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblIssuer;

@property (weak, nonatomic) IBOutlet UILabel *lblToken;

@property (weak, nonatomic) IBOutlet UILabel *lblClientID;
@property (weak, nonatomic) IBOutlet KAProgressLabel *progressIndicator;
@property (weak, nonatomic) IBOutlet UIView *viewEditing;
@property (weak, nonatomic) IBOutlet UITextField *txtClientID;

@end
