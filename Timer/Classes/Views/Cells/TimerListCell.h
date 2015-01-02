//
//  TimerListCell.h
//  Timer
//
//  Created by myuon on 2014/12/29.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

@class TimerDTO;

@interface TimerListCell : UITableViewCell

@property (nonatomic, strong) TimerDTO *timer;
@property (assign, getter=isEnabledTimer) BOOL enabledTimer;

+ (CGFloat)cellHeightWithTimer:(TimerDTO *)timer;

@end
