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



@interface OTPGen()
@property(strong)OTP * otp;
@property(strong)OTPTableViewCell * otpCell;


@end

@implementation OTPGen

static NSInteger DEFAULT_DIGITS = 6;
static  NSInteger DEFAULT_PERIOD = 30;


- (id)initWithSecret:(NSManagedObject *)otpManModel andOTPTableViewCELL:(OTPTableViewCell *)cell;
{
    self = [super init];
    if (self) {
        _otpCell = cell;
        self.otp = [[OTP alloc]initWithClientID:[otpManModel valueForKey:@"clientID"] AndIssuer:[otpManModel valueForKey:@"issuer"] Algorith:[otpManModel valueForKey:@"algorithm"] AndSecret:[otpManModel valueForKey:@"secret"]];;
        NSData *secretData =  [NSData dataWithBase32String:self.otp.secret];
        
        self.otpCell.progressIndicator.progressColor = [UIColor colorWithRed:204 green:0 blue:0 alpha:1];
        
        self.otpCell.progressIndicator.progressWidth = 5.0;

        self.generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:DEFAULT_DIGITS period:DEFAULT_PERIOD];
        [self updateViews];
        
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateViews) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) updateViews{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    //NSString *dateString = [dateFormatter stringFromDate:now];
    
    long timestamp = (long)[now timeIntervalSince1970];
    long tempo = 30-(timestamp % 30);
    CGFloat var = tempo/30.0f;
    NSNumber *interv = [NSNumber numberWithFloat:var];
    self.otpCell.progressIndicator.progress = interv.floatValue;
    self.otpCell.lblToken.text = [self generateToken];
    
//    self.progress.labelVCBlock = ^(KAProgressLabel *label) {
//        
//        NSString *desc;
//        
//        if (tempo - 1 == 0) {
//            desc =[NSString stringWithFormat:@"%d sec", tempo + 29];
//        }else{
//            desc =[NSString stringWithFormat:@"%d sec", tempo -1];
//        }
//        
//        
//        label.text = desc;
//    };
    
}

-(NSString *)generateToken{
    return [self.generator generateOTPForDate:[NSDate date]];
}

@end
