//
//  AlertService.h
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "Service.h"

typedef void (^AlertActionBlock)(NSString *title);

@interface AlertService : Service

- (id)alertActionWithTitle:(NSString *)title action:(AlertActionBlock)actionBlock;

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actions:(NSArray *)actions;
- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;

@end
