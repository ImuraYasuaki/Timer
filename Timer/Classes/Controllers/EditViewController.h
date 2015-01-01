//
//  EditViewController.h
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "RegisterViewController.h"

@class TimerDTO;

@interface EditViewController : RegisterViewController

+ (instancetype)viewControllerWithTimer:(TimerDTO *)timer;

@end
