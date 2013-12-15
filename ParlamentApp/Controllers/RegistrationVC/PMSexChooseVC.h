//
//  PMSexChooseVC.h
//  ParlamentApp
//
//  Created by DenisDbv on 16.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMSexChooseDelefate <NSObject>
-(void) didSelectSex:(NSString*)sexString;
@end

@interface PMSexChooseVC : UIViewController

@property (nonatomic, strong) id <PMSexChooseDelefate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *wBtn;
@property (strong, nonatomic) IBOutlet UIButton *mBtn;

@end
