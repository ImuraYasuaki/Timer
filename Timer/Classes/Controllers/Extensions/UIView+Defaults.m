//
//  UIView+Defaults.m
//  Timer
//
//  Created by myuon on 2015/01/01.
//  Copyright (c) 2015年 yasu. All rights reserved.
//

#import "UIView+Defaults.h"

@implementation UIView (Defaults)

+ (CGFloat)defaultAnimationDuration {
    return 0.8f;
}

+ (CGFloat)defaultFastAnimationDuration {
    return [self defaultAnimationDuration] * 0.5f;
}

@end
