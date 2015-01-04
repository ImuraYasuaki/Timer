//
//  TimerService.m
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerService.h"

#import "NSObject+PropertyList.h"
#import "AppDelegate.h"

#include <TimerLib/TimerManager.h>

#import "Configuration.h"

#import "LocalNotificationService.h"

@interface TimerService (Convert)
+ (TimerDTO *)timerDTOFromTimer:(const core::Timer &)timer;
+ (void)timer:(core::Timer &)result fromTimerDTO:(TimerDTO *)timer;
@end

@implementation TimerService

- (NSArray *)allTimers {
    return [self allTimersShouldPostponePastTimers:NO];
}

- (NSArray *)allTimersShouldPostponePastTimers:(BOOL)shouldPostponePastTimers {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    std::list<core::Timer> timers;
    TimerManager::getTimer([path UTF8String], timers);

    NSMutableArray *results = [NSMutableArray array];
    for (std::list<core::Timer>::iterator iterator = timers.begin(); iterator != timers.end(); ++iterator) {
        [results addObject:[self.class timerDTOFromTimer:(*iterator)]];
    }
    if (!shouldPostponePastTimers) {
        return [NSArray arrayWithArray:results];
    }
    NSMutableArray *pastTimers = [NSMutableArray array];
    NSMutableArray *waitingTimers = [NSMutableArray array];
    for (TimerDTO *timer in results) {
        if ([timer didFinish]) {
            [pastTimers addObject:timer];
        } else {
            [waitingTimers addObject:timer];
        }
    }
    NSMutableArray *sortedResults = [NSMutableArray array];
    [sortedResults addObjectsFromArray:[waitingTimers sortedArrayUsingComparator:^NSComparisonResult(TimerDTO *obj1, TimerDTO *obj2) {
        return [obj1.fireDatetime compare:obj2.fireDatetime];
    }]];
    [sortedResults addObjectsFromArray:pastTimers];

    return [NSArray arrayWithArray:sortedResults];
}

- (BOOL)saveTimer:(TimerDTO *)timerDTO {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    core::Timer timer;
    [self.class timer:timer fromTimerDTO:timerDTO];

    if (timerDTO.timerID == core::Timer::UnregisteredTimerID) {
        TimerManager::registerTimer([path UTF8String], timer);
    } else {
        TimerManager::updateTimer([path UTF8String], timer);
    }
    return YES;
}

- (BOOL)removeTimer:(TimerDTO *)timerDTO {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    core::Timer timer;
    [self.class timer:timer fromTimerDTO:timerDTO];
    TimerManager::deleteTimer([path UTF8String], timer);

    return YES;
}

- (void)setTimer:(TimerDTO *)timer enabled:(BOOL)enabled {
    if (timer.didFinish) {
        return;
    }
    BOOL scheduled = [self isEnabledWithTimer:timer];
    if (enabled) {
        if (scheduled) {
            return;
        }
        NSDictionary *timerPropertyList = [timer propertyListValue];
        NSDictionary *userInfo = @{[AppDelegate firedTimerKey]: timerPropertyList};
        [[LocalNotificationService sharedService] scheduleLocalNotificationWithMessage:timer.message atDate:timer.fireDatetime userInfo:userInfo];
    } else {
        if (!scheduled) {
            return;
        }
        [[LocalNotificationService sharedService] cancelScheduledLocalNotificationAtDate:timer.fireDatetime];
    }
}

- (BOOL)isEnabledWithTimer:(TimerDTO *)timer {
    if (timer.didFinish) {
        return NO;
    }
    return [[LocalNotificationService sharedService] didScheduleLocalNotificationAtDate:timer.fireDatetime];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation TimerService (Blocks)

- (void)allTimers:(RetrieveCompletoinBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *timers = [self allTimers];
        completion(timers, nil);
    });
}

- (void)saveTimer:(TimerDTO *)timer completion:(SaveCompletoinBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveTimer:timer];
        completion(nil, nil);
    });
}

- (void)removeTimer:(TimerDTO *)timer completion:(RemoveCompletoinBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self removeTimer:timer];
        completion(nil, nil);
    });
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation TimerService (Convert)

+ (TimerDTO *)timerDTOFromTimer:(const core::Timer &)timer {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSince1970:timer.getFireDatetime()];
    NSString *message = [NSString stringWithUTF8String:timer.getMessage().c_str()];
    TimerDTO *DTO = [[TimerDTO alloc] initWithTimerID:timer.getTimerId() fireDatetime:fireDate message:message];
    return DTO;
}

+ (void)timer:(core::Timer &)result fromTimerDTO:(TimerDTO *)timer {
    result.setFireDatetime([timer.fireDatetime timeIntervalSince1970]);
    result.setMessage([timer.message UTF8String]);
    result.setTimerId((unsigned int)timer.timerID);
}

@end

