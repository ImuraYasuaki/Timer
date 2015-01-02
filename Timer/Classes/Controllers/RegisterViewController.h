//
//  RegisterViewController.h
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

@class TimerDTO;

typedef BOOL ((^RegistrationCompletion)(TimerDTO *newTimer));

@interface RegisterViewController : UIViewController

+ (instancetype)viewController;
+ (instancetype)viewControllerWithComletion:(RegistrationCompletion)completionBlock;

@end
