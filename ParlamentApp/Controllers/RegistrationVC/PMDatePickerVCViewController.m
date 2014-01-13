//
//  PMDatePickerVCViewController.m
//  ParlamentApp
//
//  Created by DenisDbv on 15.12.13.
//  Copyright (c) 2013 brandmill. All rights reserved.
//

#import "PMDatePickerVCViewController.h"
#import "FlatDatePicker.h"

@interface PMDatePickerVCViewController () <FlatDatePickerDelegate>
@property (nonatomic, strong) FlatDatePicker *flatDatePicker;
@end

@implementation PMDatePickerVCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flatDatePicker = [[FlatDatePicker alloc] initWithFrame:self.view.bounds];
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    self.flatDatePicker.hidden = NO;
    self.flatDatePicker.delegate = self;
    [self.view addSubview:self.flatDatePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    if([self.delegate respondsToSelector:@selector(datePickerSetString:withDate:)])
    {
        [self.delegate datePickerSetString:value withDate:date];
    }
}

@end
