//
//  PMFingerVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 10.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMFingerVC.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"

@interface PMFingerVC ()

@end

@implementation PMFingerVC
{
    UILabel *scanelAccessDeniedLabel;
}
@synthesize titleLabel;

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
    
    self.navigationController.navigationBarHidden = YES;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:23.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self showScanerAccessDenied];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showScanerAccessDenied
{
    scanelAccessDeniedLabel = [[UILabel alloc] init];
    scanelAccessDeniedLabel.text = @"СКАНЕР НЕ ПОДКЛЮЧЕН";
    scanelAccessDeniedLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:45.0];
    scanelAccessDeniedLabel.backgroundColor = [UIColor clearColor];
    scanelAccessDeniedLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    scanelAccessDeniedLabel.textAlignment = NSTextAlignmentCenter;
    [scanelAccessDeniedLabel sizeToFit];
    [self.view addSubview:scanelAccessDeniedLabel];
    
    scanelAccessDeniedLabel.center = self.view.center;
    
    UIImage *settingImage = [[UIImage imageNamed:@"close-voice.png"] scaleProportionalToRetina];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateHighlighted];
    closeBtn.frame = CGRectMake(self.view.center.x-settingImage.size.width/2, self.view.center.y + 60, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:closeBtn];
}

-(void) onClose:(UIButton*)sender
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
                             if(IS_OS_7_OR_LATER)   {
                                 self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                                 [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                     
                                 }];
                             } else {
                                 [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                     formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                                 }];
                             }
                         }];
                     }];
}

@end
