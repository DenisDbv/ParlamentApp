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
    NSMutableDictionary *defaultsDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"me@example.com", @"fromEmail",
                                               @"denisdbv@gmail.com", @"toEmail",
                                               @"smtp.gmail.com", @"relayHost",
                                               @"denisdbv@gmail.com", @"login",
                                               @"gmailiamcool14", @"pass",
                                               [NSNumber numberWithBool:YES], @"requiresAuth",
                                               [NSNumber numberWithBool:YES], @"wantsSecure", nil];
    
    [userDefaults registerDefaults:defaultsDictionary];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateTextView {
    NSMutableString *logText = [[NSMutableString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [logText appendString:@"Use the iOS Settings app to change the values below.\n\n"];
    [logText appendFormat:@"From: %@\n", [defaults objectForKey:@"fromEmail"]];
    [logText appendFormat:@"To: %@\n", [defaults objectForKey:@"toEmail"]];
    [logText appendFormat:@"Host: %@\n", [defaults objectForKey:@"relayHost"]];
    [logText appendFormat:@"Auth: %@\n", ([[defaults objectForKey:@"requiresAuth"] boolValue] ? @"On" : @"Off")];
    
    if ([[defaults objectForKey:@"requiresAuth"] boolValue]) {
        [logText appendFormat:@"Login: %@\n", [defaults objectForKey:@"login"]];
        [logText appendFormat:@"Password: %@\n", [defaults objectForKey:@"pass"]];
    }
    [logText appendFormat:@"Secure: %@\n", [[defaults objectForKey:@"wantsSecure"] boolValue] ? @"Yes" : @"No"];
    
    NSLog(@"%@", logText);
}

-(void) sendMessageWithImage:(UIImage*)image imageName:(NSString*)imageName andText:(NSString*)text
{
    //[self updateTextView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"fromEmail"];
    
    NSString *_toEmail = [defaults objectForKey:@"_emailTO"];
    if(_toEmail.length == 0) _toEmail = @"denisdbv@gmail.com";
    
    testMsg.toEmail = _toEmail; //[defaults objectForKey:@"toEmail"];
    testMsg.bccEmail = [defaults objectForKey:@"bccEmal"];
    testMsg.relayHost = [defaults objectForKey:@"relayHost"];
    
    testMsg.requiresAuth = [[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth) {
        testMsg.login = [defaults objectForKey:@"login"];
        
        testMsg.pass = [defaults objectForKey:@"pass"];
    }
    
    testMsg.wantsSecure = [[defaults objectForKey:@"wantsSecure"] boolValue]; // smtp.gmail.com doesn't work without TLS!
    
    testMsg.subject = @"Активация от Parlament";
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
