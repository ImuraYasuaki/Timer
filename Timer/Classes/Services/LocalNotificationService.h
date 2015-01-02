//
//  LocalNotificationService.h
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "Service.h"

@interface LocalNotificationService : Service

- (NSArray *)scheduledLocalNotifications;
- (BOOL)didScheduleLocalNotificationAtDate:(NSDate *)date;
- (void)scheduleLocalNotification:(UILocalNotification *)notification;
- (void)scheduleLocalNotificationWithMessage:(NSString *)message atDate:(NSDate *)date;
- (void)cancelScheduledLocalNotificationAtDate:(NSDate *)date;

@end
