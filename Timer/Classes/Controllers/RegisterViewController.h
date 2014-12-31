//
//  RegisterViewController.h
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimerDTO;

@interface RegisterViewController : UIViewController

+ (instancetype)viewController;
+ (instancetype)viewControllerWithTimer:(TimerDTO *)timer;

@end
