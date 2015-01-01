//
//  EditViewController.m
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "EditViewController.h"

#import "TimerService.h"

#import "TimerDTO.h"

@interface EditViewController (Import)
- (UIDatePicker *)datePicker;
- (UITextField *)alarmMessageTextField;
- (IBAction)didTapDoneButton:(id)sender;
@end

@interface EditViewController ()

@end

@implementation EditViewController

+ (instancetype)viewControllerWithTimer:(TimerDTO *)timer {
    EditViewController *viewController = [self viewController];
    [viewController.datePicker setDate:timer.fireDatetime];
    [viewController.alarmMessageTextField setText:timer.message];

    return viewController;
}

- (void)didTapDoneButton:(id)sender {
    
}

@end
