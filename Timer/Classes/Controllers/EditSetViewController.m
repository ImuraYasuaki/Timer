//
//  EditSetViewController.m
//  Timer
//
//  Created by myuon on 2014/12/31.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "EditSetViewController.h"
#import "EditViewController.h"

#import "TimerDTO.h"

@interface EditSetViewController ()
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *editViewControllers;
@property (assign) NSUInteger currentPageIndex;
+ (id)viewController;
@end

@interface EditSetViewController (Action)
- (IBAction)didTapRightBarButton:(id)sender;
@end

@interface EditSetViewController (PageViewController) <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation EditSetViewController

+ (id)viewController {
    EditSetViewController *viewController = [[EditSetViewController alloc] init];
    [viewController setTitle:@"Edit Set"];

    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageViewController setDataSource:viewController];
    [pageViewController setDelegate:viewController];
    [viewController setPageViewController:pageViewController];
    [viewController.view addSubview:pageViewController.view];
    [viewController addChildViewController:pageViewController];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:viewController action:@selector(didTapRightBarButton:)];
    [[navigationController.navigationBar.items firstObject] setRightBarButtonItem:item];

    return navigationController;
}

+ (id)viewControllerWithTimers:(NSArray *)timers {
    UINavigationController *navigationController = [EditSetViewController viewController];
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (TimerDTO *timer in timers) {
        EditViewController *viewController = [EditViewController viewControllerWithTimer:timer];
        [viewControllers addObject:viewController];
    }
    EditSetViewController *setViewController = [[navigationController viewControllers] firstObject];
    [setViewController.pageViewController setViewControllers:@[[viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [setViewController setEditViewControllers:viewControllers];
    return navigationController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPageIndex = 0;
    }
    return self;
}

@end

@implementation EditSetViewController (Action)

- (void)didTapRightBarButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation EditSetViewController (PageViewController)

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = self.currentPageIndex + 1;
    if ([self.editViewControllers count] <= index) {
        return nil;
    }
    return [self.editViewControllers objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = self.currentPageIndex - 1;
    if (index < 0) {
        return nil;
    }
    return [self.editViewControllers objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    NSUInteger index = [self.editViewControllers indexOfObject:[pageViewController.viewControllers lastObject]];
    if (index == NSNotFound) {
        index = [self.editViewControllers count] - 1;
    }
    self.currentPageIndex = index;
}

@end
