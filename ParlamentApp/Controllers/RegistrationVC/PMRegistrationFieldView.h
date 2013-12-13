//
//  PMRegistrationFieldView.h
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SHSPhoneComponent/SHSPhoneLibrary.h>

typedef enum
{
    kPhoneField = 1
    
} FieldType;

@interface PMRegistrationFieldView : UIView

@property (nonatomic, assign) UITextField *titleField;

-(id) initWithPlaceholder:(NSString*)title subTitle:(NSString*)subTitle withType:(FieldType)type;

@end
