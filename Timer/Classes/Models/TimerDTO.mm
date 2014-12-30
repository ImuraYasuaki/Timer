//
//  TimerDTO.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerDTO.h"

@implementation TimerDTO

- (instancetype)initWithFirDatetime:(NSDate *)datetime message:(NSString *)message {
    self = [super init];
    if (self) {
        _fireDatetime = datetime;
        _message = message;
    }
    return self;
}

- (BOOL)didFinish {
    return [[NSDate date] compare:self.fireDatetime] != NSOrderedAscending;
}

@end
