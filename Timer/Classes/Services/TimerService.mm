//
//  TimerService.m
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerService.h"

#include <TimerLib/TimerService.h>

@implementation TimerService

- (NSArray *)allTimers {
    return nil;
}

- (BOOL)saveTimer:(TimerDTO *)timer {
    return NO;
}

- (BOOL)removeTimer:(TimerDTO *)timer {
    return NO;
}

@end

@implementation TimerService (Blocks)

- (void)allTimers:(RetrieveCompletoinBlock)completion {
    
}

- (void)saveTimer:(TimerDTO *)timer completion:(SaveCompletoinBlock)completion {
    
}

- (void)removeTimer:(TimerDTO *)timer completion:(RemoveCompletoinBlock)completion {
    
}

@end
