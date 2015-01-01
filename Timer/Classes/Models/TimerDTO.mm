//
//  TimerDTO.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerDTO.h"

#import <TimerLib/Timer.h>

@implementation TimerDTO

- (instancetype)initWithFireDatetime:(NSDate *)datetime message:(NSString *)message {
    return [self initWithTimerID:core::Timer::UnregisteredTimerID fireDatetime:datetime message:message];
}

- (instancetype)initWithTimerID:(NSUInteger)timerID fireDatetime:(NSDate *)datetime message:(NSString *)message {
    self = [super init];
    if (self) {
        _timerID = timerID;
        _fireDatetime = datetime;
        _message = message;
    }
    return self;
}

- (BOOL)didFinish {
    return [[NSDate date] compare:self.fireDatetime] != NSOrderedAscending;
}

- (BOOL)isEqualToTimer:(TimerDTO *)timer {
    return (self.timerID == timer.timerID && [self.fireDatetime isEqualToDate:timer.fireDatetime] && [self.message isEqualToString:timer.message]);
}

@end
