//
//  UINavigationController+ClearSlider.h
//  ParlamentApp
//
//  Created by DenisDbv on 06.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ClearSlider)

- (void)pushViewControllerRetro:(UIViewController *)viewController;
- (void)popViewControllerRetro;

@end
