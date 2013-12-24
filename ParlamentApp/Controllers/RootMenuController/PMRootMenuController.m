//
//  PMRootMenuController.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMRootMenuController.h"

#import "PMSettingsViewContoller.h"
#import "PMVoiceVisualizationVC.h"
#import "PMMonogramVC.h"
#import "PMFingerVC.h"
#import "PMSiluetVC.h"
#import "PMEyeVC.h"
#import "PMRegistrationVC.h"

#import "UIView+GestureBlocks.h"
#import "UIImage+UIImageFunctions.h"

#define SCREEN_MARGIN   130.0f/2
#define BUTTON_MARGIN   90.0f/2

@interface PMRootMenuController ()
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;
@end

@implementation PMRootMenuController
{
    BOOL secret_doubleTap;
    BOOL secret_disable;
    
    UIButton *settingButton;
}
@synthesize activationButtonsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    secret_doubleTap = NO;
    secret_disable = NO;
    
    [self buttonsConfigure];
    [self buttonsReposition];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap2:)];
    tapGesture2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap1:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture1];

    [tapGesture1 requireGestureRecognizerToFail:tapGesture2];
}

- (void)handleTap1:(UIGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:sender.view];
    if(coords.x > self.view.frame.size.width-100 && coords.y > self.view.frame.size.height-100)    {
        //NSLog(@"!%@", NSStringFromCGPoint(coords));
        if(secret_doubleTap == YES) {
            NSLog(@"Show settings secret button");
            
            secret_disable = YES;
            
            /*UIImage *settingImage = [[UIImage imageNamed:@"settings.png"] scaleProportionalToRetina];
            [settingButton removeTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
            [settingButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
            [settingButton setImage:settingImage forState:UIControlStateNormal];
            [settingButton setImage:settingImage forState:UIControlStateHighlighted];*/
            
            [UIView animateWithDuration:0.3f animations:^{
                //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:settingButton cache:NO];
                settingButton.alpha = 1.0;
            } completion:^(BOOL finished) {
                int64_t delayInSeconds = 3.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    /*UIImage *settingImage = [[UIImage imageNamed:@"exit.png"] scaleProportionalToRetina];
                    [settingButton removeTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
                    [settingButton addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
                    [settingButton setImage:settingImage forState:UIControlStateNormal];
                    [settingButton setImage:settingImage forState:UIControlStateHighlighted];*/
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:settingButton cache:NO];
                        settingButton.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        secret_disable = NO;
                    }];
                });
            }];
        }
    }
}

- (void)handleTap2:(UIGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:sender.view];
    if(coords.x < 100 && coords.y < 100)    {
        //NSLog(@"%@", NSStringFromCGPoint(coords));
        
        if(!secret_disable) {
            secret_doubleTap = YES;
            
            int64_t delayInSeconds = 1.6;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                secret_doubleTap = NO;
                    });
        }
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"ВЫБЕРИТЕ АКТИВАЦИЮ";
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(400,
                                   209,
                                   titleLabel.frame.size.width,
                                   titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *settingImage = [[UIImage imageNamed:@"settings.png"] scaleProportionalToRetina];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 0.0f;
    [settingButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onExit:(UIButton*)button
{
    //CGPoint location = button.center;
    //[[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    [UIView animateWithDuration:0.03 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.03f animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [[AppDelegateInstance() rippleViewController] closeAppAndOpenRegistration];
                         }];
                     }];
}

-(void) onSetting:(UIButton*)btn
{
    //CGPoint location = btn.center;
    //[[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    [UIView animateWithDuration:0.03 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.03f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self hideAllContext];
                             
                             PMSettingsViewContoller *settingVC = [[PMSettingsViewContoller alloc] initWithNibName:@"PMSettingsViewContoller" bundle:[NSBundle mainBundle]];
                             MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:settingVC];
                             formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
                             __weak id wself = self;
                             formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
                                 [wself buttonsConfigure];
                                 [wself buttonsReposition];
                                 [wself showAllContext];
                             };
                             [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                                 
                             }];
                         }];
                     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) hideAllContext
{
    self.view.alpha = 0.0;
}

-(void) showAllContext
{
    self.view.alpha = 1.0;
}

-(void) buttonsConfigure
{
    // read from config
    
    if(activationButtonsArray.count != 0)   {
        for ( PMActivationView *button in activationButtonsArray )
        {
            [button removeFromSuperview];
        }
    }
    
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eEye withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eVoice withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eSiluet withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eFinger withText:YES]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eMonogram withText:YES]];
    
    [self activationsStatusRefresh];
}

-(void) activationsStatusRefresh
{
    NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempBuffer = [[NSMutableArray alloc] init];
    
    for ( PMActivationView *button in activationButtonsArray )
    {
        NSString *activationName = [NSString stringWithFormat:@"%i", button.ids];
        BOOL activationStatusDisable = [[userSettings objectForKey:activationName] boolValue];
        if(activationStatusDisable)
           [tempBuffer addObject:button];
    }
    
    [activationButtonsArray removeObjectsInArray:tempBuffer];
}

-(void) buttonsReposition
{
    if(activationButtonsArray.count == 0) return;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    NSInteger buttonCount = activationButtonsArray.count;
    PMActivationView *actButton = [activationButtonsArray objectAtIndex:0];
    
    NSInteger offsetPx = (screenWidth - actButton.frame.size.width*buttonCount) / (buttonCount+1);
    NSInteger indexSpace = 1;
    NSInteger indexButton = 0;
    
    for ( PMActivationView *button in activationButtonsArray )
    {
        button.delegate = self;
        button.frame = CGRectOffset(button.frame, (offsetPx * indexSpace) + (actButton.frame.size.width * indexButton), 277);
        [self.view addSubview:button];
        ++indexSpace;
        ++indexButton;
    }
}

-(void) activationView:(PMActivationView*)activationView didSelectWithID:(ActivationIDs)ids
{
    /*switch (ids) {
        case eEye:
            [self showEyeViewController];
            break;
        case eVoice:
            [self showVoiceViewController];
            break;
        case eSiluet:
            [self showSiluetViewController];
            break;
        case eFinger:
            [self showFingerViewController];
            break;
        case eMonogram:
            [self showMonogramViewController];
            break;
            
        default:
            break;
    }*/
    
    [self openRegistrationForm:ids];
}

-(void) openRegistrationForm:(ActivationIDs)ids
{
    [self hideAllContext];
    
    PMRegistrationVC *rootMenuViewController = [[PMRegistrationVC alloc] initWithNibName:@"PMRegistrationVC" bundle:[NSBundle mainBundle]];
    
    MZFormSheetController *registraionSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:rootMenuViewController];
    
    __weak id wself = self;
    registraionSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        PMRegistrationVC *regVC = (PMRegistrationVC*)presentedFSViewController;
        if(regVC.isExitToMenu)  {
            [wself showAllContext];
        }
        else
        {
            switch (ids) {
                case eEye:
                    [self showEyeViewController];
                    break;
                case eVoice:
                    [self showVoiceViewController];
                    break;
                case eSiluet:
                    [self showSiluetViewController];
                    break;
                case eFinger:
                    [self showFingerViewController];
                    break;
                case eMonogram:
                    [self showMonogramViewController];
                    break;
                    
                default:
                    break;
            }
        }
    };
        
    [registraionSheet presentFormSheetController:registraionSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Registartion view controller present");
    }];
}

-(void) showVoiceViewController
{
    //[self hideAllContext];
    
    PMVoiceVisualizationVC *voiceVC = [[PMVoiceVisualizationVC alloc] initWithNibName:@"PMVoiceVisualizationVC" bundle:[NSBundle mainBundle]];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:voiceVC];
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    __weak id wself = self;
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        [wself showAllContext];
    };
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) showMonogramViewController
{
    //[self hideAllContext];
    
    PMMonogramVC *monogramVC = [[PMMonogramVC alloc] initWithNibName:@"PMMonogramVC" bundle:[NSBundle mainBundle]];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size
                                                                    viewController:[[UINavigationController alloc] initWithRootViewController:monogramVC]];
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    __weak id wself = self;
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        [wself showAllContext];
    };
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) showFingerViewController
{
    //[self hideAllContext];
    
    PMFingerVC *fingerVC = [[PMFingerVC alloc] initWithNibName:@"PMFingerVC" bundle:[NSBundle mainBundle]];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:fingerVC];
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    __weak id wself = self;
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        [wself showAllContext];
    };
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) showSiluetViewController
{
    //[self hideAllContext];
    
    PMSiluetVC *siluetVC = [[PMSiluetVC alloc] initWithNibName:@"PMSiluetVC" bundle:[NSBundle mainBundle]];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:siluetVC];
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    __weak id wself = self;
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        [wself showAllContext];
    };
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(void) showEyeViewController
{
    //[self hideAllContext];
    
    PMEyeVC *eyeVC = [[PMEyeVC alloc] initWithNibName:@"PMEyeVC" bundle:[NSBundle mainBundle]];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:eyeVC];
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    __weak id wself = self;
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        [wself showAllContext];
    };
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

@end

