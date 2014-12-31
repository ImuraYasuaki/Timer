//
//  FunctionsView.h
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FunctionsViewPosition) {
    FunctionsViewPositionDefault = 0,
    FunctionsViewPositionRight  = 1 << 0,
    FunctionsViewPositionBottom = 1 << 1,
    FunctionsViewPositionLeft   = 1 << 2,
    FunctionsViewPositionTop    = 1 << 3,
    FunctionsViewPositionHorizontal = ((1 << 0) | (1 << 2)),//FunctionsViewPositionLeft | FunctionsViewPositionRight,
    FunctionsViewPositionVertical   = ((1 << 1) | (1 << 3)),//FunctionsViewPositionBottom | FunctionsViewPositionTop,

    FunctionsViewPositionCenter = 1 << 4,
};

@class FunctionsView;

typedef void (^FunctionsViewSelectedBlock)(FunctionsView *functionsView, UIButton *sender, NSUInteger index);
typedef void (^FunctionsViewVisualizeBlock)(FunctionsView *functionsView, UIView *view, UIButton *button, NSString *title, NSUInteger index);

@interface FunctionsView : UIView

+ (FunctionsView *)showFunctionsViewFrom:(FunctionsViewPosition)position titles:(NSArray *)titles selected:(FunctionsViewSelectedBlock)selectedBlock;
+ (FunctionsView *)showFunctionsViewFrom:(FunctionsViewPosition)position titles:(NSArray *)titles visualize:(FunctionsViewVisualizeBlock)visualizeBlock selected:(FunctionsViewSelectedBlock)selectedBlock;

- (void)show;
- (void)hide;

@end
