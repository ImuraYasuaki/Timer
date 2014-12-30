//
//  TimerListCell.m
//  Timer
//
//  Created by myuon on 2014/12/29.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "TimerListCell.h"

#import "TimerDTO.h"

@interface TimerListCell ()

@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *fireDatetimeLabel;

@end

@interface TimerListCell (Constants)

+ (CGFloat)defaultMargin;

@end

@interface TimerListCell (Creation)

+ (UILabel *)createMessageLabel;
+ (UILabel *)createFireDatetimeLabel;

@end

@implementation TimerListCell

- (void)setTimer:(TimerDTO *)timer {
    _timer = timer;

    BOOL isEmptyMessage = [timer.message length] == 0;
    if (isEmptyMessage) {
        [self.messageLabel setTextColor:[UIColor lightGrayColor]];
        [self.messageLabel setText:@"-- no message"];
    } else {
        [self.messageLabel setTextColor:[UIColor lightGrayColor]];
        [self.messageLabel setText:timer.message];
    }
    BOOL isPast = [timer didFinish];
    [self.contentView setBackgroundColor:isPast ? [UIColor darkGrayColor] : [UIColor whiteColor]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:mm"];

    NSString *fireDatetimeText = [formatter stringFromDate:timer.fireDatetime];
    [self.fireDatetimeLabel setText:fireDatetimeText];

    [self setNeedsLayout];
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *label = [self.class createMessageLabel];
        [self addSubview:label];
        _messageLabel = label;
    }
    return _messageLabel;
}

- (UILabel *)fireDatetimeLabel {
    if (!_fireDatetimeLabel) {
        UILabel *label = [self.class createFireDatetimeLabel];
        [self addSubview:label];
        _fireDatetimeLabel = label;
    }
    return _fireDatetimeLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect baseFrame = [self.contentView bounds];

    CGFloat margin = [self.class defaultMargin];
    CGRect messageLabelFrame = baseFrame;
    messageLabelFrame.origin.x = CGRectGetWidth(messageLabelFrame) * 0.5f + margin;
    messageLabelFrame.size.width = CGRectGetWidth(baseFrame) - (CGRectGetMinX(messageLabelFrame) + margin);
    [self.messageLabel setFrame:messageLabelFrame];
    [self.messageLabel sizeToFit];
    messageLabelFrame = [self.messageLabel frame];
    messageLabelFrame.origin.y = (CGRectGetHeight(baseFrame) - CGRectGetHeight(messageLabelFrame)) * 0.5f;
    [self.messageLabel setFrame:messageLabelFrame];

    CGRect fireDatetimeLabelFrame = baseFrame;
    fireDatetimeLabelFrame.origin.x = margin;
    fireDatetimeLabelFrame.size.width = CGRectGetWidth(baseFrame) * 0.5f - margin;
    [self.fireDatetimeLabel setFrame:fireDatetimeLabelFrame];
    [self.fireDatetimeLabel sizeToFit];
    fireDatetimeLabelFrame = [self.fireDatetimeLabel frame];
    fireDatetimeLabelFrame.origin.y = (CGRectGetHeight(baseFrame) - CGRectGetHeight(fireDatetimeLabelFrame)) * 0.5f;
    [self.fireDatetimeLabel setFrame:fireDatetimeLabelFrame];
}

+ (CGFloat)cellHeightWithTimer:(TimerDTO *)timer {
    return UITableViewAutomaticDimension;
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation TimerListCell (Constants)

+ (CGFloat)defaultMargin {
    return 8.0f;
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation TimerListCell (Creation)

+ (UILabel *)createMessageLabel {
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:3];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    CGFloat fontSize = [UIFont smallSystemFontSize];
    [label setFont:[UIFont systemFontOfSize:fontSize]];

    return label;
}

+ (UILabel *)createFireDatetimeLabel {
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:3];
    [label setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    CGFloat fontSize = [UIFont smallSystemFontSize];
    [label setFont:[UIFont systemFontOfSize:fontSize]];

    return label;
}

@end
