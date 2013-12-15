//
//  PMDatePickerVCViewController.h
//  ParlamentApp
//
//  Created by DenisDbv on 15.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMDatePickerVCViewControllerDelegate <NSObject>
-(void) datePickerSetString:(NSString*)dateText;
@end

@interface PMDatePickerVCViewController : UIViewController

@property (nonatomic, strong) id <PMDatePickerVCViewControllerDelegate> delegate;

@end
