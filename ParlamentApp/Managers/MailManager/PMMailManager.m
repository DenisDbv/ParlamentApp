//
//  PMMailManager.m
//  ParlamentApp
//
//  Created by DenisDbv on 17.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMMailManager.h"
#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface PMMailManager() <UIApplicationDelegate, SKPSMTPMessageDelegate>
@property (nonatomic, strong) SKPSMTPMessage *testMsg;
@end

@implementation PMMailManager
@synthesize testMsg;

+ (void)initialize {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *_emailFrom = [userDefaults objectForKey:@"_emailFROM"];
    NSString *_smtpFrom = [userDefaults objectForKey:@"_smtpFROM"];
    NSString *_passwordFrom = [userDefaults objectForKey:@"_passwordFROM"];
    
    NSString *_emailTo = [userDefaults objectForKey:@"_emailTO"];
    
    NSString *_operatorEmail = [userDefaults objectForKey:@"_operatorEmail"];
    NSString *_emailPhotoPersonTo = [userDefaults objectForKey:@"_emailPhotoPersonTo"];
    
    if(_emailFrom.length == 0 || _smtpFrom.length == 0 || _passwordFrom.length == 0)
    {
        _emailFrom = @"art.individuality@gmail.com";
        _smtpFrom = @"smtp.gmail.com";
        _passwordFrom = @"QazWsx1234";
        [userDefaults setObject:_emailFrom forKey:@"_emailFROM"];
        [userDefaults setObject:_smtpFrom forKey:@"_smtpFROM"];
        [userDefaults setObject:_passwordFrom forKey:@"_passwordFROM"];
    }
    
    if(_emailTo.length == 0)
    {
        _emailTo = @"denisdbv@gmail.com";
        [userDefaults setObject:_emailTo forKey:@"_emailTO"];
    }
    
    if(_operatorEmail.length == 0)
    {
        _operatorEmail = @"denisdbv@gmail.com";
        [userDefaults setObject:_operatorEmail forKey:@"_operatorEmail"];
    }
    
    if(_emailPhotoPersonTo.length == 0)
    {
        _emailPhotoPersonTo = @"denisdbv@gmail.com";
        [userDefaults setObject:_emailPhotoPersonTo forKey:@"_emailPhotoPersonTo"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) sendMessageWithImage:(UIImage*)image imageName:(NSString*)imageName andText:(NSString*)text
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"_emailFROM"];
    
    //NSString *_toEmail = [defaults objectForKey:@"_emailTO"];
    //if(_toEmail.length == 0) _toEmail = @"denisdbv@gmail.com";
    
    testMsg.toEmail = [defaults objectForKey:@"_emailTO"]; //[defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"_smtpFROM"];
    testMsg.requiresAuth = YES; //[[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"_emailFROM"];
        
        testMsg.pass = [defaults objectForKey:@"_passwordFROM"];
    }
    
    testMsg.wantsSecure = YES; //[[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!
    
    testMsg.subject = @"Активация от Art of Individuality";
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"text/plain",kSKPSMTPPartContentTypeKey,
                                                   text,kSKPSMTPPartMessageKey,@"8bit",
                                                   kSKPSMTPPartContentTransferEncodingKey,nil];
    
    //NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
    NSData *vcfData = UIImagePNGRepresentation(image); //[NSData dataWithContentsOfFile:vcfPath];
    
    NSString *contentTypeString = [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"", imageName];
    NSString *contentDispositionString = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"", imageName];
    
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:
                             contentTypeString,kSKPSMTPPartContentTypeKey,
                             contentDispositionString,kSKPSMTPPartContentDispositionKey,
                             [vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,
                             @"base64",kSKPSMTPPartContentTransferEncodingKey, nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testMsg send];
    });
}

-(void) sendMessageWithImage:(UIImage*)image imageName:(NSString*)imageName andTitle:(NSString*)title andText:(NSString*)text
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"_emailFROM"];
    
    //NSString *_toEmail = [defaults objectForKey:@"_emailTO"];
    //if(_toEmail.length == 0) _toEmail = @"denisdbv@gmail.com";
    
    testMsg.toEmail = [defaults objectForKey:@"_emailTO"]; //[defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"_smtpFROM"];
    testMsg.requiresAuth = YES; //[[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"_emailFROM"];
        
        testMsg.pass = [defaults objectForKey:@"_passwordFROM"];
    }
    
    testMsg.wantsSecure = YES; //[[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!
    
    testMsg.subject = title;
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"text/plain",kSKPSMTPPartContentTypeKey,
                               text,kSKPSMTPPartMessageKey,@"8bit",
                               kSKPSMTPPartContentTransferEncodingKey,nil];
    
    //NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
    NSData *vcfData = UIImagePNGRepresentation(image); //[NSData dataWithContentsOfFile:vcfPath];
    
    NSString *contentTypeString = [NSString stringWithFormat:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@\"", imageName];
    NSString *contentDispositionString = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@\"", imageName];
    
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:
                             contentTypeString,kSKPSMTPPartContentTypeKey,
                             contentDispositionString,kSKPSMTPPartContentDispositionKey,
                             [vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,
                             @"base64",kSKPSMTPPartContentTransferEncodingKey, nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testMsg send];
    });
}

-(void) sendMessageToPhotoPersonWithSubject:(NSString*)subject andDesc:(NSString*)desc
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"_emailFROM"];
    
    //NSString *_toEmail = [defaults objectForKey:@"_emailTO"];
    //if(_toEmail.length == 0) _toEmail = @"denisdbv@gmail.com";
    
    testMsg.toEmail = [defaults objectForKey:@"_emailPhotoPersonTo"]; //[defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"_smtpFROM"];
    testMsg.requiresAuth = YES; //[[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"_emailFROM"];
        
        testMsg.pass = [defaults objectForKey:@"_passwordFROM"];
    }
    
    testMsg.wantsSecure = YES; //[[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!
    
    testMsg.subject = subject;
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"text/plain",kSKPSMTPPartContentTypeKey,
                               desc,kSKPSMTPPartMessageKey,@"8bit",
                               kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testMsg send];
    });
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"SEND!");

    if([self.delegate respondsToSelector:@selector(mailSendSuccessfully)])
    {
        [self.delegate mailSendSuccessfully];
    }
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
    
    if([self.delegate respondsToSelector:@selector(mailSendFailed)])
    {
        [self.delegate mailSendFailed];
    }
}
@end
