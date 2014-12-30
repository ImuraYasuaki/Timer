//
//  TimerDTO.h
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerDTO : NSObject

@property (nonatomic, readonly) NSDate *fireDatetime;
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithFirDatetime:(NSDate *)datetime message:(NSString *)message;

- (BOOL)didFinish;

@end
