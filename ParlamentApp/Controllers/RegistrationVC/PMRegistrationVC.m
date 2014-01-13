//
//  PMRegistrationVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMRegistrationVC.h"
#import "PMRegistrationFieldView.h"
#import "PMCustomKeyboard.h"
#import "MBPopoverBackgroundView.h"
#import "PMDatePickerVCViewController.h"
#import "PMSexChooseVC.h"
#import "UIView+GestureBlocks.h"
#import "UIImage+UIImageFunctions.h"
#import "PMSettingsViewContoller.h"

@interface PMRegistrationVC () <PMRegistrationFieldViewDelegate, PMDatePickerVCViewControllerDelegate>

@end

@implementation PMRegistrationVC
{
    BOOL shortRegForm;
    
    PMRegistrationFieldView *nameField;
    PMRegistrationFieldView *secondNameField;
    PMRegistrationFieldView *sexField;
    PMRegistrationFieldView *phoneField;
    PMRegistrationFieldView *emailField;
    PMRegistrationFieldView *dateBirthField;
    
    NSArray *fieldsArray;
    
    UIPopoverController *popoverControllerForDate;
    UIPopoverController *popoverControllerForSex;
    PMDatePickerVCViewController *popoverContent;
    PMSexChooseVC *sexVC;
    
    BOOL secret_doubleTap;
    BOOL secret_disable;
    UIButton *settingButton;
    
    NSDate *selectedBirthDate;
}
@synthesize tableView;
@synthesize continueButton;
@synthesize isExitToMenu;

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
        
    PMCustomKeyboard *customKeyboard = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard2 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard3 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard4 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard5 = [[PMCustomKeyboard alloc] init];
    PMCustomKeyboard *customKeyboard6 = [[PMCustomKeyboard alloc] init];
    
    nameField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ИМЯ" subTitle:@"ПРИМЕР: ИВАН" withType:nil];
    [customKeyboard setTextView:nameField.titleField];
    
    secondNameField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ФАМИЛИЯ" subTitle:@"ПРИМЕР: ИВАНОВ" withType:nil];
    [customKeyboard2 setTextView:secondNameField.titleField];
    
    sexField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ПОЛ" subTitle:@"ПРИМЕР: МУЖСКОЙ" withType:kNoKeyboard];
    sexField.delegate = self;
    [customKeyboard3 setTextView:sexField.titleField];
    
    phoneField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ТЕЛЕФОН" subTitle:@"ПРИМЕР: +79005432121" withType:kPhoneField];
    [customKeyboard4 setTextView:phoneField.titleField];
    
    emailField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"E-MAIL" subTitle:@"ПРИМЕР: IVAN@MAIL.RU" withType:nil];
    [customKeyboard5 setTextView:emailField.titleField];
    
    dateBirthField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ДАТА РОЖДЕНИЯ" subTitle:@"ПРИМЕР: 14 МАРТА 1987" withType:kNoKeyboard];
    dateBirthField.delegate = self;
    [customKeyboard6 setTextView:dateBirthField.titleField];
    
    fieldsArray = @[nameField, secondNameField, sexField, phoneField, emailField, dateBirthField];

    tableView.scrollEnabled = NO;
    
    popoverContent = [[PMDatePickerVCViewController alloc] initWithNibName:@"PMDatePickerVCViewController"
                                                                                                  bundle:[NSBundle mainBundle]];
    popoverContent.delegate = self;
    popoverControllerForDate = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverControllerForDate.popoverBackgroundViewClass = [MBPopoverBackgroundView class];
    popoverControllerForDate.popoverContentSize = CGSizeMake(393, 265);
    
    sexVC = [[PMSexChooseVC alloc] initWithNibName:@"PMSexChooseVC"
                                                                    bundle:[NSBundle mainBundle]];
    sexVC.delegate = self;
    popoverControllerForSex = [[UIPopoverController alloc] initWithContentViewController:sexVC];
    popoverControllerForSex.popoverBackgroundViewClass = [MBPopoverBackgroundView class];
    popoverControllerForSex.popoverContentSize = sexVC.view.frame.size;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *settingImage = [[UIImage imageNamed:@"exit.png"] scaleProportionalToRetina];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 1.0f;
    [settingButton addTarget:self action:@selector(onExit:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    //settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);    //right side
    settingButton.frame = CGRectMake(10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    /*UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap2:)];
    tapGesture2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture2];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap1:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture1];
    [tapGesture1 requireGestureRecognizerToFail:tapGesture2];*/
    
    [self registrationFormRefresh];
}

- (void)handleTap1:(UIGestureRecognizer *)sender
{
    CGPoint coords = [sender locationInView:sender.view];
    if(coords.x > self.view.frame.size.width-100 && coords.y > self.view.frame.size.height-100)    {
        //NSLog(@"!%@", NSStringFromCGPoint(coords));
        if(secret_doubleTap == YES) {
            NSLog(@"Show settings secret button");
            
            secret_disable = YES;
            
            [UIView animateWithDuration:0.3f animations:^{
                settingButton.alpha = 1.0;
            } completion:^(BOOL finished) {
                int64_t delayInSeconds = 3.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    [UIView animateWithDuration:0.3 animations:^{
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

-(void) onExit:(UIButton*)btn
{
    isExitToMenu = YES;
    
    [UIView animateWithDuration:0.03 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.03f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             CGPoint location = btn.center;
                             [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
                             
                             [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                 //
                             }];
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
                                 [wself registrationFormRefresh];
                                 [wself showAllContext];
                             };
                             [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                                 
                             }];
                         }];
                     }];
}

-(void) hideAllContext
{
    self.view.alpha = 0.0;
}

-(void) showAllContext
{
    self.view.alpha = 1.0;
}

-(void) registrationFormRefresh
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    shortRegForm = [[setting objectForKey:@"ShortRegForm"] boolValue];
    if(shortRegForm)    {
        fieldsArray = @[nameField, secondNameField, phoneField, emailField];
        tableView.frame = CGRectMake(387, 190, tableView.frame.size.width, tableView.frame.size.height);
    }
    else    {
        fieldsArray = @[nameField, secondNameField, sexField, phoneField, emailField, dateBirthField];
        tableView.frame = CGRectMake(387, 90, tableView.frame.size.width, tableView.frame.size.height);
    }
    
    [tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return fieldsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139.0/2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemCellIdentifier = @"PMRegistrationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        //cell setSelectedBackgroundView:<#(UIView *)#>
    }

    PMRegistrationFieldView *field = [fieldsArray objectAtIndex:indexPath.section];
    [cell addSubview:field];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%i", indexPath.section);
}

-(void) didSelectPMRegistrationField:(UIView*)fieldView
{
    if(fieldView == dateBirthField)
    {
        CGRect rect = [fieldView convertRect:fieldView.frame toView:self.view];
        rect.origin.y += 20;
        [popoverControllerForDate presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(fieldView == sexField)
    {
        CGRect rect = [fieldView convertRect:fieldView.frame toView:self.view];
        rect.origin.y += 40;
        [popoverControllerForSex presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void) didSelectSex:(NSString*)sexString
{
    [popoverControllerForSex dismissPopoverAnimated:YES];
    
    sexField.titleField.text = sexString;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = [self.view convertRect:rect fromView:nil].size.height;
    
    //[tableView setContentOffset:CGPointMake(0, 5) animated:YES];
    CGRect tableViewRect = tableView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        tableView.frame = CGRectMake(tableViewRect.origin.x, (shortRegForm)?90.0:10.0, tableViewRect.size.width, tableViewRect.size.height);
        continueButton.alpha = 0;
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect tableViewRect = tableView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        tableView.frame = CGRectMake(tableViewRect.origin.x, (shortRegForm)?190.0:90.0, tableViewRect.size.width, tableViewRect.size.height);
        continueButton.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

-(void) datePickerSetString:(NSString*)dateText withDate:(NSDate*)date
{
    dateBirthField.titleField.text = dateText;
    selectedBirthDate = date;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (IBAction)onContinue:(id)sender
{
    for(PMRegistrationFieldView *field in fieldsArray)
    {
        if(field.titleField.text.length == 0)   {
            [self shakeIt:field withDelta:-2.0];
            //return;
        }
    }
    
    if(fieldsArray.count == 6)   {
        if(selectedBirthDate.description.length == 0)
            selectedBirthDate = [NSDate date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        int years = [[gregorian components:NSYearCalendarUnit fromDate:selectedBirthDate toDate:[NSDate date] options:0] year];
        NSLog(@"%i years old", years);
        if (years < 18) {
            [self shakeIt:dateBirthField withDelta:-2.0];
            return;
        }
    }
    
    isExitToMenu = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nameField.titleField.text forKey:@"_firstname"];
    [userDefaults setObject:secondNameField.titleField.text forKey:@"_lastname"];
    [userDefaults setObject:emailField.titleField.text forKey:@"_emailTO"];
    [userDefaults synchronize];
    
    //[[AppDelegateInstance() rippleViewController] closeRegistrationAndOpenApp];
    
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

-(void) shakeIt:(UIView*)view withDelta:(CGFloat)delta
{
    CAKeyframeAnimation *anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ];
    anim.values = [ NSArray arrayWithObjects:
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(delta, 0.0f, 0.0f) ],
                   [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-delta, 0.0f, 0.0f) ],
                   nil ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 8.0f ;
    anim.duration = 0.03f ;
    
    [view.layer addAnimation:anim forKey:nil ];
}

@end
