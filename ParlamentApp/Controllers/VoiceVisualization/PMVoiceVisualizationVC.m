//
//  PMVoiceVisualizationVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMVoiceVisualizationVC.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"
#import <MZTimerLabel/MZTimerLabel.h>

@interface PMVoiceVisualizationVC ()

@end

@implementation PMVoiceVisualizationVC
{
    UIButton *closeButton;
    UIButton *saveButton;
    UIButton *resetButton;
    UIButton *settingButton;
    
    BOOL attractorIsFullView;
    
}
@synthesize attractorView;
@synthesize titleLabel1, titleLabel2, titleLabel3, titleLabel4;
@synthesize timerLabel;

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
    
    attractorIsFullView = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *closeImage = [[UIImage imageNamed:@"close-voice.png"] scaleProportionalToRetina];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(onVoiceClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton setImage:closeImage forState:UIControlStateHighlighted];
    closeButton.frame = CGRectMake(159.0, 313.0, closeImage.size.width, closeImage.size.height);
    [self.view addSubview:closeButton];
    
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"save-voice.png"] scaleProportionalToRetina];
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:self action:@selector(onVoiceSave:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [saveButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    saveButton.frame = CGRectMake(746.0, 313.0, saveVoiceImage.size.width, saveVoiceImage.size.height);
    [self.view addSubview:saveButton];
    
    UIImage *resetVoiceImage = [[UIImage imageNamed:@"reset-voice.png"] scaleProportionalToRetina];
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton addTarget:self action:@selector(onVoiceReset:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setImage:resetVoiceImage forState:UIControlStateNormal];
    [resetButton setImage:resetVoiceImage forState:UIControlStateHighlighted];
    resetButton.frame = CGRectMake(401.0, 605.0, resetVoiceImage.size.width, resetVoiceImage.size.height);
    [self.view addSubview:resetButton];
    
    UIImage *settingImage = [[UIImage imageNamed:@"settings-close.png"] scaleProportionalToRetina];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 0.0;
    [settingButton addTarget:self action:@selector(onSettingClose:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    titleLabel1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    
    titleLabel2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    
    titleLabel3.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    titleLabel3.backgroundColor = [UIColor clearColor];
    titleLabel3.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    
    titleLabel4.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
}

-(void) viewWillAppear:(BOOL)animated
{
    [attractorView initialization];
    
    MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:timerLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60*5];
    [timer setTimeFormat:@"mm:ss"];
    timerLabel.font = [UIFont systemFontOfSize:45.0f];
    timerLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        [self onVoiceClose:closeButton];
    }];
    [timer start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) onVoiceClose:(UIButton*)btn
{
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    
    [self unload];
    
    self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) unload
{
    [attractorView releaseView];
    [attractorView removeFromSuperview];
    attractorView = nil;
}

-(void) onVoiceSave:(UIButton*)btn
{
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    
    [attractorView snapShoting];
}

-(void) onVoiceReset:(UIButton*)btn
{
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
    
    [attractorView resetAttractors];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) attractorScaleValue:(CGFloat)scale
{
    if(scale > 1.3 && !attractorIsFullView)
    {
        attractorIsFullView = YES;
        [self attractorViewToFullScreen];
    }
}

-(void) attractorViewToFullScreen
{
    [UIView animateWithDuration:0.3f animations:^{
        attractorView.frame = self.view.bounds;
        attractorView.scale = 1.0;
        attractorView.lastScale = 1.0;
        closeButton.alpha = 0.0;
        saveButton.alpha = 0.0;
        resetButton.alpha = 0.0;
        titleLabel1.alpha = titleLabel2.alpha = titleLabel3.alpha = titleLabel4.alpha = 0.0;
        timerLabel.alpha = 0.0;
        settingButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) onSettingClose:(UIButton*)button
{
    attractorIsFullView = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        attractorView.frame = CGRectMake(385.0, 245.0, 255.0, 255.0);
        attractorView.scale = 1.0;
        attractorView.lastScale = 1.0;
        closeButton.alpha = 1.0;
        saveButton.alpha = 1.0;
        resetButton.alpha = 1.0;
        titleLabel1.alpha = titleLabel2.alpha = titleLabel3.alpha = titleLabel4.alpha = 1.0;
        timerLabel.alpha = 1.0;
        settingButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
