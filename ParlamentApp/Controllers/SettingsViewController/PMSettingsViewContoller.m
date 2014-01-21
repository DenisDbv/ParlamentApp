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
#import <SVSegmentedControl/SVSegmentedControl.h>
#import <MBSwitch/MBSwitch.h>
#import "PMRegistrationFieldView.h"
#import "UIImage+UIImageFunctions.h"

@interface PMSettingsViewContoller ()
@property (nonatomic, strong) NSMutableArray *activationButtonsArray;

@property (strong, nonatomic) IBOutlet UIView *registrationFormView;
@property (strong, nonatomic) IBOutlet MBSwitch *regValueSwitcher;
@property (strong, nonatomic) IBOutlet UILabel *regTitleLeft;
@property (strong, nonatomic) IBOutlet UILabel *regTitleRight;

@property (strong, nonatomic) IBOutlet UIView *emailFormView;
@property (strong, nonatomic) IBOutlet UILabel *emailTitleLeft;
@property (strong, nonatomic) IBOutlet UILabel *emailTitleRight;
@end

@implementation PMSettingsViewContoller
{
    NSUserDefaults *userSettings;
    
    SVSegmentedControl *navSC;
    PMRegistrationFieldView *emailFromView;
    PMRegistrationFieldView *smtpFromView;
    PMRegistrationFieldView *passwordFromView;
    PMRegistrationFieldView *emailToView;
    PMRegistrationFieldView *emailPhotoPersonView;
}
@synthesize activationButtonsArray;
@synthesize registrationFormView, regValueSwitcher, regTitleLeft, regTitleRight;
@synthesize emailFormView, emailTitleLeft, emailTitleRight;

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
    
    navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Механики", @"Регистрация", @"Сеть", nil]];
    navSC.thumb.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1];
    navSC.height = 46;
    navSC.changeHandler = ^(NSUInteger newIndex) {
        [self changeSwitchValue:newIndex];
    };
    navSC.frame = CGRectOffset(navSC.frame, self.view.center.x, self.view.frame.size.height - 80);
    [self.view addSubview:navSC];
    
    BOOL shortRegForm = [[userSettings objectForKey:@"ShortRegForm"] boolValue];
    [regValueSwitcher setOnTintColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f]];
    [regValueSwitcher setTintColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f]];
    [regValueSwitcher setOn:shortRegForm];
    
    regTitleLeft.font = [UIFont fontWithName:@"MyriadPro-Cond" size:25.0];
    regTitleLeft.backgroundColor = [UIColor clearColor];
    regTitleLeft.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    regTitleLeft.textAlignment = NSTextAlignmentCenter;
    regTitleRight.font = [UIFont fontWithName:@"MyriadPro-Cond" size:25.0];
    regTitleRight.backgroundColor = [UIColor clearColor];
    regTitleRight.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    regTitleRight.textAlignment = NSTextAlignmentCenter;

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
    
    [self emailFormConfigure];
    
    [self registrationFormShow:NO];
    [self emailFormShow:NO];
}

-(void) setDefaultSetting
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *_emailFrom = [userDefaults objectForKey:@"_emailFROM"];
    NSString *_smtpFrom = [userDefaults objectForKey:@"_smtpFROM"];
    NSString *_passwordFrom = [userDefaults objectForKey:@"_passwordFROM"];
    
    NSString *_emailTo = [userDefaults objectForKey:@"_emailTO"];
    
    NSString *_operatorEmail = [userDefaults objectForKey:@"_operatorEmail"];
    NSString *_emailPhotoPersonTo = [userDefaults objectForKey:@"_emailPhotoPersonTo"];
    
    if(_emailFrom.length == 0 || _smtpFrom.length == 0 || _passwordFrom.length == 0)
    {
        _emailFrom = @"art.individuality@gmail.com";
        _smtpFrom = @"smtp.gmail.com";
        _passwordFrom = @"QazWsx1234";
        [userDefaults setObject:_emailFrom forKey:@"_emailFROM"];
        [userDefaults setObject:_smtpFrom forKey:@"_smtpFROM"];
        [userDefaults setObject:_passwordFrom forKey:@"_passwordFROM"];
    }
    
    if(_emailTo.length == 0)
    {
        _emailTo = @"denisdbv@gmail.com";
        [userDefaults setObject:_emailTo forKey:@"_emailTO"];
    }
    
    if(_operatorEmail.length == 0)
    {
        _operatorEmail = @"denisdbv@gmail.com";
        [userDefaults setObject:_operatorEmail forKey:@"_operatorEmail"];
    }
    
    if(_emailPhotoPersonTo.length == 0)
    {
        _emailPhotoPersonTo = @"denisdbv@gmail.com";
        [userDefaults setObject:_emailPhotoPersonTo forKey:@"_emailPhotoPersonTo"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    emailFromView.titleField.text = _emailFrom;
    smtpFromView.titleField.text = _smtpFrom;
    passwordFromView.titleField.text = _passwordFrom;
    emailToView.titleField.text = _operatorEmail;
    emailPhotoPersonView.titleField.text = _emailPhotoPersonTo;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setDefaultSetting];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onSettingClose:(UIButton*)btn
{
    [self saveSettings];
    
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

-(void) saveSettings
{
    [userSettings setObject:[NSNumber numberWithBool:regValueSwitcher.on] forKey:@"ShortRegForm"];
    
    [userSettings setObject:emailFromView.titleField.text forKey:@"_emailFROM"];
    [userSettings setObject:smtpFromView.titleField.text forKey:@"_smtpFROM"];
    [userSettings setObject:passwordFromView.titleField.text forKey:@"_passwordFROM"];
    
    [userSettings setObject:emailToView.titleField.text forKey:@"_operatorEmail"];
    [userSettings setObject:emailPhotoPersonView.titleField.text forKey:@"_emailPhotoPersonTo"];
    
    [userSettings synchronize];
}

-(void) changeSwitchValue:(NSInteger)newIndex
{
    if(newIndex == 0)   {
        [self activationButtonShow:YES];
        [self registrationFormShow:NO];
        [self emailFormShow:NO];
    }
    else if(newIndex == 1)  {
        [self activationButtonShow:NO];
        [self registrationFormShow:YES];
        [self emailFormShow:NO];
    }
    else if(newIndex == 2)  {
        [self activationButtonShow:NO];
        [self registrationFormShow:NO];
        [self emailFormShow:YES];
    }
}

-(void) emailFormConfigure
{
    UIImage *seperateImage = [[UIImage imageNamed:@"seperate.png"] scaleProportionalToRetina];
    UIImageView *seperateImageView = [[UIImageView alloc] initWithImage:seperateImage];
    seperateImageView.center = emailFormView.center;
    [emailFormView addSubview:seperateImageView];
    
    PMCustomKeyboard *customKeyboard1 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard2 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard3 = [[PMCustomKeyboard alloc] init];
    emailFromView = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"" subTitle:@"EMAIL ОТПРАВИТЕЛЯ" withType:nil];
    [customKeyboard1 setTextView:emailFromView.titleField];
    smtpFromView = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"" subTitle:@"SMTP СЕРВЕР" withType:nil];
    [customKeyboard2 setTextView:smtpFromView.titleField];
    passwordFromView = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"" subTitle:@"ПАРОЛЬ ОТ EMAIL" withType:nil];
    [customKeyboard3 setTextView:passwordFromView.titleField];
    
    [emailFormView addSubview:emailFromView];
    [emailFormView addSubview:smtpFromView];
    [emailFormView addSubview:passwordFromView];
    
    emailFromView.frame = CGRectOffset(emailFromView.frame, 150, 250);
    smtpFromView.frame = CGRectOffset(smtpFromView.frame, 150, emailFromView.frame.origin.y+emailFromView.frame.size.height+10);
    passwordFromView.frame = CGRectOffset(passwordFromView.frame, 150, smtpFromView.frame.origin.y+smtpFromView.frame.size.height+10);
    
    PMCustomKeyboard *customKeyboard4 = [[PMCustomKeyboard alloc] init];
    emailToView = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"" subTitle:@"EMAIL ОПЕРАТОРА" withType:nil];
    [customKeyboard4 setTextView:emailToView.titleField];
    [emailFormView addSubview:emailToView];
    emailToView.frame = CGRectOffset(emailToView.frame, 650, 250.0); //emailFormView.center.y-(emailToView.frame.size.height/2));
    
    PMCustomKeyboard *customKeyboard5 = [[PMCustomKeyboard alloc] init];
    emailPhotoPersonView = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"" subTitle:@"EMAIL ФОТОГРАФА" withType:nil];
    [customKeyboard5 setTextView:emailPhotoPersonView.titleField];
    [emailFormView addSubview:emailPhotoPersonView];
    emailPhotoPersonView.frame = CGRectOffset(emailPhotoPersonView.frame, 650, emailFormView.center.y-(emailPhotoPersonView.frame.size.height/2));
    
    emailTitleLeft.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    emailTitleLeft.backgroundColor = [UIColor clearColor];
    emailTitleLeft.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    emailTitleLeft.textAlignment = NSTextAlignmentCenter;
    
    emailTitleRight.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    emailTitleRight.backgroundColor = [UIColor clearColor];
    emailTitleRight.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    emailTitleRight.textAlignment = NSTextAlignmentCenter;
}

-(void) emailFormShow:(BOOL)isShow
{
    if(isShow)
    {
        emailFormView.alpha = 1;
    }
    else    {
        emailFormView.alpha = 0;
    }
}

-(void) registrationFormShow:(BOOL)isShow
{
    if(isShow)
    {
        registrationFormView.alpha = 1;
    }
    else    {
        registrationFormView.alpha = 0;
    }
}

-(void) activationButtonShow:(BOOL)isShow
{
    if(isShow)
    {
        for ( PMActivationView *button in activationButtonsArray )
        {
            button.alpha = 1;
        }
    }
    else    {
        for ( PMActivationView *button in activationButtonsArray )
        {
            button.alpha = 0;
        }
    }
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

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = [self.view convertRect:rect fromView:nil].size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        navSC.alpha = 0;
        emailFormView.frame = CGRectOffset(self.view.frame, 0, -100);
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        navSC.alpha = 1;
        emailFormView.frame = CGRectMake(0, 0, emailFormView.frame.size.width, emailFormView.frame.size.height);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

@end
