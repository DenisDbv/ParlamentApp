//
//  PMSettingsViewContoller.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMSettingsViewContoller.h"
#import "UIImage+UIImageFunctions.h"
#import <MZFormSheetController/MZFormSheetController.h>
#import "PMActivationView.h"

@interface PMSettingsViewContoller ()
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;
@end

@implementation PMSettingsViewContoller
{
    NSUserDefaults *userSettings;
}
@synthesize activationButtonsArray;

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
    
    userSettings = [NSUserDefaults standardUserDefaults];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *settingImage = [[UIImage imageNamed:@"settings-close.png"] scaleProportionalToRetina];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton addTarget:self action:@selector(onSettingClose:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    [self buttonsConfigure];
    [self buttonsReposition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onSettingClose:(UIButton*)btn
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
    
    //self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

-(void) buttonsConfigure
{
    // read from config
    
    activationButtonsArray = [[NSMutableArray alloc] init];
    
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eEye withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eVoice withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eSiluet withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eFinger withText:NO]];
    [activationButtonsArray addObject: [[PMActivationView alloc] initWithActivationID:eMonogram withText:NO]];
    
    [self activationsStatusRefresh];
}

-(void) activationsStatusRefresh
{
    for ( PMActivationView *button in activationButtonsArray )
    {
        NSString *activationName = [NSString stringWithFormat:@"%i", button.ids];
        BOOL activationStatus = [[userSettings objectForKey:activationName] boolValue];
        [button disableActivation:activationStatus];
    }
}

-(void) buttonsReposition
{
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
    NSString *activationName = [NSString stringWithFormat:@"%i", ids];
    BOOL activationStatus = [[userSettings objectForKey:activationName] boolValue];
    if(activationStatus == NO)  {
        [activationView disableActivation:YES];
    }
    else    {
        [activationView disableActivation:NO];
    }
    
    [userSettings setObject:[NSNumber numberWithBool:!activationStatus] forKey:activationName];
    [userSettings synchronize];
}

@end
