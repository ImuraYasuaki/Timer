//
//  ListViewController.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ListViewController.h"

#import "RegisterViewController.h"
#import "FunctionsView.h"
#import "TimerListCell.h"

#import "TimerService.h"

@interface ListViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) FunctionsView *functionsView;
@property (nonatomic, strong) NSMutableArray *timers;
- (void)showEditFunctions;
- (void)hideEditFunctions;
@end

@interface ListViewController (TableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ListViewController (Action)
- (IBAction)didTapAddButton:(id)sender;
@end

@interface ListViewController (EditFunctions)
- (NSArray *)selectedIndexPaths;
- (IBAction)didTapDisableButton:(id)sender;
- (IBAction)didTapDeleteButton:(id)sender;
- (IBAction)didTapEditButton:(id)sender;
@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setTimers:[[[TimerService sharedService] allTimersShouldPostponePastTimers:YES] mutableCopy]];
}

- (void)showEditFunctions {
    __block CGFloat backgroundColorRed = 250.0f / 255.0f;
    __block CGFloat backgroundColorGreen = 180.0f / 255.0f;
    __block CGFloat backgroundColorBlue = 80.0f / 255.0f;
    __block CGFloat backgroundColorAlpha = 0.8f;
    [self setFunctionsView:[FunctionsView showFunctionsViewFrom:FunctionsViewPositionRight titles:@[@"edit", @"delete", @"disable", @"cancel"] visualize:^(FunctionsView *functionsView, UIView *view, UIButton *button, NSString *title, NSUInteger index) {
        BOOL cancelButton = [title isEqualToString:@"cancel"];
        UIColor *buttonTitleColor = cancelButton ? [UIColor redColor] : [UIColor blueColor];
        [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];

        UIColor *color = [UIColor colorWithRed:backgroundColorRed green:backgroundColorGreen blue:backgroundColorBlue alpha:backgroundColorAlpha];
        [button setBackgroundColor:color];

        backgroundColorRed *= 1.4f;
        backgroundColorGreen *= 1.4f;
        backgroundColorBlue *= 1.3f;
    } selected:^(FunctionsView *functionsView, UIButton *sender, NSUInteger index) {
        if ([sender.titleLabel.text isEqualToString:@"edit"]) {
            [self didTapEditButton:sender];
        } else if ([sender.titleLabel.text isEqualToString:@"delete"]) {
            [self didTapDeleteButton:sender];
        } else if ([sender.titleLabel.text isEqualToString:@"disable"]) {
            [self didTapDisableButton:sender];
        }
        [functionsView hide];
    }]];
}

- (void)hideEditFunctions {
    [self.functionsView hide];
    [self setFunctionsView:nil];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self timers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TimeerListCell";
    TimerListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TimerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];
    [cell setTimer:timer];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];
    return [TimerListCell cellHeightWithTimer:timer];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL editModeEnabling = [[tableView indexPathsForSelectedRows] count] > 0;
    if (!editModeEnabling) {
        [self showEditFunctions];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL editModeDisabling = [[tableView indexPathsForSelectedRows] count] == 0;
    if (editModeDisabling) {
        [self hideEditFunctions];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (Action)

- (void)didTapAddButton:(id)sender {
    [self hideEditFunctions];

    RegisterViewController *viewController = [RegisterViewController viewController];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (EditFunctions)

- (NSArray *)selectedIndexPaths {
    return [[self.tableView indexPathsForSelectedRows] sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
        return [obj1 compare:obj2];
    }];
}

- (IBAction)didTapDisableButton:(id)sender {
    
}

- (IBAction)didTapDeleteButton:(id)sender {
    NSArray *selectedIndexPaths = [self selectedIndexPaths];
    for (NSIndexPath *indexPath in [selectedIndexPaths reverseObjectEnumerator]) {
        TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];
        [[TimerService sharedService] removeTimer:timer];

        [self.timers removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (IBAction)didTapEditButton:(id)sender {
    NSMutableArray *childViewControllers = [NSMutableArray array];
    NSArray *selectedIndexPaths = [self selectedIndexPaths];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];

        RegisterViewController *viewController = [RegisterViewController viewControllerWithTimer:timer];
        [childViewControllers addObject:viewController];
    }
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageViewController setViewControllers:childViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self presentViewController:pageViewController animated:YES completion:nil];
}

@end
