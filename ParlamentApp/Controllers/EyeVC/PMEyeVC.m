//
//  PMEyeVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 19.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMEyeVC.h"

@interface PMEyeVC ()

@end

@implementation PMEyeVC
@synthesize titleLabel1, titleLabel2;

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
    
    titleLabel1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    titleLabel2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:60.0];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(UIButton*)sender
{
    CGPoint location = sender.center;
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    [UIView animateWithDuration:0.05 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             sender.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                             [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                 //
                             }];
                         }];
                     }];
}
@end
