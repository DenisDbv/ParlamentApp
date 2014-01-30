//
//  PMChooseFontVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMParentController.h"
#import <iCarousel/iCarousel.h>

@interface PMChooseFontVC : PMParentController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *monogramLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UIView *carouselContainer;

@property (strong, nonatomic) IBOutlet UILabel *finishTitle1;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle2;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle3;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle4;
@property (strong, nonatomic) IBOutlet UILabel *finishTitle5;

@property (nonatomic, strong) IBOutlet UIImageView *blueLineImageView;

-(id) initWithInitials:(NSString*)initials;

@end
