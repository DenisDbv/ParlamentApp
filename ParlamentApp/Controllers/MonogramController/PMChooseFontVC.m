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
#import "PMMonogramVC.h"

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
    
    NSString *_letter1;
    NSString *_letter2;
    NSInteger _font1;
    NSInteger _font2;
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
        
        _letter1 = @"";
        _letter2 = @"";
        _font1 = -1;
        _font2 = -1;
    }
    return self;
}

-(id) initChooseFontVC:(NSString*)letter1 :(NSInteger)font1 :(NSString*)letter2 :(NSInteger)font2
{
    self = [super initWithNibName:@"PMChooseFontVC" bundle:[NSBundle mainBundle]];
    if (self) {
        _letter1 = letter1;
        _letter2 = letter2;
        _font1 = font1;
        _font2 = font2;
        
        if(_letter2.length == 0)
            initialsString = _letter1;
        else
            initialsString = _letter2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fontImages = @[@"adineki", @"bedini", @"acquests", @"adventur", @"agatha", @"alexandr", @"ampir", @"andantino", @"annabel", @"aquarelle", @"ariston", @"veron"];
    fontNames = @[@"AdineKirnberg", @"Bedini", @"AcquestScript", @"Adventure", @"Agatha-Modern", @"AlexandraZeferinoThree", @"AmpirDeco", @"Andantinoscript", @"Annabelle", @"Aquarelle", @"Ariston-Normal", @"Veron", @"DelphianC"];
    
    carousel.type = iCarouselTypeLinear;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if(_letter2.length == 0)
    {
        titleLabel.text = @"ПОЖАЛУЙСТА ВЫБЕРИТЕ ШРИФТ ДЛЯ СОЗДАНИЯ МОНОГРАММЫ МУЖЧИНЫ";
    }
    else    {
        titleLabel.text = @"ПОЖАЛУЙСТА ВЫБЕРИТЕ ШРИФТ ДЛЯ СОЗДАНИЯ МОНОГРАММЫ ЖЕНЩИНЫ";
    }
    
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

-(void) viewWillAppear:(BOOL)animated
{
    self.view.alpha = 1;
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
    
    if(_font2 != -1)
        _font2 = -1;
    else
        _font1 = -1;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(UIButton*)sender
{
    CGPoint location = sender.center;
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    if(_font1 == -1)
    {
        _font1 = _fontIndex;
        
        self.view.alpha = 0;
        
        PMMonogramVC *monogramVC = [[PMMonogramVC alloc] initMonogramVC:_letter1 :_font1 :_letter2 :_font2];
        [self.navigationController pushViewController:monogramVC animated:YES];
    }
    else
    {
        _font2 = _fontIndex;
        
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
}

-(UIImage*) getColorTextImage:(UIImage*)labelImage
{
    UIImage *backgroundImage = [UIImage imageNamed:@"back_2.png"];
    CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blueColor] set];
    CGContextFillRect(context, backgroundRect);
    UIImage *backImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Накладываем текст на холст требуемого размера с прозрычным фоном
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, backgroundImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, labelImage.size.width, labelImage.size.height), labelImage.CGImage);
    UIImage *textLayerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Получаем текст с закраской фонового рисунка холста
    UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, backgroundImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, backgroundRect, textLayerImage.CGImage);
    CGContextDrawImage(context, backgroundRect, backImage.CGImage);
    UIImage *textColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [@"" imageToFit:textColorImage];
}

-(UIImage*) getColorTextImage:(UIImage*)labelImage withBackgroundImage:(UIImage*)backImg
{
    UIImage *backgroundImage = [UIImage imageNamed:@"back_2.png"];
    CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    
    /*UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [backImg drawInRect:backgroundRect];
    UIImage *backImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    //Накладываем текст на холст требуемого размера с прозрычным фоном
    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, backgroundImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, labelImage.size.width, labelImage.size.height), labelImage.CGImage);
    UIImage *textLayerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Получаем текст с закраской фонового рисунка холста
    UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, backgroundImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, backgroundRect, textLayerImage.CGImage);
    CGContextDrawImage(context, CGRectMake(0, 0, backImg.size.width, backImg.size.height), backImg.CGImage);
    UIImage *textColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [@"" imageToFit:textColorImage];
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

-(void) generateImage
{
    NSLog(@"letter1=%@ letter2=%@ font1=%i font2=%i", _letter1, _letter2, _font1, _font2);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *backgroundImage = [UIImage imageNamed:@"back_2.png"];
        CGRect backgroundRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        //CGSize maximumSize = CGSizeMake(backgroundImage.size.width, backgroundImage.size.height);
        //UIFont *font = [UIFont fontWithName:[fontNames objectAtIndex:_fontIndex] size:84.0*2.5];
        //CGSize monogramSize = [monogramLabel.text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
        
        /*//Текст
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        myLabel.text = monogramLabel.text;
        myLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:_fontIndex] size:84.0*4.0];
        myLabel.textColor = [UIColor redColor];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.adjustsFontSizeToFitWidth = YES;
        myLabel.minimumScaleFactor = 0.5;
        myLabel.opaque = NO;
        [myLabel sizeToFit];
        myLabel.frame = CGRectMake((backgroundRect.size.width - (backgroundImage.size.width - 110))/2, 250, backgroundImage.size.width - 110, 530);*/
        
        CGFloat yOffset = -60.0f;
        
        CGFloat squareSideLength = 400.0f;
        CGFloat fontSize = 100.0f;
        NSString *firstCharacter = _letter1; //[monogramLabel.text substringToIndex:1];
        NSString *secondCharacter = _letter2; //[monogramLabel.text substringFromIndex:1];
        UIFont *font = [UIFont fontWithName:[fontNames objectAtIndex:_fontIndex] size:fontSize];
        
        /*UIImage *textColorLabel1 = [self getColorTextImage:labelImage1];
        UIImage *textColorLabel2 = [self getColorTextImage:labelImage2];
        
        CGImageRelease(labelImage1.CGImage);
        CGImageRelease(labelImage2.CGImage);*/
        
        CGRect labelImageRect1 = CGRectZero;
        CGRect labelImageRect2 = CGRectZero;
        UIImage *labelImage1, *labelImage2 = nil;
        BOOL ret = NO;
        
        do {
            font = [UIFont fontWithName:[fontNames objectAtIndex:_font1] size:fontSize];
            labelImage1 = [firstCharacter imageToFitWithFont: font];
            font = [UIFont fontWithName:[fontNames objectAtIndex:_font2] size:fontSize];
            labelImage2 = [secondCharacter imageToFitWithFont: font];
            
            labelImageRect1 = CGRectMake(0, 0, labelImage1.size.width, labelImage1.size.height);
            labelImageRect2 = CGRectMake((squareSideLength-labelImage2.size.width), (squareSideLength-labelImage2.size.height), labelImage2.size.width, labelImage2.size.height);
            
            if(!CGRectContainsPoint(labelImageRect1, CGPointMake(labelImageRect2.origin.x, labelImageRect2.origin.y)))
            {
                fontSize += 5.0f;
                NSLog(@"%@ and %@ (%f)", NSStringFromCGRect(labelImageRect1), NSStringFromCGRect(labelImageRect2), fontSize);
            }
            else
            {
                ret = YES;
                
                fontSize += 10;
                fontSize /= 2;
                
                font = [UIFont fontWithName:[fontNames objectAtIndex:_font1] size:fontSize];
                labelImage1 = [firstCharacter imageToFitWithFont: font];
                font = [UIFont fontWithName:[fontNames objectAtIndex:_font2] size:fontSize];
                labelImage2 = [secondCharacter imageToFitWithFont: font];
                
                labelImageRect1 = CGRectMake(0, 0, labelImage1.size.width, labelImage1.size.height);
                labelImageRect2 = CGRectMake((squareSideLength-labelImage2.size.width), (squareSideLength-labelImage2.size.height), labelImage2.size.width, labelImage2.size.height);
            }
            
        } while (!ret);
        
        NSLog(@"Finish font change");
        
        UIImage *textColorLabel1 = [self getColorTextImage:labelImage1];
        UIImage *textColorLabel2 = [self getColorTextImage:labelImage2 withBackgroundImage:[UIImage imageNamed:@"bwz.jpg"]];
        
        //CGRect squareUnion = CGRectUnion(labelImageRect1, labelImageRect2);
        //squareSideLength = (squareUnion.size.width/squareUnion.size.height > 0)?squareUnion.size.width:squareUnion.size.height;
        CGRect squareUnion = CGRectMake((backgroundRect.size.width - squareSideLength)/2,
                                        (backgroundRect.size.height - squareSideLength)/2,
                                        squareSideLength, squareSideLength);
        
        squareSideLength = 562.0f;
        
        CGRect ellipseRect = CGRectMake((backgroundRect.size.width - squareSideLength)/2,
                                        (backgroundRect.size.height - squareSideLength)/2,
                                        squareSideLength, squareSideLength);
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
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
        
        UIImage *plusImage = [@"+" imageToFitWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
        //UIImage *colorPlusImage = [self getColorTextImage:plusImage withBackgroundImage:backgroundImage];
        
        //Накладываем текст на холст требуемого размера с прозрычным фоном
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake((backgroundRect.size.width-plusImage.size.width)/2, (backgroundRect.size.height-plusImage.size.height)/2, plusImage.size.width, plusImage.size.height), plusImage.CGImage);
        UIImage *textLayerImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Получаем текст с закраской фонового рисунка холста
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, backgroundImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, backgroundRect, textLayerImage.CGImage);
        CGContextDrawImage(context, backgroundRect, backgroundImage.CGImage);
        UIImage *colorPlusImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *plusImageView = [[UIImageView alloc] initWithImage:colorPlusImage];
        plusImageView.transform = CGAffineTransformMakeRotation(10 * M_PI/180);
        
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImageWithCircle];
        UIImageView *firstLetterImage = [[UIImageView alloc] initWithImage:textColorLabel1];
        UIImageView *secondLetterImage = [[UIImageView alloc] initWithImage:textColorLabel2];
        firstLetterImage.alpha = secondLetterImage.alpha = 1.0;
        firstLetterImage.frame = CGRectMake(squareUnion.origin.x, squareUnion.origin.y,
                                            firstLetterImage.frame.size.width, firstLetterImage.frame.size.height);
        secondLetterImage.frame = CGRectMake(((squareUnion.origin.x+squareUnion.size.width)-secondLetterImage.frame.size.width),
                                             (((squareUnion.origin.y+squareUnion.size.height)-secondLetterImage.frame.size.height)),
                                             secondLetterImage.frame.size.width, secondLetterImage.frame.size.height);
        [backImageView addSubview:plusImageView];
        plusImageView.center = backImageView.center;
        
        [backImageView addSubview:firstLetterImage];
        [backImageView addSubview:secondLetterImage];
        UIGraphicsBeginImageContext(backImageView.frame.size);
        [backImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *resultMonogramImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, 2.0);
        context = UIGraphicsGetCurrentContext();
        
        [resultMonogramImage drawInRect:backgroundRect];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *names = [NSString stringWithFormat:@"%@ + %@", [userDefaults objectForKey:@"_firstnameW"], [userDefaults objectForKey:@"_firstname"]];
        font = [UIFont fontWithName:@"MyriadPro-Cond" size:40.0];
        CGRect textRect = CGRectMake(0, 0, backgroundRect.size.width, backgroundRect.size.height);
        CGFloat oneHeight = 0;
        if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            oneHeight = size.height;
            
            textRect.origin.x = (backgroundRect.size.width - size.width)/2;
            textRect.origin.y = (ellipseRect.origin.y + ellipseRect.size.height)+40;
            
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
        
        UIImage *finishImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Отсылаем изображение на email пользователя
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = (id)self;
        [mailManager sendMessageWithTitle:@"Активация от Art of Individuality" text:@"Монограмма" image:finishImage filename:@"monogram.png"];
        
        /*CGFloat yOffset = -60.0f;
        
        UIImage *labelImage = nil;
        CGRect labelFrame = CGRectZero;
        CGFloat sideLength = 0.0f;
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
        if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
        {
            //iOS 7
            
            NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5]};
            CGSize size = [names sizeWithAttributes:att];
            oneHeight = size.height;
            
            textRect.origin.x = (backgroundRect.size.width - size.width)/2;
            textRect.origin.y = (ellipseRect.origin.y + ellipseRect.size.height) + yOffset;
            
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
        
        UIImage *finishImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //Отсылаем изображение на email пользователя
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = (id)self;
        [mailManager sendMessageWithTitle:@"Активация от Art of Individuality" text:@"Монограмма" image:finishImage filename:@"monogram.png"];*/
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
    return [fontNames count];
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

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    /*CGSize windowSize = image.size;
    if(image.size.width == 0) windowSize = CGSizeMake(1024.0, 768.0);
    
    UIGraphicsBeginImageContextWithOptions(windowSize, NO, 2.0);
    [image drawInRect:CGRectMake(0,0,windowSize.width,windowSize.height)];
    CGRect rect = CGRectMake(point.x, point.y, windowSize.width, windowSize.height);
    [[UIColor whiteColor] set];
    
    UIFont *font = [UIFont fontWithName:monogramLabel.font.fontName size:84.0*3.0];
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        CGSize size = [text sizeWithFont:font];
        rect.origin.x = (windowSize.width - size.width)/2;
        rect.origin.y = (windowSize.height - size.height)/2;
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor whiteColor]};
        [text drawInRect:rect withAttributes:att];
    }
    else
    {
        //legacy support
        [text drawInRect:CGRectIntegral(rect) withFont:font];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    /*CGSize paperSize = CGSizeMake(571.0, 791.0);
    CGRect textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
    
    UIGraphicsBeginImageContextWithOptions(paperSize, NO, 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, paperSize.width, paperSize.height));
    
    UIFont *font = [UIFont fontWithName:monogramLabel.font.fontName size:84.0*3.0];
    CGSize size = [text sizeWithFont:font];
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor blueColor]};
        size = [text sizeWithAttributes:att];
        textRect.origin.x = (paperSize.width - size.width)/2;
        textRect.origin.y = 120.0 + (400.0 - size.height)/2;

        [text drawInRect:textRect withAttributes:att];
    }
    else
    {
        //legacy support
        [text drawInRect:CGRectIntegral(textRect) withFont:font];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
    font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        size = [names sizeWithAttributes:att];
        textRect.origin.x = (paperSize.width - size.width)/2;
        textRect.origin.y = 120.0+400.0+128.0;
        
        [names drawInRect:textRect withAttributes:att];
    }
    else
    {
        //legacy support
        [text drawInRect:CGRectIntegral(textRect) withFont:font];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;*/
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    myLabel.text = monogramLabel.text;
    myLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:_fontIndex] size:84.0*2.5];
    myLabel.textColor = monogramLabel.textColor;
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.adjustsFontSizeToFitWidth = YES;
    myLabel.minimumScaleFactor = 0.5;
    //[myLabel sizeToFit];
    myLabel.frame = CGRectMake(0, 0, 571.0, myLabel.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(myLabel.bounds.size, myLabel.opaque, 0.0);
    //CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, myLabel.frame.size.height);
    //CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    [myLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGSize paperSize = CGSizeMake(571.0, 791.0);
    
    UIGraphicsBeginImageContextWithOptions(paperSize, NO, 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, paperSize.width, paperSize.height));
    
    [layerImage drawInRect:CGRectMake((paperSize.width - layerImage.size.width)/2,
                                      120.0 + (400.0 - layerImage.size.height)/2,
                                      layerImage.size.width,
                                      layerImage.size.height)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
    UIFont *font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    CGRect textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
    CGFloat oneHeight = 0;
    if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor whiteColor]};
        CGSize size = [names sizeWithAttributes:att];
        oneHeight = size.height;
        
        textRect.origin.x = (paperSize.width - size.width)/2;
        textRect.origin.y = 120.0+400.0;
        
        [names drawInRect:textRect withAttributes:att];
    }
    
    names = @"The Art of Individuality*";
    font = [UIFont fontWithName:@"MyriadPro-Cond" size:20.0];
    textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
    if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor whiteColor]};
        CGSize size = [names sizeWithAttributes:att];
        textRect.origin.x = (paperSize.width - size.width)/2;
        textRect.origin.y = 120.0+400.0+oneHeight+5.0;
        
        [names drawInRect:textRect withAttributes:att];
    }
    
    names = @"*Индивидуальность как искусство";
    font = [UIFont fontWithName:@"MyriadPro-Cond" size:15.0];
    textRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
    if([names respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor whiteColor]};
        CGSize size = [names sizeWithAttributes:att];
        textRect.origin.x = (paperSize.width - size.width)-10;
        textRect.origin.y = paperSize.height-7-size.height;
        
        [names drawInRect:textRect withAttributes:att];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
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
