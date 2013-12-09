//
//  PMVoiceVisualizationVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMParentController.h"
#import "ATTRactorView.h"

@interface PMVoiceVisualizationVC : PMParentController <ATTRactorViewDelegate>

@property (nonatomic, strong) IBOutlet ATTRactorView *attractorView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel1;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel2;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel3;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel4;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) IBOutlet UIView *finishView;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle1;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle2;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle3;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle4;


@end
