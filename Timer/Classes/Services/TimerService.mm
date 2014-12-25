//
//  TimerService.m
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerService.h"

#include <TimerLib/TimerManager.h>

#import "Configuration.h"

@interface TimerService (Convert)
+ (TimerDTO *)timerDTOFromTimer:(const core::Timer &)timer;
+ (void)timer:(core::Timer &)result fromTimerDTO:(TimerDTO *)timer;
@end

@implementation TimerService

- (NSArray *)allTimers {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    std::list<core::Timer> timers;
    TimerManager::getTimer([path UTF8String], timers);

    NSMutableArray *results = [NSMutableArray array];
    for (std::list<core::Timer>::iterator iterator = timers.begin(); iterator != timers.end(); ++iterator) {
        [results addObject:[self.class timerDTOFromTimer:(*iterator)]];
    }
    return [NSArray arrayWithArray:results];
}

- (BOOL)saveTimer:(TimerDTO *)timerDTO {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    core::Timer timer;
    [self.class timer:timer fromTimerDTO:timerDTO];
    TimerManager::registerTimer([path UTF8String], timer);

    return YES;
}

- (BOOL)removeTimer:(TimerDTO *)timerDTO {
    NSString *path = [[Configuration defaultConfiguration] timerFilePath];
    core::Timer timer;
    [self.class timer:timer fromTimerDTO:timerDTO];

    /*! @abstract need to implementation */
    NSLog(@"path: %@, timer.fireDatetimer: %ld, timer.message: \"%s\"", path, timer.getFireDatetime(), timer.getMessage().c_str());

    return NO;
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
        completion(nil, nil);
    });
}

- (void)removeTimer:(TimerDTO *)timer completion:(RemoveCompletoinBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completion(nil, nil);
    });
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation TimerService (Convert)
+ (TimerDTO *)timerDTOFromTimer:(const core::Timer &)timer {
    NSDate *fireDate = [NSDate dateWithTimeIntervalSince1970:timer.getFireDatetime()];
    NSString *message = [NSString stringWithUTF8String:timer.getMessage().c_str()];
    TimerDTO *DTO = [[TimerDTO alloc] initWithFirDatetime:fireDate message:message];
    return DTO;
}

+ (void)timer:(core::Timer &)result fromTimerDTO:(TimerDTO *)timer {
    result.setFireDatetime([timer.fireDatetime timeIntervalSince1970]);
    result.setMessage([timer.message UTF8String]);
}
@end

