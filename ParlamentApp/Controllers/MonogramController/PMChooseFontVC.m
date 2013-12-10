//
//  PMChooseFontVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMChooseFontVC.h"
#import "UIImage+UIImageFunctions.h"

@interface PMChooseFontVC ()

@end

@implementation PMChooseFontVC
{
    NSArray *fontImages;
    NSArray *fontNames;
    
    UIActivityIndicatorView *saveIndicator;
}
@synthesize titleLabel;
@synthesize monogramLabel;
@synthesize carousel;
@synthesize carouselContainer;
@synthesize closeBtn, saveBtn;
@synthesize finishTitle1, finishTitle2, finishTitle3, finishTitle4, finishTitle5;

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
    
    fontImages = @[@"adineki", @"bedini", @"acquests", @"adventur", @"agatha", @"alexandr", @"ampir", @"andantino", @"annabel", @"aquarelle", @"ariston", @"veron"];
    fontNames = @[@"AdineKirnberg", @"Bedini", @"AcquestScript", @"Adventure", @"Agatha-Modern", @"AlexandraZeferinoThree", @"AmpirDeco", @"Andantinoscript", @"Annabelle", @"Aquarelle", @"Ariston-Normal", @"Veron"];
    
    carousel.type = iCarouselTypeLinear;
    
    titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:30.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    monogramLabel.font = [UIFont fontWithName:@"AdineKirnberg" size:84];
    
    [carousel reloadData];
    
    //finishTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(217, 206, 595, 63)];
    //finishTitle1.text = @"MONOGRAM - МОНОГРАММА ВИЗУАЛИЗАЦИЯ ВАШЕЙ МОНОГРАММЫ УСПЕШНА СОХРАНЕНА";
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
    
    [self performSelector:@selector(finishSavingMonogram) withObject:nil afterDelay:1.0];
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
