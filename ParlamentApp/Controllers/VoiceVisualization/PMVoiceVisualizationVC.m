//
//  PMVoiceVisualizationVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMVoiceVisualizationVC.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"
#import <MZTimerLabel/MZTimerLabel.h>
#import "UIView+Screenshot.h"

@interface PMVoiceVisualizationVC ()

@end

@implementation PMVoiceVisualizationVC
{
    UIButton *closeButton;
    UIButton *saveButton;
    UIButton *resetButton;
    UIButton *settingButton;
    
    BOOL attractorIsFullView;
    
    MZTimerLabel *timer;
    
    UIActivityIndicatorView *saveIndicator;
    
    UIImageView *arrowsFullView;
    
    PMMailManager *mailManager;
    UIImage *attractorSnapshot;
}
@synthesize attractorView;
@synthesize titleLabel1, titleLabel2, titleLabel3, titleLabel4;
@synthesize timerLabel;

@synthesize finishView, finishTitle1, finishTitle2, finishTitle3, finishTitle4;

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
    
    finishView.alpha = 0;
    finishView.backgroundColor = [UIColor clearColor];
    
    finishTitle1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle1.backgroundColor = [UIColor clearColor];
    finishTitle1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle1.textAlignment = NSTextAlignmentCenter;
    
    finishTitle2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle2.backgroundColor = [UIColor clearColor];
    finishTitle2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle2.textAlignment = NSTextAlignmentCenter;
    
    finishTitle3.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    finishTitle3.backgroundColor = [UIColor clearColor];
    finishTitle3.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle3.textAlignment = NSTextAlignmentCenter;
    
    finishTitle4.font = [UIFont fontWithName:@"MyriadPro-Cond" size:45.0];
    finishTitle4.backgroundColor = [UIColor clearColor];
    finishTitle4.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle4.textAlignment = NSTextAlignmentCenter;
    
    attractorIsFullView = NO;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.height;
    
    UIImage *closeImage = [[UIImage imageNamed:@"close-voice.png"] scaleProportionalToRetina];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(onVoiceClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton setImage:closeImage forState:UIControlStateHighlighted];
    closeButton.frame = CGRectMake(139.0, 313.0, closeImage.size.width, closeImage.size.height);
    [self.view addSubview:closeButton];
    
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"further.png"] scaleProportionalToRetina];
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:self action:@selector(onVoiceSave:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [saveButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    saveButton.frame = CGRectMake(766.0, 313.0, saveVoiceImage.size.width, saveVoiceImage.size.height);
    [self.view addSubview:saveButton];
    
    UIImage *resetVoiceImage = [[UIImage imageNamed:@"reset-voice.png"] scaleProportionalToRetina];
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton addTarget:self action:@selector(onVoiceReset:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setImage:resetVoiceImage forState:UIControlStateNormal];
    [resetButton setImage:resetVoiceImage forState:UIControlStateHighlighted];
    resetButton.frame = CGRectMake(401.0, 650.0, resetVoiceImage.size.width, resetVoiceImage.size.height);
    [self.view addSubview:resetButton];
    
    UIImage *settingImage = [[UIImage imageNamed:@"settings-close.png"] scaleProportionalToRetina];
    settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.alpha = 0.0;
    [settingButton addTarget:self action:@selector(onSettingClose:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:settingImage forState:UIControlStateNormal];
    [settingButton setImage:settingImage forState:UIControlStateHighlighted];
    settingButton.frame = CGRectMake(screenWidth - settingImage.size.width - 10, 10, settingImage.size.width, settingImage.size.height);
    [self.view addSubview:settingButton];
    
    titleLabel1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    
    titleLabel2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    titleLabel2.backgroundColor = [UIColor clearColor];
    titleLabel2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    
    titleLabel3.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    titleLabel3.backgroundColor = [UIColor clearColor];
    titleLabel3.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    
    titleLabel4.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    titleLabel4.backgroundColor = [UIColor clearColor];
    titleLabel4.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel4.textAlignment = NSTextAlignmentCenter;
    
    [self titleRefresh:1];
}

-(void) viewWillAppear:(BOOL)animated
{
    [attractorView initialization];
    
    timer = [[MZTimerLabel alloc] initWithLabel:timerLabel andTimerType:MZTimerLabelTypeTimer];
    [timer setCountDownTime:60*5];
    [timer setTimeFormat:@"mm:ss"];
    timerLabel.font = [UIFont systemFontOfSize:45.0f];
    timerLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    [timer startWithEndingBlock:^(NSTimeInterval countTime) {
        [self onVoiceClose:closeButton];
    }];
    [timer start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) onVoiceClose:(UIButton*)btn
{
    [UIView animateWithDuration:0.05 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.05f animations:^{
                             btn.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             [self unload];
                             
                             self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
                             [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                                 
                             }];
                         }];
                     }];
}

-(void) unload
{
    [timer pause];
    timer = nil;
    
    attractorSnapshot = attractorView.snapshotImage;
    
    [attractorView releaseView];
    [attractorView removeFromSuperview];
    attractorView = nil;
}

-(void) titleRefresh:(NSInteger)status
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(status == 1)
    {
        titleLabel2.text = [NSString stringWithFormat:@"%@, СКАЖИТЕ СВОИ ДАННЫЕ В МИКРОФОН", [userDefaults objectForKey:@"_firstnameW"]];
    }
    else
    {
        titleLabel2.text = [NSString stringWithFormat:@"%@, СКАЖИТЕ СВОИ ДАННЫЕ В МИКРОФОН", [userDefaults objectForKey:@"_firstname"]];
    }
}

-(void) onVoiceSave:(UIButton*)btn
{
    NSInteger currentIndex = [attractorView getCurrentAttractorIndex];
    
    if(currentIndex >= 2)   {
        [btn setEnabled:NO];
        UIImage *saveClearImage = [UIImage imageNamed:@"clear_button.png"];
        [btn setImage:saveClearImage forState:UIControlStateNormal];
        [btn setImage:saveClearImage forState:UIControlStateHighlighted];
        
        saveIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.view addSubview:saveIndicator];
        //saveIndicator.frame = CGRectMake(btn.frame.origin.x+10, btn.frame.origin.y+10, 25, 25);
        saveIndicator.center = btn.center;
        [saveIndicator startAnimating];
        
        [UIView animateWithDuration:0.05 animations:^{
            btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.05f animations:^{
                                 btn.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 //
                             }];
                         }];
        
        [timer pause];
        [attractorView snapShoting];
        
        [self performSelector:@selector(finishSavingSnapshot) withObject:nil afterDelay:2.0];
    }
    else    {
        [UIView animateWithDuration:0.05 animations:^{
            btn.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.05f animations:^{
                                 btn.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 UIImage *saveClearImage = [UIImage imageNamed:@"save-voice.png"];
                                 [btn setImage:saveClearImage forState:UIControlStateNormal];
                                 [btn setImage:saveClearImage forState:UIControlStateHighlighted];
                             }];
                         }];
        
        [timer reset];
        [self titleRefresh:2];
        [attractorView attractorAllow];
    }
}

-(void) snapshotWaiting
{
    NSLog(@"%@", NSStringFromCGSize(attractorView.snapshotImage.size));
    mailManager = [[PMMailManager alloc] init];
    mailManager.delegate = self;
    //[mailManager sendMessageWithImage:attractorView.snapshotImage imageName:@"voice.png" andText:@"Изображение голоса"];
    [mailManager sendMessageWithTitle:@"Активация от Art of Individuality" text:@"Изображение голоса" image:attractorView.snapshotImage filename:@"voice.png"];
}

-(void) mailSendSuccessfully
{
    //[self performSelector:@selector(finishSavingSnapshot) withObject:nil afterDelay:0.0];
}

-(void) mailSendFailed
{
    //[self performSelector:@selector(finishSavingSnapshot) withObject:nil afterDelay:0.0];
}

-(void) finishSavingSnapshot
{
    [self unload];
    
    [saveIndicator stopAnimating];
    [saveIndicator removeFromSuperview];
    
    saveButton.alpha = 0.0;
    resetButton.alpha = 0.0;
    titleLabel1.alpha = titleLabel2.alpha = titleLabel3.alpha = titleLabel4.alpha = 0.0;
    timerLabel.alpha = 0.0;
    settingButton.alpha = 0.0;
    attractorView.alpha = 0.0;
    
    PMTimeManager *timeManager = [[PMTimeManager alloc] init];
    finishTitle4.text = [NSString stringWithFormat:@"СПАСИБО И %@!", [timeManager titleTimeArea]];
    finishView.alpha = 1.0;
    
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"save-voice.png"] scaleProportionalToRetina];
    [saveButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [saveButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    [saveButton setEnabled:YES];
    
   // NSLog(@"%@", NSStringFromCGSize(attractorSnapshot.size));
    if(attractorSnapshot.size.width != 0)   {
        
        CGSize paperSize = CGSizeMake(571.0, 791.0);
        UIGraphicsBeginImageContextWithOptions(paperSize, NO, 1.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, paperSize.width, paperSize.height));
        [attractorSnapshot drawInRect:CGRectMake((paperSize.width-attractorSnapshot.size.width)/2, 120.0, attractorSnapshot.size.width,attractorSnapshot.size.height)];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *text = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        UIFont *font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
        CGRect textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
        CGFloat oneHeight = 0;
        
        if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            CGSize size = [text sizeWithAttributes:att];
            oneHeight = size.height;
            
            textRect.origin.x = (paperSize.width - size.width)/2;
            textRect.origin.y = 120.0+attractorSnapshot.size.height+128.0;
            
            [text drawInRect:textRect withAttributes:att];
        }
        else
        {
            //legacy support
            [text drawInRect:CGRectIntegral(textRect) withFont:font];
        }
        
        text = @"The Art of Individuality*";
        font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
        textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
        if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            CGSize size = [text sizeWithAttributes:att];
            textRect.origin.x = (paperSize.width - size.width)/2;
            textRect.origin.y = 120.0+attractorSnapshot.size.height+128.0+oneHeight+5.0;
            
            [text drawInRect:textRect withAttributes:att];
        }
        
        text = @"*Индивидуальность как искусство";
        font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
        textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
        if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            CGSize size = [text sizeWithAttributes:att];
            textRect.origin.x = (paperSize.width - size.width)-10;
            textRect.origin.y = paperSize.height-7-size.height;
            
            [text drawInRect:textRect withAttributes:att];
        }
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        /*UIGraphicsBeginImageContextWithOptions(CGSizeMake(attractorSnapshot.size.width,attractorSnapshot.size.height), NO, 1.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, attractorSnapshot.size.width,attractorSnapshot.size.height));
        [attractorSnapshot drawInRect:CGRectMake(0, 0, attractorSnapshot.size.width,attractorSnapshot.size.height)];
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();*/
        
        /*
         UIGraphicsBeginImageContextWithOptions(CGSizeMake(attractorSnapshot.size.width,attractorSnapshot.size.height), NO, 1.0);
         [attractorSnapshot drawInRect:CGRectMake(0, 0, attractorSnapshot.size.width,attractorSnapshot.size.height)];
         CGContextRef ctx = UIGraphicsGetCurrentContext();
         CGContextSetBlendMode(ctx, kCGBlendModeSourceIn);
         CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
         CGContextFillRect(ctx, CGRectMake(0, 0, attractorSnapshot.size.width,attractorSnapshot.size.height));
         UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         */
        
       /* mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = self;
        //[mailManager sendMessageWithImage:resultingImage imageName:@"voice.png" andText:@"Изображение голоса"];
        [mailManager sendMessageWithTitle:@"Активация от Art of Individuality" text:@"Изображение голоса" image:resultingImage filename:@"voice.png"];

        /*UIImageView *imgView = [[UIImageView alloc] initWithImage:resultingImage];
        imgView.frame = CGRectOffset(imgView.frame, 0, 0);
        [self.view addSubview:imgView];*/
    }
    
    [self initResultImage];
}

-(void) initResultImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *backgroundImage = [UIImage imageNamed:@"back_2.png"];
        CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        CGRect figureRect = CGRectMake((backgroundRect.size.width - (backgroundImage.size.width - 110))/2, 250, backgroundImage.size.width - 110, 530);
        
        /*UIGraphicsBeginImageContextWithOptions(attractorSnapshot.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(context, CGRectMake(0, 0, attractorSnapshot.size.width, attractorSnapshot.size.height));
        //CGContextSetBlendMode(context, kCGBlendModeCopy);
        CGContextDrawImage(context, CGRectMake(0, 0, attractorSnapshot.size.width, attractorSnapshot.size.height), attractorSnapshot.CGImage);
        UIImage *resultingImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData* imageData =  UIImageJPEGRepresentation(attractorSnapshot, 1.0);
        UIImage *jpgImage = [self changeWhiteColorTransparent:[UIImage imageWithData:imageData]];*/
        
        NSData* imageData =  UIImagePNGRepresentation(attractorSnapshot);
        UIImage *pngImage = [UIImage imageWithData:imageData];
        
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, figureRect, pngImage.CGImage);
        //[attractorSnapshot drawInRect:figureRect];
        //CGRectMake((backgroundRect.size.width-attractorSnapshot.size.width)/2, (backgroundRect.size.height-attractorSnapshot.size.height)/2, attractorSnapshot.size.width, attractorSnapshot.size.height)
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *names = [NSString stringWithFormat:@"%@ + %@", [userDefaults objectForKey:@"_firstnameW"], [userDefaults objectForKey:@"_firstname"]];
        UIFont *font = [UIFont fontWithName:@"MyriadPro-Cond" size:40.0];
        CGRect textRect = CGRectMake(0, 0, backgroundRect.size.width, backgroundRect.size.height);
        CGFloat oneHeight = 0;
        if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            oneHeight = size.height;
            
            textRect.origin.x = (backgroundRect.size.width - size.width)/2;
            textRect.origin.y = figureRect.origin.y + figureRect.size.height + 40;
            
            [names drawInRect:textRect withAttributes:att];
        }
        
        UIImage *logoImage = [UIImage imageNamed:@"the-art-text.png"];
        [logoImage drawInRect:CGRectMake((backgroundRect.size.width-logoImage.size.width)/2, textRect.origin.y + oneHeight + 20, logoImage.size.width, logoImage.size.height)];
        
        names = @"*Индивидуальность как искусство";
        font = [UIFont fontWithName:@"MyriadPro-Cond" size:16.0];
        textRect = backgroundRect;
        if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            textRect.origin.x = (backgroundRect.size.width - size.width)-10;
            textRect.origin.y = backgroundRect.size.height-20-size.height;
            
            [names drawInRect:textRect withAttributes:att];
        }
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        /*dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSData* imageData =  UIImagePNGRepresentation(attractorSnapshot);
            UIImage *pngImage = [UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:attractorSnapshot];
            UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_2.png"]];
            UIView *secondView = [[UIView alloc] initWithFrame:imgView2.frame];
            [secondView addSubview:imgView2];
            //imgView.frame = CGRectOffset(imgView.frame, (imgView2.frame.size.width - attractorSnapshot.size.width)/2, (imgView2.frame.size.height - attractorSnapshot.size.height)/2);
            [secondView addSubview:imgView];
            [self.view addSubview:imgView];

        });*/
        
        names = [NSString stringWithFormat:@"%@ + %@", [userDefaults objectForKey:@"_firstnameW"], [userDefaults objectForKey:@"_firstname"]];
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = (id)self;
        [mailManager sendMessageWithTitle:names text:@"Изображение голоса" image:resultingImage filename:@"voice.png"];
    });
    
    
}

-(UIImage *)changeWhiteColorTransparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;
    const float colorMasking[6] = {222, 255, 222, 255, 222, 255};
    UIGraphicsBeginImageContext(image.size);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iPhone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    /* changes start here */
    // Create bitmap image info from pixel data in current context
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    
    // release the colorspace and graphics context
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    // make a new alpha-only graphics context
    context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, nil, kCGImageAlphaOnly);
    
    // draw image into context with no colorspace
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // create alpha bitmap mask from current context
    CGImageRef mask = CGBitmapContextCreateImage(context);
    
    // release graphics context
    CGContextRelease(context);
    
    // make UIImage from grayscale image with alpha mask
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:image.scale orientation:image.imageOrientation];
    
    // release the CG images
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    
    // return the new grayscale image
    return grayScaleImage;
    
    /* changes end here */
}

-(void) onVoiceReset:(UIButton*)btn
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
    
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"further.png"] scaleProportionalToRetina];
    [saveButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [saveButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    
    [self titleRefresh:1];
    [attractorView resetAttractors];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(finishView.alpha == 1.0) {
        for (UITouch *touch in touches)
        {
            CGPoint location;
            if(touch.view == finishView)
                location = [finishView convertPoint:[touch locationInView:touch.view] toView:self.view];
            else
                location = [self.view convertPoint:[touch locationInView:touch.view] toView:self.view];
            [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(finishView.alpha == 1.0) {
        for (UITouch *touch in touches)
        {
            CGPoint location;
            if(touch.view == finishView)
                location = [finishView convertPoint:[touch locationInView:touch.view] toView:self.view];
            else
                location = [self.view convertPoint:[touch locationInView:touch.view] toView:self.view];
            [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
        }
    }
}

-(void) attractorScaleValue:(CGFloat)scale
{
    if(scale > 1.3 && !attractorIsFullView)
    {
        attractorIsFullView = YES;
        [self attractorViewToFullScreen];
    }
}

-(void) createFirstAttractor
{
    arrowsFullView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"arrows-fullview.png"] scaleProportionalToRetina]];
    arrowsFullView.alpha = 0;
    arrowsFullView.center = attractorView.center;
    [self.view addSubview:arrowsFullView];
    
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationRepeatCount:3];
        arrowsFullView.alpha = 1.0;
    } completion:^(BOOL finished) {
        arrowsFullView.alpha = 0;
        [arrowsFullView removeFromSuperview];
    }];
}

-(void) attractorViewToFullScreen
{
    [UIView animateWithDuration:0.3f animations:^{
        attractorView.frame = self.view.bounds;
        attractorView.scale = 1.0;
        attractorView.lastScale = 1.0;
        closeButton.alpha = 0.0;
        saveButton.alpha = 0.0;
        resetButton.alpha = 0.0;
        titleLabel1.alpha = titleLabel2.alpha = titleLabel3.alpha = titleLabel4.alpha = 0.0;
        timerLabel.alpha = 0.0;
        settingButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) onSettingClose:(UIButton*)button
{
    attractorIsFullView = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        attractorView.frame = CGRectMake(337.0, 189.0, 350.0, 350.0);
        attractorView.scale = 1.0;
        attractorView.lastScale = 1.0;
        closeButton.alpha = 1.0;
        saveButton.alpha = 1.0;
        resetButton.alpha = 1.0;
        titleLabel1.alpha = titleLabel2.alpha = titleLabel3.alpha = titleLabel4.alpha = 1.0;
        timerLabel.alpha = 1.0;
        settingButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
