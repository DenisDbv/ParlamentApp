//
//  PMActivationView.m
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMActivationView.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"

@implementation PMActivationView
{
    //ActivationIDs ids;
    BOOL _textShow;
    UIImageView *activationImageView;
    UIButton *activeButton;
    UILabel *englishDesc;
    UILabel *russianDesc;
}
@synthesize delegate;
@synthesize ids;

-(id) initWithActivationID:(NSInteger)id withText:(BOOL)textShow
{
    self = [super initWithFrame:CGRectMake(0, 0, 142.0, 142.0)];
    if (self) {
        ids = id;
        _textShow = textShow;
        [self initializeActivation];
    }
    return self;
}

-(void) initializeActivation
{
    activationImageView = [[UIImageView alloc] initWithImage:[[self imageActivation] scaleProportionalToRetina]];
    //[self addSubview:activationImageView];
    
    UIImage *settingImage = [[self imageActivation] scaleProportionalToRetina];
    activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [activeButton addTarget:self action:@selector(onActiveClick:) forControlEvents:UIControlEventTouchDown];
    [activeButton setImage:settingImage forState:UIControlStateNormal];
    [activeButton setImage:settingImage forState:UIControlStateHighlighted];
    activeButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
    [self addSubview:activeButton];
    
    if(_textShow)   {
        englishDesc = [[UILabel alloc] init];
        englishDesc.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
        englishDesc.backgroundColor = [UIColor clearColor];
        englishDesc.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
        englishDesc.textAlignment = NSTextAlignmentCenter;
        englishDesc.text = [self englishDescription];
        [englishDesc sizeToFit];
        englishDesc.frame = CGRectMake((self.frame.size.width-englishDesc.frame.size.width)/2,
                                       activationImageView.frame.size.height + 55,
                                       englishDesc.frame.size.width,
                                       englishDesc.frame.size.height);
        [self addSubview:englishDesc];
        
        russianDesc = [[UILabel alloc] init];
        russianDesc.font = [UIFont fontWithName:@"MyriadPro-Cond" size:23.0];
        russianDesc.backgroundColor = [UIColor clearColor];
        russianDesc.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
        russianDesc.textAlignment = NSTextAlignmentCenter;
        russianDesc.text = [self russianDescription];
        [russianDesc sizeToFit];
        russianDesc.frame = CGRectMake((self.frame.size.width-russianDesc.frame.size.width)/2,
                                       englishDesc.frame.origin.y + englishDesc.frame.size.height + 70,
                                       russianDesc.frame.size.width,
                                       englishDesc.frame.size.height);
        [self addSubview:russianDesc];
        
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                russianDesc.frame.origin.y+russianDesc.frame.size.height);
    }
    
    [activationImageView initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [UIView animateWithDuration:0.05 animations:^{
            activationImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.05f animations:^{
                                 activationImageView.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 if( [delegate respondsToSelector:@selector(activationView:didSelectWithID:)] )
                                 {
                                     [delegate activationView:self didSelectWithID:ids];
                                 }
                             }];
                         }];
    } forTaps:1];
}

-(void) onActiveClick:(UIButton*)activeBtn
{
    CGPoint location = [self convertPoint:activeBtn.center toView:((UIViewController*)delegate).view];
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    [UIView animateWithDuration:0.05 animations:^{
        activeBtn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             activeBtn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             if( [delegate respondsToSelector:@selector(activationView:didSelectWithID:)] )
                             {
                                 [delegate activationView:self didSelectWithID:ids];
                             }
                         }];
                     }];
}

-(void) disableActivation:(BOOL)isDisable
{
    if(isDisable)
        activationImageView.image = [[self imageDisableActivation] scaleProportionalToRetina];
    else
        activationImageView.image = [[self imageActivation] scaleProportionalToRetina];
}

-(UIImage*) imageActivation
{
    switch (ids) {
        case eEye:
            return [UIImage imageNamed:@"active-eye.png"];
            break;
        case eVoice:
            return [UIImage imageNamed:@"active-voice.png"];
            break;
        case eSiluet:
            return [UIImage imageNamed:@"active-siluet.png"];
            break;
        case eFinger:
            return [UIImage imageNamed:@"active-finger.png"];
            break;
        case eMonogram:
            return [UIImage imageNamed:@"active-monogram.png"];
            break;
            
        default:
            break;
    }
}

-(UIImage*) imageDisableActivation
{
    switch (ids) {
        case eEye:
            return [UIImage imageNamed:@"active-eye-disable.png"];
            break;
        case eVoice:
            return [UIImage imageNamed:@"active-voice-disable.png"];
            break;
        case eSiluet:
            return [UIImage imageNamed:@"active-siluet-disable.png"];
            break;
        case eFinger:
            return [UIImage imageNamed:@"active-finger-disable.png"];
            break;
        case eMonogram:
            return [UIImage imageNamed:@"active-monogram-disable.png"];
            break;
            
        default:
            break;
    }
}

-(NSString*) englishDescription
{
    switch (ids) {
        case eEye:
            return @"ART OF IRIS**";
            break;
        case eVoice:
            return @"SOUND MIRROR***";
            break;
        case eSiluet:
            return @"SILHOUETTE****";
            break;
        case eFinger:
            return @"PERSONAL TOUCH*";
            break;
        case eMonogram:
            return @"MONOGRAM****";
            break;
            
        default:
            break;
    }
}

-(NSString*) russianDescription
{
    switch (ids) {
        case eEye:
            return @"**ГЛАЗ";
            break;
        case eVoice:
            return @"***ГОЛОС";
            break;
        case eSiluet:
            return @"*****СИЛУЭТ";
            break;
        case eFinger:
            return @"*ОТПЕЧАТОК";
            break;
        case eMonogram:
            return @"****МОНОГРАММА";
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [self convertPoint:[touch locationInView:touch.view] toView:((UIViewController*)delegate).view];
        [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [self convertPoint:[touch locationInView:touch.view] toView:((UIViewController*)delegate).view];
        [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    }
}

@end
