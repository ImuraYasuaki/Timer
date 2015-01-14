//
//  TimerService.h
//  Timer
//
//  Created by myuon on 2014/12/20.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <ProjectCore/PCService.h>

#import "TimerDTO.h"

@interface TimerService : PCService

- (NSArray *)allTimers;
- (NSArray *)allTimersShouldPostponePastTimers:(BOOL)shouldPostponePastTimers;
- (BOOL)saveTimer:(TimerDTO *)timer;
- (BOOL)removeTimer:(TimerDTO *)timer;
- (void)setTimer:(TimerDTO *)timer enabled:(BOOL)enabled;

- (BOOL)isEnabledWithTimer:(TimerDTO *)timer;

@end

typedef void (^RetrieveCompletoinBlock)(NSArray *timers, NSError *error);
typedef void (^SaveCompletoinBlock)(TimerDTO *timer, NSError *error);
typedef void (^RemoveCompletoinBlock)(TimerDTO *timer, NSError *error);

@interface TimerService (Blocks)

- (void)allTimers:(RetrieveCompletoinBlock)completion;
- (void)saveTimer:(TimerDTO *)timer completion:(SaveCompletoinBlock)completion;
- (void)removeTimer:(TimerDTO *)timer completion:(RemoveCompletoinBlock)completion;

@end
