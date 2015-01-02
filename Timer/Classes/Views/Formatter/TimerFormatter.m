//
//  TimerFormatter.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "TimerFormatter.h"

@implementation TimerFormatter

+ (NSString *)timerDateFormatWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:mm"];

    return [formatter stringFromDate:date];
}

@end
