//
//  LocalNotificationService.m
//  Timer
//
//  Created by myuon on 2015/01/02.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "LocalNotificationService.h"

#import "SystemService.h"

@interface LocalNotificationService (Category)
+ (NSUInteger)UIUserNotificationAvailableVersion;
+ (NSString *)categoryName;
+ (NSString *)categoryNameWithSubCategory:(NSString *)subCategory;
@end

@implementation LocalNotificationService

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SystemService sharedService] OSMajorVersionBranching:[self.class UIUserNotificationAvailableVersion] laterBlock:^{
            NSSet *categoryNames = [NSSet setWithArray:@[[self.class categoryName]]];
            UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:categoryNames];
            [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
        }];
    }
    return self;
}

- (NSArray *)scheduledLocalNotifications {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    return [notifications sortedArrayUsingComparator:^NSComparisonResult(UILocalNotification *obj1, UILocalNotification *obj2) {
        return [obj1.fireDate compare:obj2.fireDate];
    }];
}

- (BOOL)didScheduleLocalNotificationAtDate:(NSDate *)date {
    NSArray *scheduledNotifications = [self scheduledLocalNotifications];
    NSArray *scheduledDates = [scheduledNotifications valueForKeyPath:NSStringFromSelector(@selector(fireDate))];
    for (NSDate *scheduledDate in scheduledDates) {
        if ([date isEqualToDate:scheduledDate]) {
            return YES;
        }
    }
    return NO;
}

- (void)scheduleLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)scheduleLocalNotificationWithMessage:(NSString *)message atDate:(NSDate *)date {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setAlertBody:message];
    [notification setFireDate:date];
    [notification setTimeZone:[NSTimeZone localTimeZone]];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [[SystemService sharedService] OSMajorVersionBranching:[self.class UIUserNotificationAvailableVersion] laterBlock:^{
        [notification setCategory:[self.class categoryName]];
    }];
    [self scheduleLocalNotification:notification];
}

- (void)cancelScheduledLocalNotificationAtDate:(NSDate *)date {
    NSArray *scheduledNotifications = [self scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        if ([notification.fireDate isEqualToDate:date]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

@end

@implementation LocalNotificationService (Category)

+ (NSUInteger)UIUserNotificationAvailableVersion {
    return 8;
}

+ (NSString *)categoryName {
    return @"Local";
}

+ (NSString *)categoryNameWithSubCategory:(NSString *)subCategory {
    return [NSString stringWithFormat:@"%@: %@", [self categoryName], subCategory ? subCategory : @""];
}

@end
