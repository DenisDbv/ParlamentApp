//
//  PMFingerVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 10.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMFingerVC.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"
#import "PMImageReviewController.h"

#import "FbFAccessoryController.h"

@interface PMFingerVC () <FbFmobileOneDelegate>
@property (nonatomic, strong) FbFAccessoryController *fbfController;    //mobileOne Accessory Controller
@property (nonatomic, strong) UIImageView *fingerPrintImageView;
@end

@implementation PMFingerVC
{
    UILabel *scanelAccessDeniedLabel;
    UIButton *closeBtn;
    UIActivityIndicatorView *indicatorView;
    
    BOOL isFingerShot;
}
@synthesize titleLabel;
@synthesize fbfController = _fbfController;
@synthesize fingerPrintImageView;

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
    
    isFingerShot = NO;
    
    _fbfController = [FbFAccessoryController sharedControllerwithDelegate:self];
    NSLog(@"version number %d",_fbfController.Version1b);
    
    self.navigationController.navigationBarHidden = YES;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:23.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self showScanerContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showScanerAccessDenied
{
    [scanelAccessDeniedLabel removeFromSuperview];
    [closeBtn removeFromSuperview];
    
    titleLabel.hidden = YES;
    
    scanelAccessDeniedLabel = [[UILabel alloc] init];
    scanelAccessDeniedLabel.text = @"СКАНЕР НЕ ПОДКЛЮЧЕН";
    scanelAccessDeniedLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:45.0];
    scanelAccessDeniedLabel.backgroundColor = [UIColor clearColor];
    scanelAccessDeniedLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    scanelAccessDeniedLabel.textAlignment = NSTextAlignmentCenter;
    [scanelAccessDeniedLabel sizeToFit];
    [self.view addSubview:scanelAccessDeniedLabel];
    
    scanelAccessDeniedLabel.center = self.view.center;
    
    UIImage *settingImage = [[UIImage imageNamed:@"close-voice.png"] scaleProportionalToRetina];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateHighlighted];
    closeBtn.frame = CGRectMake(self.view.center.x-settingImage.size.width/2, self.view.center.y + 60, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:closeBtn];
}

-(void) hideScanerAccessDenied {
    titleLabel.hidden = NO;
    
    [scanelAccessDeniedLabel removeFromSuperview];
    [closeBtn removeFromSuperview];
}

-(void) showScanerContent   {
    [fingerPrintImageView removeFromSuperview];
    [indicatorView removeFromSuperview];
    
    fingerPrintImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-360)/2, titleLabel.frame.origin.y+titleLabel.frame.size.height+20, 360, 360)];
    fingerPrintImageView.backgroundColor = [UIColor whiteColor];
    fingerPrintImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:fingerPrintImageView];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectOffset(indicatorView.frame, (fingerPrintImageView.frame.size.width-indicatorView.frame.size.width)/2, (fingerPrintImageView.frame.size.height-indicatorView.frame.size.height)/2);
    [fingerPrintImageView addSubview:indicatorView];
}

-(void) hideScanerContent   {
    [fingerPrintImageView removeFromSuperview];
    
    [indicatorView removeFromSuperview];
}

-(void) onClose:(UIButton*)sender
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
                             if(IS_OS_7_OR_LATER)   {
                                 self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                                 [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                     
                                 }];
                             } else {
                                 [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                     formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                                 }];
                             }
                         }];
                     }];
}

#pragma mark -
#pragma mark Public Methods


-(void)stopScanner
{
	[_fbfController stopScanner];
}

#pragma mark -
#pragma mark FbFmobileOneDelegate Methods

-(void) mobileOneAccessoryController:(FbFAccessoryController *)mobileOne didChangeConnectionStatus:(BOOL)connected
{
    if(connected)
    {
        NSLog(@"scanner connected");
        [self hideScanerAccessDenied];
        [self showScanerContent];
        
        [mobileOne startScanner];
    }
    else
    {
        NSLog(@"scanner disconnected");
        [self hideScanerContent];
        [self showScanerAccessDenied];
    }
    
}

-(void) mobileOneAccessoryController:(FbFAccessoryController *)mobileOne didReceiveData:(NSData *)data
{
    isFingerShot = YES;
    
    UIImage *img = [UIImage imageWithData:data];

    fingerPrintImageView.image = img;
}

-(void) mobileOneAccessoryController:(FbFAccessoryController *)mobileOne didReceiveDataSpin:(BOOL)started
{
    if(started) {
        NSLog(@"start receive data spin");
    }
    else    {
        NSLog(@"stop receive data spin");
    }
}

-(void) mobileOneAccessoryController:(FbFAccessoryController *)mobileOne didReceiveError:(NSError *)error
{
	//Show Error
	if ([error code] == FBF_ERROR_BAD_DATA) {
		UIAlertView *uiview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The FbF mobileOne Encountered an Error. Please Retry" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[uiview show];
	}
}

-(void) mobileOneAccessoryController:(FbFAccessoryController *)mobileOne didReceiveScannerStartStop:(BOOL)started
{
    if(started)
    {
        //[indicatorView startAnimating];
        NSLog(@"STARTED");
    }
    else
    {
        //[indicatorView stopAnimating];
        NSLog(@"STOPPED");
    }
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
    
    self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    
    [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

- (IBAction)onTapFurther:(UIButton*)sender
{
    if(isFingerShot)    {
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
        
        self.onClose.alpha = self.onFurther.alpha = titleLabel.alpha = fingerPrintImageView.alpha = 0.0;
        
        PMImageReviewController *imageReviewController = [[PMImageReviewController alloc] initWithImage:fingerPrintImageView.image :@"Отпечаток пальца" :@"finger.png" :eToUser];
        imageReviewController.delegate = (id)self;
        [self.navigationController pushViewController:imageReviewController animated:YES];
    }
}

-(void) sendSuccessfulFromReviewController
{
    
}

-(void) backFromReviewController
{
    self.onClose.alpha = self.onFurther.alpha = titleLabel.alpha = fingerPrintImageView.alpha = 1.0;
}

@end
