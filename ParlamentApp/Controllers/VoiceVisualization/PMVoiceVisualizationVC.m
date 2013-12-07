//
//  PMVoiceVisualizationVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMVoiceVisualizationVC.h"
#import <MZFormSheetController/MZFormSheetController.h>

@interface PMVoiceVisualizationVC ()

@end

@implementation PMVoiceVisualizationVC

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButton:(id)sender {
    [self.formSheetController dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //[formSheetController dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
