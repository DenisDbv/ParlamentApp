//
//  PMChooseFontVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMChooseFontVC.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"
#import "NSString+SizeToFit.h"

@interface PMChooseFontVC ()

@end

@implementation PMChooseFontVC
{
    NSString *initialsString;
    
    NSArray *fontImages;
    NSArray *fontNames;
    
    UIActivityIndicatorView *saveIndicator;
    
    PMMailManager *mailManager;
    
    NSInteger _fontIndex;
}
@synthesize titleLabel;
@synthesize monogramLabel;
@synthesize carousel;
@synthesize carouselContainer;
@synthesize closeBtn, saveBtn;
@synthesize finishTitle1, finishTitle2, finishTitle3, finishTitle4, finishTitle5;


-(id) initWithInitials:(NSString*)initials
{
    self = [super initWithNibName:@"PMChooseFontVC" bundle:[NSBundle mainBundle]];
    if (self) {
        initialsString = initials;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fontImages = @[@"adineki", @"bedini", @"acquests", @"adventur", @"agatha", @"alexandr", @"ampir", @"andantino", @"annabel", @"aquarelle", @"ariston", @"veron"];
    fontNames = @[@"AdineKirnberg", @"Bedini", @"AcquestScript", @"Adventure", @"Agatha-Modern", @"AlexandraZeferinoThree", @"AmpirDeco", @"Andantinoscript", @"Annabelle", @"Aquarelle", @"Ariston-Normal", @"Veron"];
    
    carousel.type = iCarouselTypeLinear;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"ПОЖАЛУЙСТА, ВЫБЕРИТЕ ШРИФТ ДЛЯ СОЗДАНИЯ МОНОГРАММЫ";
    
    UIImage *myGradient = [UIImage imageNamed:@"depositphotos_1318054-Liquid-metal.jpg"];
    monogramLabel.font = [UIFont fontWithName:@"AdineKirnberg" size:84];
    monogramLabel.text = initialsString;
    monogramLabel.textColor   = [UIColor colorWithPatternImage:myGradient];
    //monogramLabel.backgroundColor = [UIColor redColor];
    //[monogramLabel sizeToFit];
    
    [carousel reloadData];
    
    finishTitle1.alpha = 0;
    finishTitle1.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle1.backgroundColor = [UIColor clearColor];
    finishTitle1.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle1.textAlignment = NSTextAlignmentCenter;
    
    finishTitle2.alpha = 0;
    finishTitle2.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle2.backgroundColor = [UIColor clearColor];
    finishTitle2.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle2.textAlignment = NSTextAlignmentCenter;
    
    finishTitle3.alpha = 0;
    finishTitle3.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    finishTitle3.backgroundColor = [UIColor clearColor];
    finishTitle3.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle3.textAlignment = NSTextAlignmentCenter;
    
    finishTitle4.alpha = 0;
    finishTitle4.font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    finishTitle4.backgroundColor = [UIColor clearColor];
    finishTitle4.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle4.textAlignment = NSTextAlignmentCenter;
    
    finishTitle5.alpha = 0;
    finishTitle5.font = [UIFont fontWithName:@"MyriadPro-Cond" size:45.0];
    finishTitle5.backgroundColor = [UIColor clearColor];
    finishTitle5.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    finishTitle5.textAlignment = NSTextAlignmentCenter;
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(UIButton*)sender
{
    CGPoint location = sender.center;
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    [sender setEnabled:NO];
    UIImage *saveClearImage = [UIImage imageNamed:@"clear_button.png"];
    [sender setBackgroundImage:saveClearImage forState:UIControlStateNormal];
    [sender setBackgroundImage:saveClearImage forState:UIControlStateHighlighted];
    
    saveIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:saveIndicator];
    saveIndicator.center = sender.center;
    [saveIndicator startAnimating];
    
    [self generateImage];
}

-(void) generateImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *backgroundImage = [UIImage imageNamed:@"back_texture2.png"];
        CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        CGFloat yOffset = -60.0f;
        
        UIImage *labelImage = nil;
        CGRect labelFrame = CGRectZero;
        CGFloat sideLength = 0.0f;
        CGFloat fontSize = 100.0f;
        BOOL isFirstTime = YES;
        
        while (YES) {
            UIImage *_labelImage = [monogramLabel.text imageToFitWithFont:[UIFont fontWithName:[fontNames objectAtIndex:_fontIndex] size:fontSize]];
            CGRect _labelFrame = CGRectMake((backgroundRect.size.width - _labelImage.size.width)/2,
                                            (backgroundRect.size.height - _labelImage.size.height)/2 - yOffset,
                                            _labelImage.size.width, _labelImage.size.height);
            CGFloat _sideLength = (_labelFrame.size.width/_labelFrame.size.height > 0)?_labelFrame.size.width:_labelFrame.size.height;
            
            NSLog(@"New font size. Ellipse rect %@", NSStringFromCGRect(_labelFrame));
            
            if(_sideLength < 562.0 || isFirstTime == YES)
            {
                isFirstTime = NO;
                
                labelImage = _labelImage;
                labelFrame = _labelFrame;
                sideLength = _sideLength;
                
                if(_sideLength >= 562) break;
                
                fontSize += 10.0f;
            }
            else
                break;
        }
        
        //Накладываем текст на холст требуемого размера с прозрычным фоном
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, labelFrame, labelImage.CGImage);
        UIImage *textLayerImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Получаем текст с закраской фонового рисунка холста
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, backgroundRect, textLayerImage.CGImage);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        UIImage *textColorImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Создаем холст с задним фоном и белым кругом
        CGRect ellipseRect = CGRectMake((backgroundRect.size.width - sideLength)/2,
                                        (backgroundRect.size.height - sideLength)/2 - yOffset,
                                        sideLength, sideLength);
        //CGRect ellipseRect = CGRectMake((backgroundRect.size.width - (backgroundImage.size.width - 110))/2,
        //                                (backgroundRect.size.height - 530)/2, backgroundImage.size.width - 110, 530);
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        CGContextSetLineWidth(context, 0.0);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextBeginPath(context);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor);
        CGContextAddEllipseInRect(context, ellipseRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        UIImage *backImageWithCircle = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Накладываем изображение текста на холст
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImageWithCircle];
        UIImageView *frontImageView = [[UIImageView alloc] initWithImage:textColorImage];
        frontImageView.alpha = 1.0;
        [backImageView addSubview:frontImageView];
        UIGraphicsBeginImageContext(backImageView.frame.size);
        [backImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultMonogramImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        
        [resultMonogramImage drawInRect:backgroundRect];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        UIFont *font = [UIFont fontWithName:@"MyriadPro-Cond" size:40.0];
        CGRect textRect = CGRectMake(0, 0, backgroundRect.size.width, backgroundRect.size.height);
        CGFloat oneHeight = 0;
        if([names respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            //iOS 7
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            oneHeight = size.height;
            
            textRect.origin.x = (backgroundRect.size.width - size.width)/2;
            textRect.origin.y = (ellipseRect.origin.y + ellipseRect.size.height) + yOffset;
            
            [names drawInRect:textRect withAttributes:att];
        }
        else
        {
            CGSize size = [names sizeWithFont:font];
            oneHeight = size.height;
            
            textRect.origin.x = (backgroundRect.size.width - size.width)/2;
            textRect.origin.y = (ellipseRect.origin.y + ellipseRect.size.height) + yOffset;
            
            [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
            [names drawInRect:textRect withFont:font];
        }
        
        UIImage *logoImage = [UIImage imageNamed:@"the-art-text.png"];
        [logoImage drawInRect:CGRectMake((backgroundRect.size.width-logoImage.size.width)/2, textRect.origin.y + oneHeight + 20, logoImage.size.width, logoImage.size.height)];
        
        names = @"*Индивидуальность как искусство";
        font = [UIFont fontWithName:@"MyriadPro-Cond" size:16.0];
        textRect = backgroundRect;
        if([names respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            textRect.origin.x = (backgroundRect.size.width - size.width)-10;
            textRect.origin.y = backgroundRect.size.height-20-size.height;
            
            [names drawInRect:textRect withAttributes:att];
        }
        else
        {
            CGSize size = [names sizeWithFont:font];
            textRect.origin.x = (backgroundRect.size.width - size.width)-10;
            textRect.origin.y = backgroundRect.size.height-20-size.height;
            
            [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] set];
            [names drawInRect:textRect withFont:font];
        }
        
        UIImage *finishImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        //Отсылаем изображение на email пользователя
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = (id)self;
        [mailManager sendMessageWithTitle:names text:@"Монограмма" image:finishImage filename:@"monogram.png" toPerson:eToUser]; //@"Активация от Art of Individuality"
    });
}

-(void) mailSendSuccessfully
{
    [self performSelector:@selector(finishSavingMonogram) withObject:nil afterDelay:0.0];
}

-(void) mailSendFailed
{
    [self performSelector:@selector(finishSavingMonogram) withObject:nil afterDelay:0.0];
}

-(void) finishSavingMonogram
{
    self.blueLineImageView.hidden = YES;
    
    [saveIndicator stopAnimating];
    [saveIndicator removeFromSuperview];
    
    titleLabel.alpha = saveBtn.alpha = monogramLabel.alpha = carousel.alpha = 0.0;
    
    PMTimeManager *timeManager = [[PMTimeManager alloc] init];
    finishTitle5.text = [NSString stringWithFormat:@"СПАСИБО И %@!", [timeManager titleTimeArea]];
    
    finishTitle1.alpha = finishTitle2.alpha = finishTitle3.alpha = finishTitle4.alpha = finishTitle5.alpha = 1.0;
    
    UIImage *settingImage = [[UIImage imageNamed:@"settings-close.png"] scaleProportionalToRetina];
    [closeBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:settingImage forState:UIControlStateHighlighted];
}

-(void) onClose:(UIButton*)sender
{
    self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [fontImages count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        //view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
        //view.contentMode = UIViewContentModeCenter;
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
        view.contentMode = UIViewContentModeCenter;
        view.backgroundColor = [UIColor clearColor];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:view.bounds];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.tag = 3;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.minimumScaleFactor = 0.5;
        textLabel.adjustsFontSizeToFitWidth = YES;
        [view addSubview:textLabel];
    }
    
    UIFont *font = [UIFont fontWithName:[fontNames objectAtIndex:index] size:45];
    UILabel *textLabel = (UILabel*)[view viewWithTag:3];
    textLabel.font = font;
    textLabel.text = initialsString;
    
    //UIImageView *imageView = (UIImageView*)view;
    //[imageView setImage:[UIImage imageNamed:[fontImages objectAtIndex:index]]];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap)
    {
        //normally you would hard-code this to YES or NO
        return YES;
    }
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.5f;
    }
    return value;
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"Tapped font: %@", [fontNames objectAtIndex:index]);
    
    _fontIndex = index;
    
    monogramLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:index] size:84];
    UIImage *myGradient = [UIImage imageNamed:@"depositphotos_1318054-Liquid-metal.jpg"];
    monogramLabel.textColor   = [UIColor colorWithPatternImage:myGradient];
    //[monogramLabel sizeToFit];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    bool ret = NO;
    for (UITouch *touch in touches)
    {
        if(touch.view.frame.size.height == 164 || touch.view.frame.size.width == 100)  {
            ret = YES;
            break;
        }
    }
    if(!ret)
        [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    bool ret = NO;
    for (UITouch *touch in touches)
    {
        if(touch.view.frame.size.height == 164 || touch.view.frame.size.width == 100)  {
            ret = YES;
            break;
        }
    }
    if(!ret)
        [super touchesMoved:touches withEvent:event];
}

@end
