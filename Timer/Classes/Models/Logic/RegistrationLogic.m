//
//  RegistrationLogic.m
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "RegistrationLogic.h"

@implementation RegistrationLogic

+ (BOOL)canRegisterWithTimer:(TimerDTO *)timer {
    if (!timer) {
        return NO;
    }
    if (!timer.fireDatetime) {
        return NO;
    }
    if ([timer didFinish]) {
        return NO;
    }
    return YES;
}

@end
