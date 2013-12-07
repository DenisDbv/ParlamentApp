//
//  PMRootViewController.m
//  ParlamentApp
//
//  Created by DenisDbv on 07.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMRootViewController.h"
#import "PMRootMenuController.h"

@interface PMRootViewController ()

@end

@implementation PMRootViewController

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
    
    [self windowInitiailization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) windowInitiailization
{
    PMRootMenuController *rootMenuViewController = [[PMRootMenuController alloc] initWithNibName:@"PMRootMenuController" bundle:[NSBundle mainBundle]];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:self.view.bounds.size viewController:rootMenuViewController];
    [formSheet presentFormSheetController:formSheet animated:NO completionHandler:^(MZFormSheetController *formSheetController) {
        NSLog(@"Root menu view controller present");
    }];
}

@end
