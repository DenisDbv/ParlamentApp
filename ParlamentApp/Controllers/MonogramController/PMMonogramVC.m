//
//  PMMonogramVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMMonogramVC.h"
#import "PMChooseFontVC.h"

@interface PMMonogramVC () <UITextFieldDelegate>

@end

@implementation PMMonogramVC
{
    NSString *_letter1;
    NSString *_letter2;
    NSInteger _font1;
    NSInteger _font2;
    
    UITextField *ttt;
}
@synthesize onClose, initialContainerView, initialTextField, onFurther;
@synthesize titleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _letter1 = @"";
        _letter2 = @"";
        _font1 = -1;
        _font2 = -1;
        
    }
    return self;
}

-(id) initMonogramVC:(NSString*)letter1 :(NSInteger)font1 :(NSString*)letter2 :(NSInteger)font2
{
    self = [super initWithNibName:@"PMMonogramVC" bundle:[NSBundle mainBundle]];
    if (self) {
        _letter1 = letter1;
        _letter2 = letter2;
        _font1 = font1;
        _font2 = font2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    PMCustomKeyboard *customKeyboard = [[PMCustomKeyboard alloc] init];
    [customKeyboard setTextView:initialTextField];
    
    if(_letter1.length == 0)
    {
        titleLabel.text = @"ПОЖАЛУЙСТА ВВЕДИТЕ ВАШИ ИНИЦИАЛЫ";
    }
    else
    {
        titleLabel.text = @"ПОЖАЛУЙСТА ВВЕДИТЕ ВАШИ ИНИЦИАЛЫ";
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    onClose.alpha = onFurther.alpha = initialContainerView.alpha = titleLabel.alpha = 1.0;
    
    [self addKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange2:) name:UITextFieldTextDidChangeNotification object: nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self removeKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textDidChange2:(UITextField *)textField
{
    if ([initialTextField.text length] > 1) {
        initialTextField.text = [initialTextField.text substringToIndex:1];
    }
    //NSLog(@"%@", initialTextField.text);
}

#pragma mark - UIKeyboard Notifications

- (void)willShowKeyboardNotification:(NSNotification *)notification
{
    CGRect screenRect = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, -50);
    }];
}

- (void)willHideKeyboardNotification:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectOffset(self.view.frame, 0, 50);
    }];
}

- (void)addKeyboardNotifications
{
    [self removeKeyboardNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)onTapClose:(UIButton*)sender
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
                             
                         }];
                     }];
    
    [self.view endEditing:YES];
    
    if(_letter2.length != 0)
    {
        _letter2 = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
        [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
    }
}

- (IBAction)onTapFurther:(UIButton*)sender
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
                             
                         }];
                     }];
    
    if(initialTextField.text.length == 0)   {
        [self shakeIt:initialContainerView withDelta:-4.0];
    }
    else    {
        [self.view endEditing:YES];
        onClose.alpha = onFurther.alpha = initialContainerView.alpha = titleLabel.alpha = 0.0;
        
        if(_letter1.length == 0)
            _letter1 = initialTextField.text;
        else
            _letter2 = initialTextField.text;
        
        PMChooseFontVC *chooseFontVC = [[PMChooseFontVC alloc] initChooseFontVC:_letter1 :_font1 :_letter2 :_font2];
        [self.navigationController pushViewController:chooseFontVC animated:YES];
        
        //PMChooseFontVC *chooseFontVC = [[PMChooseFontVC alloc] initWithInitials:initialTextField.text];
        //[self.navigationController pushViewController:chooseFontVC animated:YES];
    }
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
