//
//  PMRegistrationVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMParentController.h"

@interface PMRegistrationVC : PMParentController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITableView *tableViewW;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

@property (nonatomic, assign) BOOL isExitToMenu;

@end
