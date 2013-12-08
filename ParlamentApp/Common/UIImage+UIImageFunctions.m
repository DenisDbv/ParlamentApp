//
//  UIImage+UIImageFunctions.m
//  AvtomarketApp
//
//  Created by DenisDbv on 08.11.13.
//  Copyright (c) 2013 axbx. All rights reserved.
//

#import "UIImage+UIImageFunctions.h"

@implementation UIImage (UIImageFunctions)

- (UIImage *) scaleProportionalToRetina
{
    return [UIImage imageWithCGImage:[self CGImage]
                               scale:(self.scale * 2.0)
                         orientation:(self.imageOrientation)];
}

@end
