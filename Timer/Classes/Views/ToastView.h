//
//  ToastView.h
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

extern NSTimeInterval const ToastViewDurationShort;
extern NSTimeInterval const ToastViewDurationLong;

@interface ToastView : UIView

@property (nonatomic, strong) NSString *message;
@property (assign) NSTimeInterval duration;
@property (assign) NSTimeInterval animationDuration;
@property (assign) CGFloat maximumAlpha;

+ (instancetype)toastViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration;

+ (void)showToastViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration;

- (void)show;
- (void)hide;

@end
