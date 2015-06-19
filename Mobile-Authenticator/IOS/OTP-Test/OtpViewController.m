//
//  OtpViewController.m
//  OTP-Test
//
//  Created by PRODUBAN on 5/26/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import "OtpViewController.h"
#import "TOTPGenerator.h"
#import "MF_Base32Additions.h"
#import "QrCodeViewController.h"

@interface OtpViewController ()
@property(strong) NSString *secret;
@property(strong) NSString *user;
@property(assign) BOOL hasKey;

@end

@implementation OtpViewController
NSString *const OTPKeyValue = @"otpuri";
NSString *const OTPTitleName = @"TOKEN OTP";



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor =[UIColor redColor];
    
   [self gerarSenha:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(gerarSenha:) userInfo:nil repeats:YES];
    self.viewCOunting.backgroundColor = [UIColor clearColor];
    
    //self.viewCOunting.fillColor = [UIColor redColor];
  
    self.viewCOunting.progressColor = [UIColor colorWithRed:204 green:0 blue:0 alpha:1];

    self.viewCOunting.progressWidth = 5.0;        // Defaults to 5.0
    
    self.title =OTPTitleName;
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(lerCodigo)];
	self.navigationItem.rightBarButtonItem = refreshButton;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gerarSenha:(id)sender {
    
    NSDictionary * secretdict =[self getSecret];
    if (_hasKey) {
        [self showCounter];
        [self setContador];
        [self generatePIN:secretdict];
    }else{
        [self hideCounter];
    }
 
}

- (void)lerCodigo{
    QrCodeViewController *vc = [[QrCodeViewController alloc]initWithDelegate:self];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    [nvc.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void) setContador{
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
    self.viewCOunting.progress = interv.floatValue;
    
    self.viewCOunting.labelVCBlock = ^(KAProgressLabel *label) {
        
        NSString *desc;
        
        if (tempo - 1 == 0) {
            desc =[NSString stringWithFormat:@"%d sec", tempo + 29];
        }else{
            desc =[NSString stringWithFormat:@"%d sec", tempo -1];
        }
       
        
        label.text = desc;
    };


}




-(BOOL)generatePIN:(NSDictionary *)psecret
{
    NSString *secret = [psecret objectForKey:@"secret"];
    NSString *algorithmdata = [psecret objectForKey:@"algorithm"];
    algorithmdata = algorithmdata?algorithmdata:kOTPGeneratorSHA1Algorithm;
    NSString *pin;
    BOOL isvalid = NO;
    
    if (![secret isEqualToString:@""]&& secret) {
        NSData *secretData =  [NSData dataWithBase32String:secret];
        
        NSInteger digits = 6;
        NSInteger period = 30;
        //NSTimeInterval timestamp = [self.timestampLabel.text integerValue];
        
        //TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:kOTPGeneratorSHA1Algorithm digits:digits period:period];
        TOTPGenerator *generator = [[TOTPGenerator alloc] initWithSecret:secretData algorithm:algorithmdata digits:digits period:period];
        @try {
           pin = [generator generateOTPForDate:[NSDate date]];
            isvalid = YES;
        }
        @catch (NSException *exception) {
            isvalid = NO;
        }
        @finally {
            self.lblOTP.text = pin;
        }
        
        return isvalid;
        
    }else{
         return isvalid;
    }

}

-(void)responseQrcodeData:(NSString *)data{
    
    NSLog(@"%@",data);
    //NSData *uri = data;

    //NSString * secret = [[self otpURItoDictionary:data]objectForKey:OTPKeyValue];

    [self saveSecret:[self otpURItoDictionary:data]];
    

}

-(NSDictionary *) otpURItoDictionary:(NSString *)otpUrl{
    
    if (!otpUrl) {
        return nil;
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:otpUrl forKey:@"uri"];
    NSURL *url = [NSURL URLWithString:otpUrl];
    NSString *var = [url query];
    NSArray * array =[var componentsSeparatedByString:@"&"];
    for (NSString * dado in array) {
        NSArray *partDado = [dado componentsSeparatedByString:@"="];
        [dict setObject:partDado[1] forKey:partDado[0]];
    }
    
    return dict;
}

-(void) saveSecret:(NSDictionary *)secret{
    
    if ([self generatePIN:secret]) {
        NSLog(@"%@",[NSString stringWithFormat:@"Erroooo"]);
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erro" message:@"Codigo invalido" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[secret objectForKey:@"uri"] forKey:OTPKeyValue];
}


-(NSDictionary *)getSecret{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *data =[prefs stringForKey:OTPKeyValue];
    if (data) {
        _hasKey= YES;
    }else{
        _hasKey=NO;
    }
    
    return [self otpURItoDictionary:data];
}

-(void)showCounter{
    [_viewCOunting setHidden:NO];
    [_expireLabel setHidden:NO];
    [_btnCopiar setHidden:NO];
    
}

-(void)hideCounter{
    [_viewCOunting setHidden:YES];
    [_expireLabel setHidden:YES];
    [_btnCopiar setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
- (IBAction)copiarToken:(id)sender {
    [UIPasteboard generalPasteboard].string = _lblOTP.text;
    
    NSString *otpCopiado = [UIPasteboard generalPasteboard].string;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OTP-Test" message:[NSString stringWithFormat:@"Token %@ copiado",otpCopiado]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
