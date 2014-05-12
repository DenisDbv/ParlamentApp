//
//  PMFingerVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 10.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMParentController.h"

@interface PMFingerVC : PMParentController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *onClose;
@property (strong, nonatomic) IBOutlet UIButton *onFurther;

@end
