//
//  PMSiluetVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 10.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMSiluetVC.h"

#import <PBJVision/PBJVision.h>
#import <PBJVision/PBJVisionUtilities.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>
#import <CoreImage/CoreImage.h>

#import "UIImage+UIImageFunctions.h"
#import "UIColor+HSVAdditions.h"

@interface PMSiluetVC () <UIGestureRecognizerDelegate, PBJVisionDelegate>
@property (nonatomic, strong) NSDictionary *_photoDict;
@property (nonatomic, strong) UIImage *_finalImage;
@end

@implementation PMSiluetVC
{
    UIView *_previewView;
    AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIButton *captureButton;
    UIButton *recaptureButton;
    UIButton *savePhoto;
    
    UIView *imageContainer;
    ALAssetsLibrary *_assetLibrary;
    
    PMMailManager *mailManager;
}
@synthesize _photoDict;
@synthesize _finalImage;
@synthesize finishTitle1, finishTitle2, finishTitle3, finishTitle4, finishTitle5;
@synthesize onBackToRootMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
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
    
    onBackToRootMenu.alpha = 0;
    
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    
    [self initPreviewView];
    [self initCaptureButton];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[PBJVision sharedInstance] stopPreview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) orientationChanged:(NSNotification *)note
{
    PBJVision *vision = [PBJVision sharedInstance];
    
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"left");
            [vision setCameraOrientation:PBJCameraOrientationLandscapeRight];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"right");
            [vision setCameraOrientation:PBJCameraOrientationLandscapeLeft];

            break;
            
        default:
            break;
    };
}

-(void) initPreviewView
{
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame));
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
}

-(void) initCaptureButton
{
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"siluet-photo-make.png"] scaleProportionalToRetina];
    captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    captureButton.alpha = 0.0f;
    [captureButton addTarget:self action:@selector(onTakeCapture:) forControlEvents:UIControlEventTouchUpInside];
    [captureButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [captureButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    captureButton.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y-saveVoiceImage.size.height/2, saveVoiceImage.size.width, saveVoiceImage.size.height);
    [_previewView addSubview:captureButton];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
        captureButton.alpha = 1.0;
        captureButton.frame = CGRectMake(self.view.bounds.size.width - saveVoiceImage.size.width - 10, self.view.center.y-saveVoiceImage.size.height/2, saveVoiceImage.size.width, saveVoiceImage.size.height);
    } completion:^(BOOL finished) {
    }];
}

-(void) removeCaptureButton//:(void (^)(void))successRemove
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
        captureButton.frame = CGRectOffset(captureButton.frame, 50, 0);
        captureButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [captureButton removeFromSuperview];
        //successRemove();
    }];
}

-(void) initPostCaptureButtons
{
    UIImage *recaptureImage = [[UIImage imageNamed:@"siluet-back.png"] scaleProportionalToRetina];
    recaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recaptureButton.alpha = 0;
    [recaptureButton addTarget:self action:@selector(onTakeRecapture:) forControlEvents:UIControlEventTouchUpInside];
    [recaptureButton setImage:recaptureImage forState:UIControlStateNormal];
    [recaptureButton setImage:recaptureImage forState:UIControlStateHighlighted];
    recaptureButton.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y-recaptureImage.size.height-10, recaptureImage.size.width, recaptureImage.size.height);
    [_previewView addSubview:recaptureButton];
    
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"siluet-accept.png"] scaleProportionalToRetina];
    savePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    savePhoto.alpha = 0;
    [savePhoto addTarget:self action:@selector(onSavePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [savePhoto setImage:saveVoiceImage forState:UIControlStateNormal];
    [savePhoto setImage:saveVoiceImage forState:UIControlStateHighlighted];
    savePhoto.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y+10, saveVoiceImage.size.width, saveVoiceImage.size.height);
    [_previewView addSubview:savePhoto];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
        recaptureButton.alpha = 1.0;
        savePhoto.alpha = 1.0;
        recaptureButton.frame = CGRectMake(self.view.bounds.size.width - recaptureImage.size.width - 10, self.view.center.y-recaptureImage.size.height-10, recaptureImage.size.width, recaptureImage.size.height);
        savePhoto.frame = CGRectMake(self.view.bounds.size.width - saveVoiceImage.size.width - 19, self.view.center.y+10, saveVoiceImage.size.width, saveVoiceImage.size.height);
    } completion:^(BOOL finished) {
    }];
}

-(void) removePostCaptureButton
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
        recaptureButton.frame = CGRectOffset(recaptureButton.frame, 50, 0);
        recaptureButton.alpha = 0.0;
        savePhoto.frame = CGRectOffset(savePhoto.frame, 50, 0);
        savePhoto.alpha = 0.0;
    } completion:^(BOOL finished) {
        [recaptureButton removeFromSuperview];
        [savePhoto removeFromSuperview];
        //successRemove();
    }];
}

-(void) initFinishSaveButton
{
    UIImage *saveVoiceImage = [[UIImage imageNamed:@"siluet-save.png"] scaleProportionalToRetina];
    captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    captureButton.alpha = 0.0;
    [captureButton addTarget:self action:@selector(onFinishSavePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [captureButton setImage:saveVoiceImage forState:UIControlStateNormal];
    [captureButton setImage:saveVoiceImage forState:UIControlStateHighlighted];
    captureButton.frame = CGRectMake(self.view.bounds.size.width, self.view.center.y-saveVoiceImage.size.height/2, saveVoiceImage.size.width, saveVoiceImage.size.height);
    [self.view addSubview:captureButton];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationCurveLinear animations:^{
        captureButton.alpha = 1.0;
        captureButton.frame = CGRectMake(self.view.bounds.size.width - saveVoiceImage.size.width - 10, self.view.center.y-saveVoiceImage.size.height/2, saveVoiceImage.size.width, saveVoiceImage.size.height);
    } completion:^(BOOL finished) {
    }];

}

-(void) onTakeCapture:(UIButton*)sender
{
    [self tapAnimate:sender withBlock:nil];

    [[PBJVision sharedInstance] capturePhoto];
}

-(void) onTakeRecapture:(UIButton*)sender
{
    [self tapAnimate:sender withBlock:nil];
    
    [[PBJVision sharedInstance] unfreezePreview];
    
    [self removePostCaptureButton];
    
    [self initCaptureButton];
}

-(void) onSavePhoto:(UIButton*)sender
{
    UIImage *exitImage = [[UIImage imageNamed:@"close-voice.png"] scaleProportionalToRetina];
    [recaptureButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [recaptureButton setImage:exitImage forState:UIControlStateNormal];
    [recaptureButton setImage:exitImage forState:UIControlStateHighlighted];
    
    UIImage *clearImage = [[UIImage imageNamed:@"clear_button.png"] scaleProportionalToRetina];
    [sender setImage:clearImage forState:UIControlStateNormal];
    [sender setImage:clearImage forState:UIControlStateHighlighted];
    
    UIActivityIndicatorView *saveIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_previewView addSubview:saveIndicator];
    saveIndicator.center = sender.center;
    [saveIndicator startAnimating];
    
    [self tapAnimate:sender withBlock:nil];
    
    //[self imageProcessing];
    [self imageSend];
    
    PMTimeManager *timeManager = [[PMTimeManager alloc] init];
    finishTitle5.text = [NSString stringWithFormat:@"СПАСИБО И %@!", [timeManager titleTimeArea]];
}

-(void) exit
{
    self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
    [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}

-(void) onFinishSavePhoto:(UIButton*)sender
{
    [self tapAnimate:sender withBlock:nil];
    
    sender.hidden = YES;
    imageContainer.hidden = YES;
    
    PMTimeManager *timeManager = [[PMTimeManager alloc] init];
    finishTitle5.text = [NSString stringWithFormat:@"СПАСИБО И %@!", [timeManager titleTimeArea]];
    
    [self savePhotoToAlbum:_finalImage completionBlock:^{
        finishTitle1.alpha = finishTitle2.alpha = finishTitle3.alpha = finishTitle4.alpha = finishTitle5.alpha = 1.0;
        onBackToRootMenu.alpha = 1.0;
    }];
}

- (void)_resetCapture
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack]) {
        [vision setCameraDevice:PBJCameraDeviceBack];
    } else {
        [vision setCameraDevice:PBJCameraDeviceFront];
    }
    
    [vision setCameraMode:PBJCameraModePhoto];
    [vision setCameraOrientation:PBJCameraOrientationLandscapeRight];
    [vision setFocusMode:PBJFocusModeContinuousAutoFocus];
    [vision setOutputFormat:PBJOutputFormatSquare];
    [vision setVideoRenderingEnabled:YES];
}

#pragma mark - PBJVisionDelegate

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
    if (![_previewView superview]) {
        [self.view addSubview:_previewView];
    }
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
    [_previewView removeFromSuperview];
}

- (void)visionModeWillChange:(PBJVision *)vision
{
}

- (void)visionModeDidChange:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture
{
}

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{

}

- (void)visionWillCapturePhoto:(PBJVision *)vision
{
    NSLog(@"START");
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
    NSLog(@"END");
    [self removeCaptureButton];
    [self initPostCaptureButtons];
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    _photoDict = photoDict;
    
    /*[_assetLibrary writeImageToSavedPhotosAlbum:(__bridge CGImageRef)[_photoDict objectForKey:PBJVisionPhotoImageKey] metadata:[photoDict  objectForKey:PBJVisionPhotoMetadataKey] completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"saved! %@", error);
    }];*/
}

void rgbToHSV(float rgb[3], float hsv[3])
{
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    //float *h = hsv[0], *s = hsv[1], *v = hsv[2];
    
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    hsv[2] = max;               // v
    delta = max - min;
    if( max != 0 )
        hsv[1] = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        hsv[1] = 0;
        hsv[0] = -1;
        return;
    }
    if( r == max )
        hsv[0] = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        hsv[0] = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        hsv[0] = 4 + ( r - g ) / delta; // between magenta & cyan
    hsv[0] *= 60;               // degrees
    if( hsv[0] < 0 )
        hsv[0] += 360;
    //hsv[0] /= 360.0;
}

-(void) imageProcessing
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        float minHueAngle = 100.0;
        float maxHueAngle = 130.0;
        // Allocate memory
        const unsigned int size = 64;
        float *cubeData = (float *)malloc (size * size * size * sizeof (float) * 4);
        float rgb[3], hsv[3];
        float *c = cubeData;
        /*struct rgb_color rgb;
         struct hsv_color hsv;
         
         // Populate cube with a simple gradient going from 0 to 1
         for (int z = 0; z < size; z++){
         rgb.b = ((double)z)/(size-1); // Blue value
         for (int y = 0; y < size; y++){
         rgb.g = ((double)y)/(size-1); // Green value
         for (int x = 0; x < size; x ++){
         rgb.r = ((double)x)/(size-1); // Red value
         // Convert RGB to HSV
         // You can find publicly available rgbToHSV functions on the Internet
         //rgbToHSV(rgb, hsv);
         hsv = [UIColor HSVfromRGB:rgb];
         //NSLog(@"%f %f %f = %f %f %f", rgb.r, rgb.g, rgb.b, hsv.hue, hsv.sat, hsv.val);
         
         // Use the hue value to determine which to make transparent
         // The minimum and maximum hue angle depends on
         // the color you want to remove
         //NSLog(@"%f", hsv.hue);
         float alpha = (hsv.hue > minHueAngle && hsv.hue < maxHueAngle) ? 0.0f:1.0f;
         // Calculate premultiplied alpha values for the cube
         c[0] = rgb.r * alpha;
         c[1] = rgb.g * alpha;
         c[2] = rgb.b * alpha;
         c[3] = alpha;
         c += 4; // advance our pointer into memory for the next color value
         }
         }
         }*/
        
        for (int z = 0; z < size; z++){
            rgb[2] = ((double)z)/(size-1); // Blue value
            for (int y = 0; y < size; y++){
                rgb[1] = ((double)y)/(size-1); // Green value
                for (int x = 0; x < size; x ++){
                    rgb[0] = ((double)x)/(size-1); // Red value
                    // Convert RGB to HSV
                    // You can find publicly available rgbToHSV functions on the Internet
                    rgbToHSV(rgb, hsv);
                    // Use the hue value to determine which to make transparent
                    // The minimum and maximum hue angle depends on
                    // the color you want to remove
                    //NSLog(@"%f", hsv[0]);
                    float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f:1.0f;
                    // Calculate premultiplied alpha values for the cube
                    c[0] = rgb[0] * alpha;
                    c[1] = rgb[1] * alpha;
                    c[2] = rgb[2] * alpha;
                    c[3] = alpha;
                    c += 4; // advance our pointer into memory for the next color value
                }
            }
        }
        
        /*float rgb2[3], hsv2[3];
        rgb2[0] = 0.68;
        rgb2[1] = 0.96;
        rgb2[2] = 0.99;
        rgbToHSV(rgb2, hsv2);
        NSLog(@"==> %f %f %f", hsv2[0], hsv2[1], hsv2[2]);*/
        
        // Create memory with the cube data
        NSData *data = [NSData dataWithBytesNoCopy:cubeData
                                            length:size * size * size * sizeof (float) * 4
                                      freeWhenDone:YES];
        CIFilter *colorCube = [CIFilter filterWithName:@"CIColorCube"];
        [colorCube setValue:@(size) forKey:@"inputCubeDimension"];
        // Set data for cube
        [colorCube setValue:data forKey:@"inputCubeData"];
        
        UIImage *image = [_photoDict objectForKey:PBJVisionPhotoImageKey];//[UIImage imageNamed:@"test.png"]; //
        CIImage *beginImage = [[CIImage alloc] initWithImage:image];
        
        [colorCube setValue:beginImage forKey:kCIInputImageKey];
        CIImage *result = [colorCube valueForKey:kCIOutputImageKey];
        _finalImage = [UIImage imageWithCIImage:result];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [[PBJVision sharedInstance] stopPreview];
            
            imageContainer = [[UIView alloc] initWithFrame:self.view.bounds];
            imageContainer.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageContainer.bounds];
            [imageView setImage:_finalImage];
            [imageContainer addSubview:imageView];
            [self.view addSubview:imageContainer];
            
            [self initFinishSaveButton];
        });
    });
}

-(void) imageSend
{
    mailManager = [[PMMailManager alloc] init];
    mailManager.delegate = self;
    
    UIImage *image = [_photoDict objectForKey:PBJVisionPhotoImageKey];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *title = [NSString stringWithFormat:@"Силуэт (%@ %@)", [userDefaults objectForKey:@"_firstname"], [userDefaults objectForKey:@"_lastname"]];
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[mailManager sendMessageWithImage:image imageName:@"siluet.png" andTitle:title andText:descText];
        [mailManager sendMessageWithTitle:names text:descText image:image filename:@"siluet.png"];
    });
}

-(void) mailSendSuccessfully
{
    [self performSelector:@selector(finishSavingSiluet) withObject:nil afterDelay:0.0];
}

-(void) mailSendFailed
{
    [self performSelector:@selector(finishSavingSiluet) withObject:nil afterDelay:0.0];
}

-(void) finishSavingSiluet
{
    [[PBJVision sharedInstance] stopPreview];
    
    finishTitle1.alpha = finishTitle2.alpha = finishTitle3.alpha = finishTitle4.alpha = finishTitle5.alpha = 1.0;
    onBackToRootMenu.alpha = 1.0;
}

-(void) savePhotoToAlbum:(UIImage*)image completionBlock:(void (^)(void))block
{
    [_assetLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                       metadata:[_photoDict objectForKey:PBJVisionPhotoMetadataKey]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"saved! %@", error);
                                    block();
    }];
}

- (IBAction)onBackToRootMenu:(UIButton*)sender
{
    [self tapAnimate:sender withBlock:nil];
    CGPoint location = sender.center;
    [[AppDelegateInstance() rippleViewController] myTouchWithPoint:location];
    
     self.formSheetController.transitionStyle = MZFormSheetTransitionStyleFade;
     [self.formSheetController dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
     //
     }];
}
@end
