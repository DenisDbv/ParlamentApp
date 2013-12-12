//
//  PMMonogramVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMMonogramVC.h"
#import "PMChooseFontVC.h"

@interface PMMonogramVC ()

@end

@implementation PMMonogramVC
@synthesize onClose, initialContainerView, initialTextField, onFurther;
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
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    PMCustomKeyboard *customKeyboard = [[PMCustomKeyboard alloc] init];
    [customKeyboard setTextView:initialTextField];
}

-(void) viewWillAppear:(BOOL)animated
{
    onClose.alpha = onFurther.alpha = initialContainerView.alpha = titleLabel.alpha = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    /*[self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];*/
    
    [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
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
        PMChooseFontVC *chooseFontVC = [[PMChooseFontVC alloc] initWithInitials:initialTextField.text];
        [self.navigationController pushViewController:chooseFontVC animated:YES];
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
