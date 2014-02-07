//
//  UIView+Screenshot.m
//  ParlamentApp
//
//  Created by DenisDbv on 04.02.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage*)imageRepresentation {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
    
    /* iOS 7 */
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    else /* iOS 6 */
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return ret;
    
}

@end
