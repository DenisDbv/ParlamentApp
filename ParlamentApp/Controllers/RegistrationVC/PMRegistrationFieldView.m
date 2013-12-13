//
//  PMRegistrationFieldView.m
//  ParlamentApp
//
//  Created by DenisDbv on 12.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMRegistrationFieldView.h"
#import "UIImage+UIImageFunctions.h"
#import "UIView+GestureBlocks.h"

@implementation PMRegistrationFieldView
{
    NSString *_title;
    NSString *_subTitle;
    FieldType _type;
}
@synthesize titleField;

-(id) initWithPlaceholder:(NSString*)title subTitle:(NSString*)subTitle withType:(FieldType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _subTitle = subTitle;
        _type = type;
        
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"reg-field.png"] scaleProportionalToRetina];
    self.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    [self addSubview:[[UIImageView alloc] initWithImage:backgroundImage]];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = _subTitle;
    subTitleLabel.font = [UIFont fontWithName:@"MyriadPro-Cond" size:10.0];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor colorWithRed:177.0/255.0 green:185.0/255.0 blue:202.0/255.0 alpha:1.0];
    subTitleLabel.frame = CGRectOffset(subTitleLabel.frame, 19.0, 44.0);
    [subTitleLabel sizeToFit];
    [self addSubview:subTitleLabel];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(19.0, 17.0, self.frame.size.width-30, 21)];
    if(_type == kPhoneField)    {
        titleField = [[SHSPhoneTextField alloc] initWithFrame:CGRectMake(19.0, 17.0, self.frame.size.width-30, 21)];
        [((SHSPhoneTextField*)titleField).formatter setDefaultOutputPattern:@"+# (###) ###-##-##"];
    }
    titleField.placeholder = _title;
    UIColor *color = [UIColor colorWithRed:50.0/255.0 green:72.0/255.0 blue:106.0/255.0 alpha:1.0];
    titleField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_title attributes:@{NSForegroundColorAttributeName: color}];
    titleField.font = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
    titleField.backgroundColor = [UIColor clearColor];
    [self addSubview:titleField];
    
    [self initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [titleField becomeFirstResponder];
    } forTaps:1];
    
    [subTitleLabel initialiseTapHandler:^(UIGestureRecognizer *sender) {
        [titleField becomeFirstResponder];
    } forTaps:1];
}

@end
