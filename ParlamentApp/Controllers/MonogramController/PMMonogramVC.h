//
//  PMMonogramVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 09.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMParentController.h"

@interface PMMonogramVC : PMParentController

@property (strong, nonatomic) IBOutlet UIButton *onClose;
@property (strong, nonatomic) IBOutlet UIView *initialContainerView;
@property (strong, nonatomic) IBOutlet UITextField *initialTextField;
@property (strong, nonatomic) IBOutlet UIButton *onFurther;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end
