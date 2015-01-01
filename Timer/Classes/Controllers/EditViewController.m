//
//  EditViewController.m
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "EditViewController.h"

#import "ToastView.h"

#import "TimerService.h"

#import "TimerDTO.h"

@interface EditViewController (Import)
- (UIDatePicker *)datePicker;
- (UITextField *)alarmMessageTextField;
- (IBAction)didTapDoneButton:(id)sender;
@end

@interface EditViewController ()
@property (nonatomic, strong) TimerDTO *timerDTO;
- (TimerDTO *)updatedTimer;
@end

@implementation EditViewController

+ (instancetype)viewControllerWithTimer:(TimerDTO *)timer {
    EditViewController *viewController = [self viewController];
    [viewController.datePicker setDate:timer.fireDatetime];
    [viewController.alarmMessageTextField setText:timer.message];
    [viewController setTimerDTO:timer];

    return viewController;
}

- (void)didTapDoneButton:(id)sender {
    BOOL succeeded = [[TimerService sharedService] saveTimer:self.updatedTimer];
    NSString *message = succeeded ? @"Updated !" : @"Could not update!";
    [ToastView showToastViewWithMessage:message duration:ToastViewDurationLong];
}

- (TimerDTO *)updatedTimer {
    return [[TimerDTO alloc] initWithTimerID:[self.timerDTO timerID] fireDatetime:[self.datePicker date] message:[self.alarmMessageTextField text]];
}

@end
