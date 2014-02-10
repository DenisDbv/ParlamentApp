//
//  PMEyeVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 19.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMEyeVC.h"

@interface PMEyeVC ()

@end

@implementation PMEyeVC
{
    PMMailManager *mailManager;
}
@synthesize titleLabel1, titleLabel2;

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
    
    [self sendEyeMessage];
    
    titleLabel1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    
    titleLabel2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:50.0];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(UIButton*)sender
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
                             self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                             [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                 //
                             }];
                         }];
                     }];
}

-(void) sendEyeMessage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = self;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *title = [NSString stringWithFormat:@"Обработка %@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        
        NSString *descText = @"";
        descText = [descText stringByAppendingFormat:@"%@ %@\n", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        if(((NSString*)([userDefaults objectForKey:@"_sex"])).length != 0)
        {
            descText = [descText stringByAppendingFormat:@"ПОЛ: %@\n", [userDefaults objectForKey:@"_sex"]];
        }
        if(((NSString*)([userDefaults objectForKey:@"_birthday"])).length != 0)
        {
            descText = [descText stringByAppendingFormat:@"ДАТА РОЖДЕНИЯ:%@\n", [userDefaults objectForKey:@"_birthday"]];
        }
        descText = [descText stringByAppendingFormat:@"ТЕЛЕФОН: %@\n", [userDefaults objectForKey:@"_telephone"]];
        descText = [descText stringByAppendingFormat:@"EMAIL: %@\n", [userDefaults objectForKey:@"_emailTO"]];
        
        NSString *names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        //[mailManager sendMessageToPhotoPersonWithSubject:title andDesc:descText];
        [mailManager sendMessageWithTitle:names text:descText image:nil filename:@""];
    });
}
@end
