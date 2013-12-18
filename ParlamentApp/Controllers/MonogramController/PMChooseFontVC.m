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

@interface PMChooseFontVC ()

@end

@implementation PMChooseFontVC
{
    NSString *initialsString;
    
    NSArray *fontImages;
    NSArray *fontNames;
    
    UIActivityIndicatorView *saveIndicator;
    
    PMMailManager *mailManager;
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
    
    monogramLabel.font = [UIFont fontWithName:@"AdineKirnberg" size:84];
    monogramLabel.text = initialsString;
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        UIImage *img = [self drawText:monogramLabel.text inImage:[UIImage imageNamed:@"background1024x768.png"] atPoint:CGPointMake(100, 100)];
        NSLog(@"%@", NSStringFromCGSize(img.size));
       
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = self;
        [mailManager sendMessageWithImage:img imageName:@"test.png" andText:@"Монограмма"];
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
    [saveIndicator stopAnimating];
    [saveIndicator removeFromSuperview];
    
    titleLabel.alpha = saveBtn.alpha = monogramLabel.alpha = carousel.alpha = 0.0;
    
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
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
        view.contentMode = UIViewContentModeCenter;
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    UIImageView *imageView = (UIImageView*)view;
    [imageView setImage:[UIImage imageNamed:[fontImages objectAtIndex:index]]];
    
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
    
    monogramLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:index] size:84];
}

-(void) generateImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        UIImage *img = [self drawText:monogramLabel.text inImage:[UIImage new] atPoint:CGPointMake(100, 100)];
        NSLog(@"%@", NSStringFromCGSize(img.size));
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
            [self.view addSubview:imgView];
            NSLog(@"%@", imgView);
            
        });
    });
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
    
    CGSize paperSize = CGSizeMake(571.0, 791.0);
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
        
        textRect.origin.x = (paperSize.width - size.width)/2;
        textRect.origin.y = 120.0 + (400.0 - size.height)/2;
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor blueColor]};
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
