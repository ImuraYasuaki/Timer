//
//  FunctionsView.m
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "FunctionsView.h"

@interface FunctionsView ()
@property (nonatomic, assign) CGPoint hiddenPosition;
@property (nonatomic, assign) CGPoint shownPosition;
@property (nonatomic, strong) FunctionsViewSelectedBlock selectedBlock;
+ (UIWindow *)targetWindow;
+ (CGRect)targetWindowBounds;
+ (NSInteger)functionTagWithIndex:(NSInteger)tag;
+ (NSInteger)indexWithFunctionTag:(NSInteger)tag;
+ (FunctionsViewPosition)positionOfHorizontalWithPosition:(FunctionsViewPosition)position;
+ (FunctionsViewPosition)positionOfVerticalWithPosition:(FunctionsViewPosition)position;
+ (CGPoint)shownPointWithPosition:(FunctionsViewPosition)position size:(const CGSize)size;
+ (CGPoint)hiddenPointWithPosition:(FunctionsViewPosition)position size:(const CGSize)size;
@end

@interface FunctionsView (Action)
- (void)didTapFunctionButton:(UIButton *)sender;
@end

@implementation FunctionsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setVisibleAlpha:0.8f];
    }
    return self;
}

- (void)removeFromSuperview {
    [self setSelectedBlock:nil];

    [super removeFromSuperview];
}

+ (FunctionsView *)showFunctionsViewFrom:(FunctionsViewPosition)position titles:(NSArray *)titles selected:(FunctionsViewSelectedBlock)selectedBlock {
    return [self showFunctionsViewFrom:position titles:titles visualize:nil selected:selectedBlock];
}

+ (FunctionsView *)showFunctionsViewFrom:(FunctionsViewPosition)position titles:(NSArray *)titles visualize:(FunctionsViewVisualizeBlock)visualizeBlock selected:(FunctionsViewSelectedBlock)selectedBlock {
    FunctionsView *functionsView = [[FunctionsView alloc] init];
    [functionsView setSelectedBlock:selectedBlock];
    [functionsView setAlpha:0.0f];

    UIWindow *targetWindow = [self targetWindow];
    [targetWindow addSubview:functionsView];

    FunctionsViewPosition horizontalPosition = [self positionOfHorizontalWithPosition:position];
    CGSize size = CGSizeZero;
    NSInteger index = 0;
    for (NSString *title in titles) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:functionsView action:@selector(didTapFunctionButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTag:[self functionTagWithIndex:index]];
        [button setBackgroundColor:[UIColor clearColor]];
        switch (horizontalPosition) {
            case FunctionsViewPositionLeft:     [button.titleLabel setTextAlignment:NSTextAlignmentLeft]; break;
            case FunctionsViewPositionRight:    [button.titleLabel setTextAlignment:NSTextAlignmentRight]; break;
            case FunctionsViewPositionCenter:
            default: [button.titleLabel setTextAlignment:NSTextAlignmentCenter]; break;
        }
        [button sizeToFit];

        CGRect buttonFrame = button.bounds;
        buttonFrame.size.width += 8.0f * 2.0f;
        buttonFrame.origin.x = 0.0f;
        [button setFrame:buttonFrame];

        UIView *view = [[UIView alloc] initWithFrame:button.bounds];
        [view setBackgroundColor:[UIColor clearColor]];
        [view addSubview:button];
        [view sizeToFit];

        if (visualizeBlock) {
            visualizeBlock(functionsView, view, button, title, index++);
        }
        [functionsView addSubview:view];

        size.width = MAX(size.width, CGRectGetWidth([button bounds]));
        size.height += CGRectGetHeight([button bounds]);
    }
    CGRect functionsViewFrame = CGRectZero;
    functionsViewFrame.origin = [self hiddenPointWithPosition:position size:size];
    functionsViewFrame.size = size;
    [functionsView setFrame:functionsViewFrame];
    [functionsView setHiddenPosition:functionsViewFrame.origin];
    [functionsView setShownPosition:[self shownPointWithPosition:position size:size]];

    CGFloat y = 0.0f;
    CGFloat functionsViewWidth = CGRectGetWidth(functionsViewFrame);
    for (UIView *subview in [functionsView subviews]) {
        CGRect subviewFrame = subview.frame;
        CGFloat x = 0.0f;
        switch (horizontalPosition) {
            case FunctionsViewPositionLeft:     x = 0.0f; break;
            case FunctionsViewPositionRight:    x = functionsViewWidth - CGRectGetWidth(subview.frame); break;
            case FunctionsViewPositionCenter:
            default: x = (functionsViewWidth - CGRectGetWidth(subview.frame)) * 0.5f; break;
        }
        subviewFrame.origin = CGPointMake(x, y);
        [subview setFrame:subviewFrame];

        y += CGRectGetHeight(subviewFrame);
    }
    [functionsView show];

    return functionsView;
}

- (void)show {
    CGRect functionsViewFrame = self.bounds;
    functionsViewFrame.origin = self.shownPosition;
    [UIView animateWithDuration:[UIView defaultFastAnimationDuration] animations:^{
        [self setFrame:functionsViewFrame];
        [self setAlpha:self.visibleAlpha];
    } completion:^(BOOL finished) {
        // nothing to do ...
    }];
}

- (void)hide {
    CGRect frame = self.frame;
    frame.origin = self.hiddenPosition;
    [UIView animateWithDuration:[UIView defaultFastAnimationDuration] animations:^{
        [self setFrame:frame];
        [self setAlpha:0.2f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (UIWindow *)targetWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

+ (CGRect)targetWindowBounds {
    return [[self targetWindow] bounds];
}

+ (NSInteger)functionTagWithIndex:(NSInteger)tag {
    return tag + 1000;
}

+ (NSInteger)indexWithFunctionTag:(NSInteger)tag {
    return tag - 1000;
}

+ (FunctionsViewPosition)positionOfHorizontalWithPosition:(FunctionsViewPosition)position {
    if (position & FunctionsViewPositionLeft) {
        return FunctionsViewPositionLeft;
    }
    if (position & FunctionsViewPositionRight) {
        return FunctionsViewPositionRight;
    }
    return FunctionsViewPositionCenter;
}

+ (FunctionsViewPosition)positionOfVerticalWithPosition:(FunctionsViewPosition)position {
    if (position & FunctionsViewPositionTop) {
        return FunctionsViewPositionTop;
    }
    if (position & FunctionsViewPositionBottom) {
        return FunctionsViewPositionBottom;
    }
    return FunctionsViewPositionCenter;
}

+ (CGPoint)shownPointWithPosition:(FunctionsViewPosition)position size:(const CGSize)size {
    CGRect baseFrame = [self targetWindowBounds];

    CGFloat x = 0.0f;
    FunctionsViewPosition horizontalPosition = [self.class positionOfHorizontalWithPosition:position];
    switch (horizontalPosition) {
        case FunctionsViewPositionLeft:     x = 0.0f; break;
        case FunctionsViewPositionRight:    x = CGRectGetWidth(baseFrame) - size.width; break;
        case FunctionsViewPositionCenter:
        default:                            x = (CGRectGetWidth(baseFrame) - size.width) * 0.5f; break;
    }
    CGFloat y = 0.0f;
    FunctionsViewPosition verticalPosition = [self.class positionOfVerticalWithPosition:position];
    switch (verticalPosition) {
        case FunctionsViewPositionTop:      y = 0.0f; break;
        case FunctionsViewPositionBottom:   y = CGRectGetHeight(baseFrame) - size.height; break;
        case FunctionsViewPositionCenter:
        default:                            y = (CGRectGetHeight(baseFrame) - size.height) * 0.5f; break;
    }
    return CGPointMake(x, y);
}

+ (CGPoint)hiddenPointWithPosition:(FunctionsViewPosition)position size:(const CGSize)size {
    CGRect baseFrame = [self targetWindowBounds];

    CGFloat x = 0.0f;
    FunctionsViewPosition horizontalPosition = [self.class positionOfHorizontalWithPosition:position];
    switch (horizontalPosition) {
        case FunctionsViewPositionLeft:     x = -size.width; break;
        case FunctionsViewPositionRight:    x = CGRectGetWidth(baseFrame); break;
        case FunctionsViewPositionCenter:
        default:                            x = (CGRectGetWidth(baseFrame) - size.width) * 0.5f; break;
    }
    CGFloat y = 0.0f;
    FunctionsViewPosition verticalPosition = [self.class positionOfVerticalWithPosition:position];
    switch (verticalPosition) {
        case FunctionsViewPositionTop:      y = -size.height; break;
        case FunctionsViewPositionBottom:   y = CGRectGetHeight(baseFrame); break;
        case FunctionsViewPositionCenter:
        default:                            y = (CGRectGetHeight(baseFrame) - size.height) * 0.5f; break;
    }
    return CGPointMake(x, y);
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation FunctionsView (Action)

- (void)didTapFunctionButton:(UIButton *)sender {
    NSInteger tag = [self.class indexWithFunctionTag:[sender tag]];
    if (self.selectedBlock) {
        self.selectedBlock(self, sender, tag);
    }
}

@end
