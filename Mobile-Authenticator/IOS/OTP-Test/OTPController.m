//
//  OTPController.m
//  OTP-Test
//
//  Created by PRODUBAN on 6/8/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import "OTPController.h"
#import "AppDelegate.h"

@implementation OTPController{

    
    
    
}
AppDelegate * appDelegate;
NSManagedObjectContext *context;
NSString *const OTP_SECRET=@"secret";
NSString *const OTP_CLIENTID=@"clientID";
NSString *const OTP_ISSUER=@"issuer";
NSString *const OTP_ALGORITHM=@"algorithm";
NSString *const OTP_ENTITYNAME=@"OTP";



- (id)init
{
    self = [super init];
    if (self) {
        appDelegate = [[UIApplication sharedApplication]delegate];
    }
    return self;
}

-(bool)saveOTP:(NSString *)otpURI{
    OTP *otp = [self setURItoOTP:otpURI];
    context = [appDelegate managedObjectContext];
    NSManagedObject *newOTP;
    newOTP = [NSEntityDescription
                  insertNewObjectForEntityForName:OTP_ENTITYNAME
                  inManagedObjectContext:context];
    
    [newOTP setValue:otp.secret forKey:OTP_SECRET];
    [newOTP setValue:otp.issuer forKey:OTP_ISSUER];
    [newOTP setValue:otp.clientId forKey:OTP_CLIENTID];
    [newOTP setValue:otp.algorithm forKey:OTP_ALGORITHM];
    
    NSError * error;
    [context save:&error];
    
    if (!error) {
        return YES;
    }
    
    return NO;
}

-(NSMutableArray *)getAllOTOP{
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    context = [appDelegate managedObjectContext];
    NSError * error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"OTP" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        //OTP *otp = [[OTP alloc]initWithClientID:[info valueForKey:OTP_CLIENTID] AndIssuer:OTP_ISSUER Algorith:OTP_ALGORITHM AndSecret:OTP_SECRET];
        
        [array addObject:info];
        
    }
    
    return array;
}

-(bool)deleteOTP:(NSManagedObject *)otp{
    context = [appDelegate managedObjectContext];
    [context deleteObject:otp];
    NSError *error;
    [context save:&error];
    
    return YES;
}

-(bool)updateOTP:(OTP *)otp{
    
    
    return nil;
}

-(OTP *)setURItoOTP:(NSString *)uriOtp{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    NSString *secret;
    NSString *clientID;
    NSString *algorithm;
    NSString *issuer;
    OTP *otp;
    NSURL *url = [NSURL URLWithString:uriOtp];
    NSString *var = [url query];
    NSArray * array =[var componentsSeparatedByString:@"&"];
    for (NSString * dado in array) {
        NSArray *partDado = [dado componentsSeparatedByString:@"="];
        [dict setObject:partDado[1] forKey:partDado[0]];
    }
    
    secret = [dict objectForKey:@"secret"];
    clientID = [[uriOtp stringByReplacingOccurrencesOfString:@"otpauth://totp/" withString:@""] componentsSeparatedByString:@"?"][0];
    algorithm = [dict objectForKey:@"algorithm"]?[dict objectForKey:@"algorithm"]:@"SHA1";
    issuer = [dict objectForKey:@"issuer"]?[dict objectForKey:@"issuer"]:@"";
    otp = [[OTP alloc]initWithClientID:clientID AndIssuer:issuer Algorith:algorithm AndSecret:secret];

    return otp;
}

@end
