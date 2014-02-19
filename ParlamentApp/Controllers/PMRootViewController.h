//
//  PMRootViewController.h
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleViewController.h"

@interface PMRootViewController : RippleViewController //UIViewController //

-(void) closeRegistrationAndOpenApp;
-(void) closeAppAndOpenRegistration;

//-(void) myTouchWithPoint:(CGPoint)point;
//-(void) touchByLocation:(CGPoint)location;

@end
