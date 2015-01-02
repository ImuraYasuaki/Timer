//
//  AppDelegate.h
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface AppDelegate (LocalNotifications)
+ (NSString *)didReceiveTimerNotificationName;
+ (NSString *)firedTimerKey;
@end
