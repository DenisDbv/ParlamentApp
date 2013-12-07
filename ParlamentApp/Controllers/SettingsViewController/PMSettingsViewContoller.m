//
//  PMSettingsViewContoller.m
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMSettingsViewContoller.h"
#import "PMVoiceVisualizationVC.h"
#import <MZFormSheetController/MZFormSheetController.h>

@interface PMSettingsViewContoller ()

@end

@implementation PMSettingsViewContoller

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onButton:(id)sender
{
    PMVoiceVisualizationVC *settingVC = [[PMVoiceVisualizationVC alloc] initWithNibName:@"PMVoiceVisualizationVC" bundle:[NSBundle mainBundle]];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:settingVC];
    [formSheet presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
}
@end
