//
//  NSString+Enc.m
//  ParlamentApp
//
//  Created by DenisDbv on 23.01.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "NSString+Enc.h"

@implementation NSString (Enc)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

@end
