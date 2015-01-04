//
//  AlertService.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "AlertService.h"
#import "SystemService.h"

@interface AlertAction : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AlertActionBlock actionBlock;
+ (instancetype)actionWithTitle:(NSString *)title action:(AlertActionBlock)actionBlock;
@end
@implementation AlertAction
+ (instancetype)actionWithTitle:(NSString *)title action:(AlertActionBlock)actionBlock {
    AlertAction *action = [AlertAction init];
    if (action) {
        [action setTitle:title];
        [action setActionBlock:actionBlock];
    }
    return action;
}
- (void)dealloc {
    [self setActionBlock:nil];
}
@end

@interface AlertService ()
@property (nonatomic, strong) NSArray *actions; // use in iOS7.x
@end
@interface AlertService (AlertView) <UIAlertViewDelegate>
@end

@implementation AlertService

- (id)alertActionWithTitle:(NSString *)title action:(AlertActionBlock)actionBlock {
    __block id action = nil;
    [[SystemService sharedService] OSMajorVersionBranching:8 lessBlock:^{
        action = [AlertAction actionWithTitle:title action:actionBlock];
    } laterBlock:^{
        action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            actionBlock(action.title);
        }];
    }];
    return action;
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle actions:(NSArray *)actions {
    [[SystemService sharedService] OSMajorVersionBranching:8 lessBlock:^{
        BOOL showingAlertView = [self actions] != nil;
        if (showingAlertView) {
            return;
        }
        [self setActions:actions];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        for (AlertAction *action in self.actions) {
            [alertView addButtonWithTitle:action.title];
        }
        [alertView show];
    } laterBlock:^{
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
    }];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:cancelButtonTitle actions:nil];
}

- (void)showAlertViewFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actions:(NSArray *)actions {
    [self showAlertViewFromViewController:viewController title:title message:message cancelButtonTitle:nil actions:actions];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation AlertService (AlertView)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    AlertAction *action = [self.actions objectAtIndex:buttonIndex];
    action.actionBlock(action.title);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self setActions:nil];
}

@end
