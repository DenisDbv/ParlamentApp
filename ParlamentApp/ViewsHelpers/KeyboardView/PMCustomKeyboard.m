//
//  PMCustomKeyboard.m
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMCustomKeyboard.h"

@implementation PMCustomKeyboard
@synthesize textView = _textView;

#define kFont [UIFont fontWithName:@"MyriadPro-Cond" size:27]
#define kColor [UIColor colorWithRed:216.0/255.0 green:219.0/255.0 blue:228.0/255.0 alpha:1.0]
#define kChar @[ @"Й", @"Ц", @"У", @"К", @"Е", @"Н", @"Г", @"Ш", @"Щ", @"З", @"Х", @"Ъ", @"Ф", @"Ы", @"В", @"А", @"П", @"Р", @"О", @"Л", @"Д", @"Ж", @"Э", @"Я", @"Ч", @"С", @"М", @"И", @"Т", @"Ь", @"Б", @"Ю", @"-", @" " ]
#define kCharEng @[ @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"_", @"Z", @"X", @"C", @"V", @"B", @"N", @"M", @".", @"-", @"@", @" "]
#define kNumberChar @[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]

- (id)init {
    
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	CGRect frame;
    
	if(UIDeviceOrientationIsLandscape(orientation))
        frame = CGRectMake(0, 0, 1024, 352);
    else
        frame = CGRectMake(0, 0, 768, 264);
	
	self = [super initWithFrame:frame];
	
	if (self) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PMCustomKeyboard" owner:self options:nil];
		[[nib objectAtIndex:0] setFrame:frame];
        self = [nib objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.isRu = YES;
	
    [self loadCharactersWithArray:kChar];
    [self loadNumberCharactersWithArray:kNumberChar];
    [self refreshLanguageTitleOnButton];
    
    [self.deleteButton setTitle:@"УДАЛИТЬ" forState:UIControlStateNormal];
    [self.deleteButton.titleLabel setFont:kFont];
	self.deleteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIEdgeInsets btnEdge = self.deleteButton.titleEdgeInsets;
    btnEdge.top += 4;
    [self.deleteButton setTitleEdgeInsets:btnEdge];
    
	return self;
}

-(void)loadCharactersWithArray:(NSArray *)a
{
	int i = 0;
	for (UIButton *b in self.characterKeys) {
        
        if(b.tag == 2 && !self.isRu) {
            
        }
        else
        {
            [b setTitle:[a objectAtIndex:i] forState:UIControlStateNormal];
            [b.titleLabel setFont:kFont];
            
            UIEdgeInsets btnEdge = b.titleEdgeInsets;
            btnEdge.top = 4;
            [b setTitleEdgeInsets:btnEdge];
            
            [b addTarget:self action:@selector(characterPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            i++;
        }
	}
}

-(void)loadNumberCharactersWithArray:(NSArray *)a
{
	int i = 0;
	for (UIButton *b in self.numberKeys) {
        
		[b setTitle:[a objectAtIndex:i] forState:UIControlStateNormal];
        [b.titleLabel setFont:kFont];
        
        UIEdgeInsets btnEdge = b.titleEdgeInsets;
        btnEdge.top += 4;
        [b setTitleEdgeInsets:btnEdge];
        
        [b addTarget:self action:@selector(numCharacterPressed:) forControlEvents:UIControlEventTouchUpInside];
        
		i++;
	}
}

-(void) refreshLanguageTitleOnButton
{
    [self.languageButton setTitle:((self.isRu)?@"ENG":@"RU") forState:UIControlStateNormal];
    [self.languageButton.titleLabel setFont:kFont];
	self.languageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIEdgeInsets btnEdge = self.languageButton.titleEdgeInsets;
    btnEdge.top = 4;
    [self.languageButton setTitleEdgeInsets:btnEdge];
}

- (BOOL) enableInputClicksWhenVisible {
    return YES;
}

-(void)setTextView:(id<UITextInput>)textView {
	
	if ([textView isKindOfClass:[UITextView class]])
        [(UITextView *)textView setInputView:self];
    else if ([textView isKindOfClass:[UITextField class]])
        [(UITextField *)textView setInputView:self];
    
    _textView = textView;
}

-(id<UITextInput>)textView {
	return _textView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (UIDevice.currentDevice.systemVersion.floatValue >= 7 &&
        newSuperview != nil)
    {
        CALayer *layer = newSuperview.layer;
        NSArray *subls = layer.sublayers;
        CALayer *blurLayer = [subls objectAtIndex:0];
        [blurLayer setOpacity:0];
    }
}

- (void) characterPressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
	UIButton *button = (UIButton *)sender;
	NSString *character = [NSString stringWithString:button.titleLabel.text];
    
    [self.textView insertText:character];
	
	if ([self.textView isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
	else if ([self.textView isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (void) numCharacterPressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
	UIButton *button = (UIButton *)sender;
	NSString *character = [NSString stringWithString:button.titleLabel.text];
    
    [self.textView insertText:character];
	
	if ([self.textView isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
	else if ([self.textView isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (IBAction)deletePressed:(id)sender
{
    [[UIDevice currentDevice] playInputClick];
	[self.textView deleteBackward];
	[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification
														object:self.textView];
	if ([self.textView isKindOfClass:[UITextView class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
	else if ([self.textView isKindOfClass:[UITextField class]])
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
}

- (IBAction)languagePressed:(id)sender
{
    [self flipCharacterButtons];
}

-(void) flipCharacterButtons
{
    self.isRu = !self.isRu;
    [self loadCharactersWithArray:((self.isRu)?kChar:kCharEng)];
    [self refreshLanguageTitleOnButton];
    
    for (UIButton *b in self.characterKeys) {
        
        if(b.tag == 1) continue;
        
        if(b.tag == 2 && !self.isRu)
            b.alpha = 0;
        else
            b.alpha = 1;
        
        [UIView beginAnimations:@"Flip" context:NULL];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:((self.isRu)?UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft) forView:b cache:NO];
        //[UIView setAnimationDidStopSelector:@selector(stopButton)];
        
        [UIView commitAnimations];
    }
}

@end
