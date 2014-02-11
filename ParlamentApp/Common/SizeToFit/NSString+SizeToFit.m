//
//  NSString+SizeToFit.m
//  ParlamentApp
//
//  Created by DenisDbv on 10.02.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "NSString+SizeToFit.h"

@implementation NSString (SizeToFit)

-(CGSize) sizeToFitWithFont:(UIFont*)font
{
    UILabel *labelControl = [[UILabel alloc] initWithFrame:CGRectZero];
    labelControl.text = self;
    labelControl.font = font;
    labelControl.textColor = [UIColor redColor];
    labelControl.backgroundColor = [UIColor clearColor];
    labelControl.textAlignment = NSTextAlignmentCenter;
    labelControl.opaque = NO;
    [labelControl sizeToFit];
    
    labelControl.frame = CGRectMake(0, 0, labelControl.frame.size.width+500, labelControl.frame.size.height+100);
    
    UIGraphicsBeginImageContextWithOptions(labelControl.bounds.size, labelControl.opaque, 0.);
    [labelControl.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *labelImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData =  UIImagePNGRepresentation(labelImage);
    labelImage = [UIImage imageWithData:imageData];
    
    CGImageRef inImage = labelImage.CGImage;
    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int width = labelImage.size.width;
    int height = labelImage.size.height;
    
    CGPoint top,left,right,bottom;
    
    BOOL breakOut = NO;
    for (int x = 0;breakOut==NO && x < width; x++) {
        for (int y = 0; y < height; y++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0;breakOut==NO && y < height; y++) {
        
        for (int x = 0; x < width; x++) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int y = height-1;breakOut==NO && y >= 0; y--) {
        
        for (int x = width-1; x >= 0; x--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int x = width-1;breakOut==NO && x >= 0; x--) {
        
        for (int y = height-1; y >= 0; y--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    return CGSizeMake(right.x - left.x, bottom.y - top.y);
}

-(UIImage*) imageToFitWithFont:(UIFont*)font
{
    UILabel *labelControl = [[UILabel alloc] initWithFrame:CGRectZero];
    labelControl.text = self;
    labelControl.font = font;
    labelControl.textColor = [UIColor redColor];
    labelControl.backgroundColor = [UIColor clearColor];
    labelControl.textAlignment = NSTextAlignmentCenter;
    labelControl.opaque = NO;
    [labelControl sizeToFit];
    
    labelControl.frame = CGRectMake(0, 0, labelControl.frame.size.width+500, labelControl.frame.size.height+100);
    
    UIGraphicsBeginImageContextWithOptions(labelControl.bounds.size, labelControl.opaque, 0.);
    [labelControl.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *labelImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData =  UIImagePNGRepresentation(labelImage);
    labelImage = [UIImage imageWithData:imageData];
    
    CGImageRef inImage = labelImage.CGImage;
    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int width = labelImage.size.width;
    int height = labelImage.size.height;
    
    CGPoint top,left,right,bottom;
    
    BOOL breakOut = NO;
    for (int x = 0;breakOut==NO && x < width; x++) {
        for (int y = 0; y < height; y++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0;breakOut==NO && y < height; y++) {
        
        for (int x = 0; x < width; x++) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int y = height-1;breakOut==NO && y >= 0; y--) {
        
        for (int x = width-1; x >= 0; x--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int x = width-1;breakOut==NO && x >= 0; x--) {
        
        for (int y = height-1; y >= 0; y--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    CGFloat offset = 0.0f;
    CGRect cropRect = CGRectMake(left.x-offset, top.y-offset, (right.x - left.x)+offset, (bottom.y - top.y)+offset);
    
    UIGraphicsBeginImageContextWithOptions( cropRect.size, NO, 0.);
    [labelImage drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y) blendMode:kCGBlendModeCopy alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

-(UIImage*) imageToFit:(UIImage*)labelImage
{
    NSData* imageData =  UIImagePNGRepresentation(labelImage);
    labelImage = [UIImage imageWithData:imageData];
    
    CGImageRef inImage = labelImage.CGImage;
    CFDataRef m_DataRef;
    m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int width = labelImage.size.width;
    int height = labelImage.size.height;
    
    CGPoint top,left,right,bottom;
    
    BOOL breakOut = NO;
    for (int x = 0;breakOut==NO && x < width; x++) {
        for (int y = 0; y < height; y++) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0;breakOut==NO && y < height; y++) {
        
        for (int x = 0; x < width; x++) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int y = height-1;breakOut==NO && y >= 0; y--) {
        
        for (int x = width-1; x >= 0; x--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int x = width-1;breakOut==NO && x >= 0; x--) {
        
        for (int y = height-1; y >= 0; y--) {
            
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = CGPointMake(x, y);
                breakOut = YES;
                break;
            }
            
        }
    }
    
    
    CGRect cropRect = CGRectMake(left.x, top.y, right.x - left.x, bottom.y - top.y);
    
    UIGraphicsBeginImageContextWithOptions( cropRect.size, NO, 0.);
    [labelImage drawAtPoint:CGPointMake(-cropRect.origin.x, -cropRect.origin.y) blendMode:kCGBlendModeCopy alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

@end
