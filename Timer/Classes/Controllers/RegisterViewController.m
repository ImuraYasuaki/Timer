//
//  RegisterViewController.m
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "RegisterViewController.h"

#import <Graphics/GYToastView.h>
#import <ProjectCore/PCLocalNotificationService.h>

// Categories
#import "NSObject+PropertyList.h"

#import "AppDelegate.h"

#import "TimerService.h"

#import "RegistrationLogic.h"

@interface RegisterViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UITextField *alarmMessageTextField;
@property (nonatomic, strong) RegistrationCompletion completionBlock;

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
    return [self viewControllerWithComletion:nil];
}

+ (instancetype)viewControllerWithComletion:(BOOL (^)(TimerDTO *))completionBlock {
    RegisterViewController *viewController = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];;
    [viewController setCompletionBlock:completionBlock];
    return viewController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self setCompletionBlock:nil];
}

- (TimerDTO *)timerDTO {
    return [[TimerDTO alloc] initWithFireDatetime:[self.datePicker date] message:self.alarmMessageTextField.text];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation RegisterViewController (Action)

- (void)didTapDoneButton:(id)sender {
    TimerDTO *timer = self.timerDTO;
    BOOL canRegister = [RegistrationLogic canRegisterWithTimer:timer];
    if (!canRegister) {
        [GYToastView showToastViewWithMessage:@"should set fire Date time." duration:GYToastViewDurationLong];
        return;
    }
    BOOL succeeded = [[TimerService sharedService] saveTimer:timer];
    if (succeeded) {
        [GYToastView showToastViewWithMessage:@"succeeded." duration:GYToastViewDurationLong];

        NSDictionary *userInfo = @{[AppDelegate firedTimerKey]: timer.propertyListValue};
        [[PCLocalNotificationService sharedService] scheduleLocalNotificationWithMessage:timer.message atDate:timer.fireDatetime userInfo:userInfo];
    } else {
        timer = nil;
        [GYToastView showToastViewWithMessage:@"you missed." duration:GYToastViewDurationLong];
    }
    BOOL canFinish = self.completionBlock ? self.completionBlock(timer) : YES;
    if (canFinish) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation RegisterViewController (TextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

@end
