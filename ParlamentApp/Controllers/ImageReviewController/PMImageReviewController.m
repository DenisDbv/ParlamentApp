//
//  PMImageReviewController.m
//  ParlamentApp
//
//  Created by DenisDbv on 20.02.14.
//  Copyright (c) 2014 brandmill. All rights reserved.
//

#import "PMImageReviewController.h"
#import "UIImage+UIImageFunctions.h"

@interface PMImageReviewController ()

@end

@implementation PMImageReviewController
{
    UIButton *backButton;
    UIButton *sendButton;
    
    UIImage *_resultImage;
    NSString *_textEmail;
    NSString *_fileNameEmail;
    MailToEnums _enumEmail;
    
    UIActivityIndicatorView *saveIndicator;
    
    PMMailManager *mailManager;
    
    BOOL ret;
}
@synthesize delegate;

-(id) initWithImage:(UIImage*)imageReview :(NSString*)text :(NSString*)fileName :(MailToEnums)mailEnum
{
    self = [super initWithNibName:@"PMImageReviewController" bundle:nil];
    if (self)
    {
        _resultImage = imageReview;
        _textEmail = text;
        _fileNameEmail = fileName;
        _enumEmail = mailEnum;
        
        ret = NO;
        NSLog(@"INIT!");
    }
    return self;
}

-(id) initWithImage2:(UIImage*)imageReview :(NSString*)text :(NSString*)fileName :(MailToEnums)mailEnum
{
    self = [super initWithNibName:@"PMImageReviewController" bundle:nil];
    if (self)
    {
        _resultImage = imageReview;
        _textEmail = text;
        _fileNameEmail = fileName;
        _enumEmail = mailEnum;
        
        ret = YES;
        NSLog(@"INIT!");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"bvjabvdajskbvjkdsabvjkdsbvkjdsbvjkdsbvdsjkabvds");
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImage *backImage = [[UIImage imageNamed:@"siluet-back.png"] scaleProportionalToRetina];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.alpha = 0;
    [backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImage:backImage forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(10, self.view.center.y-backImage.size.height/2-10, backImage.size.width, backImage.size.height);
    [self.view addSubview:backButton];
    
    UIImage *sendImageButton = [[UIImage imageNamed:@"further.png"] scaleProportionalToRetina];
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //sendButton.alpha = 0;
    [sendButton addTarget:self action:@selector(onSendImage:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setImage:sendImageButton forState:UIControlStateNormal];
    [sendButton setImage:sendImageButton forState:UIControlStateHighlighted];
    sendButton.frame = CGRectMake(self.view.bounds.size.width-sendImageButton.size.width-20, self.view.center.y-sendImageButton.size.height/2-10, sendImageButton.size.width, sendImageButton.size.height);
    [self.view addSubview:sendButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_resultImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height-40);
    imageView.frame = CGRectOffset(imageView.frame, (self.view.frame.size.width-imageView.frame.size.width)/2, (self.view.frame.size.height-imageView.frame.size.height)/2);
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onBack:(UIButton*)sender
{
    NSLog(@"omBack");
    
    CGPoint location = sender.center;
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
    if([self.delegate respondsToSelector:@selector(backFromReviewController)])
    {
        [self.delegate backFromReviewController];
    }
    
    if(!ret)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
        
        [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
    }
}

-(void) onSendImage:(UIButton*)sender
{
    NSLog(@"onSend!");
    
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
    
    backButton.alpha = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *names = [NSString stringWithFormat:@"%@ %@", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
        //Отсылаем изображение на email пользователя
        mailManager = [[PMMailManager alloc] init];
        mailManager.delegate = (id)self;
        [mailManager sendMessageWithTitle:names text:_textEmail image:_resultImage filename:_fileNameEmail toPerson:_enumEmail];
    });
}

-(void) mailSendSuccessfully
{
    [saveIndicator stopAnimating];
    [saveIndicator removeFromSuperview];
    
    if([self.delegate respondsToSelector:@selector(sendSuccessfulFromReviewController)])
    {
        [self.delegate sendSuccessfulFromReviewController];
    }
    
    if(!ret)
        [self.navigationController popViewControllerAnimated:NO];
    else
    {
        self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
        
        [self dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
            //
        }];
    }
}

-(void) mailSendFailed
{
    [saveIndicator stopAnimating];
    [saveIndicator removeFromSuperview];
    
    backButton.alpha = 1;
    
    [sendButton setEnabled:YES];
    UIImage *sendImageButton = [[UIImage imageNamed:@"further.png"] scaleProportionalToRetina];
    [sendButton setImage:sendImageButton forState:UIControlStateNormal];
    [sendButton setImage:sendImageButton forState:UIControlStateHighlighted];
}

@end
