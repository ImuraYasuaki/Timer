//
//  AlertService.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "AlertService.h"

@implementation AlertService

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actions:(NSArray *)actions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [alertController addAction:action];
    }
    if (cancelButtonTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:cancelButtonTitle actions:nil];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:nil actions:actions];
}

@end
