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

@interface PMRegistrationVC ()

@end

@implementation PMRegistrationVC
{
    PMRegistrationFieldView *nameField;
    PMRegistrationFieldView *secondNameField;
    PMRegistrationFieldView *sexField;
    PMRegistrationFieldView *phoneField;
    PMRegistrationFieldView *emailField;
    PMRegistrationFieldView *dateBirthField;
    
    NSArray *fieldsArray;
}
@synthesize tableView;
@synthesize continueButton;

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
    
    sexField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ПОЛ" subTitle:@"ПРИМЕР: МУЖСКОЙ" withType:nil];
    [customKeyboard3 setTextView:sexField.titleField];
    
    phoneField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ТЕЛЕФОН" subTitle:@"ПРИМЕР: +79005432121" withType:kPhoneField];
    [customKeyboard4 setTextView:phoneField.titleField];
    
    emailField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"E-MAIL" subTitle:@"ПРИМЕР: IVAN@MAIL.RU" withType:nil];
    [customKeyboard5 setTextView:emailField.titleField];
    
    dateBirthField = [[PMRegistrationFieldView alloc] initWithPlaceholder:@"ДАТА РОЖДЕНИЯ" subTitle:@"ПРИМЕР: 14 МАРТА 1987" withType:nil];
    [customKeyboard6 setTextView:dateBirthField.titleField];
    
    fieldsArray = @[nameField, secondNameField, sexField, phoneField, emailField, dateBirthField];
    
    tableView.scrollEnabled = NO;
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
    
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect rect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat kbHeight = [self.view convertRect:rect fromView:nil].size.height;
    
    //[tableView setContentOffset:CGPointMake(0, 5) animated:YES];
    CGRect tableViewRect = tableView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        tableView.frame = CGRectMake(tableViewRect.origin.x, 10.0, tableViewRect.size.width, tableViewRect.size.height);
        continueButton.alpha = 0;
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect tableViewRect = tableView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        tableView.frame = CGRectMake(tableViewRect.origin.x, 90.0, tableViewRect.size.width, tableViewRect.size.height);
        continueButton.alpha = 1;
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

- (IBAction)onContinue:(id)sender
{
    for(PMRegistrationFieldView *field in fieldsArray)
    {
        if(field.titleField.text.length == 0)   {
            [self shakeIt:field withDelta:-2.0];
            //return;
        }
    }
    
    [[AppDelegateInstance() rippleViewController] closeRegistrationAndOpenApp];
}

-(void) shakeIt:(UIView*)view withDelta:(CGFloat)delta
{
    CAKeyframeAnimation *anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
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
