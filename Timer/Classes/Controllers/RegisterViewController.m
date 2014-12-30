//
//  RegisterViewController.m
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "RegisterViewController.h"

#import "TimerService.h"
#import "ToastView.h"

#import "RegistrationLogic.h"

@interface RegisterViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UITextField *alarmMessageTextField;

- (TimerDTO *)timerDTO;

@end

@interface RegisterViewController (TextField) <UITextFieldDelegate>

@end

@interface RegisterViewController (Action)

- (IBAction)didTapDoneButton:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.datePicker setMinimumDate:[NSDate date]];
}

+ (instancetype)viewController {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (TimerDTO *)timerDTO {
    return [[TimerDTO alloc] initWithFirDatetime:[self.datePicker date] message:self.alarmMessageTextField.text];
}

@end

@implementation RegisterViewController (Action)

- (void)didTapDoneButton:(id)sender {
    TimerDTO *timer = self.timerDTO;
    BOOL canRegister = [RegistrationLogic canRegisterWithTimer:timer];
    if (!canRegister) {
        [ToastView showToastViewWithMessage:@"should set fire Date time." duration:ToastViewDurationLong];
        return;
    }
    BOOL succeeded = [[TimerService sharedService] saveTimer:timer];
    if (succeeded) {
        [ToastView showToastViewWithMessage:@"succeeded." duration:ToastViewDurationLong];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [ToastView showToastViewWithMessage:@"you missed." duration:ToastViewDurationLong];
    }
}

@end

@implementation RegisterViewController (TextField)

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

@end
