//
//  PMSexChooseVC.m
//  ParlamentApp
//
//  Created by DenisDbv on 16.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMSexChooseVC.h"

@interface PMSexChooseVC ()

@end

@implementation PMSexChooseVC

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
    
    self.wBtn.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:33.0];
    self.mBtn.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:33.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onWoman:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didSelectSex:)])
    {
        [self.delegate didSelectSex:@"ЖЕНСКИЙ"];
    }
}

- (IBAction)onMan:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didSelectSex:)])
    {
        [self.delegate didSelectSex:@"МУЖСКОЙ"];
    }
}
@end
