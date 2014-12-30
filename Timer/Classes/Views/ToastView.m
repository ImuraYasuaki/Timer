//
//  ToastView.m
//  Timer
//
//  Created by myuon on 2014/12/26.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ToastView.h"

NSTimeInterval const ToastViewDurationShort = 1.0;
NSTimeInterval const ToastViewDurationLong = 3.0;

@interface ToastView ()

@property (nonatomic, weak) IBOutlet UILabel *label;

- (instancetype)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration;

+ (UILabel *)createLabelWithMessage:(NSString *)message;
+ (UIWindow *)targetWindow;
- (void)layoutWithSuperFrame:(CGRect)superFrame;

@end

@implementation ToastView

- (instancetype)initWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _message = message;
        _duration = duration;
        _animationDuration = ToastViewDurationShort;
        _maximumAlpha = 0.8f;

        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

+ (instancetype)toastViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    return [[ToastView alloc] initWithMessage:message duration:duration];
}

+ (void)showToastViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration {
    ToastView *view = [ToastView toastViewWithMessage:message duration:duration];
    [view show];
}

- (void)show {
    UIWindow *targetWindow = [self.class targetWindow];
    if (CGRectEqualToRect([self frame], CGRectZero)) {
        [self layoutWithSuperFrame:targetWindow.bounds];
    }
    [self setAlpha:0.2f];
    [targetWindow addSubview:self];

    [UIView animateWithDuration:self.animationDuration animations:^{
        [self setAlpha:self.maximumAlpha];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
}

- (void)hide {
    if (![self superview]) {
        return;
    }
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (UILabel *)createLabelWithMessage:(NSString *)message {
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setText:message];
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];

    CGFloat margin = 4.0f;
    CGRect labelFrame = label.bounds;
    labelFrame.origin = CGPointMake(margin, 0.0f);
    labelFrame.size.width += margin * 2.0f;
    labelFrame.size.height += margin * 2.0f;
    [label setFrame:labelFrame];

    return label;
}

+ (UIWindow *)targetWindow {
    return [[[UIApplication sharedApplication] windows] firstObject];
}

- (void)layoutWithSuperFrame:(CGRect)superFrame {
    if (!self.label) {
        UILabel *label = [self.class createLabelWithMessage:self.message];
        [self addSubview:label];
        [self setLabel:label];
    }
    CGRect frame = [self.label bounds];
    frame.origin.x = (CGRectGetWidth(superFrame) - CGRectGetWidth(frame)) * 0.5f;
    frame.origin.y = CGRectGetHeight(superFrame) - CGRectGetHeight(frame) - 40.0f;
    [self setFrame:frame];
}

@end
