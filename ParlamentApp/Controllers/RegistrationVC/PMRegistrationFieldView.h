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
    kNoKeyboard = 1,
    kPhoneField = 2
    
} FieldType;

@protocol PMRegistrationFieldViewDelegate <NSObject>
-(void) didSelectPMRegistrationField:(UIView*)fieldView;
@end

@interface PMRegistrationFieldView : UIView

@property (nonatomic, strong) id <PMRegistrationFieldViewDelegate> delegate;
@property (nonatomic, strong) UITextField *titleField;

-(id) initWithPlaceholder:(NSString*)title subTitle:(NSString*)subTitle withType:(FieldType)type;

@end
