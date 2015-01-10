//
//  ListViewController.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ListViewController.h"

#import "NSObject+PropertyList.h"
#import "AppDelegate.h"

#import "RegisterViewController.h"
#import "EditSetViewController.h"

#import <Graphics/GYFunctionsView.h>
#import "TimerListCell.h"

#import "TimerFormatter.h"

#import "TimerService.h"
#import "LocalNotificationService.h"
#import "AlertService.h"

@interface ListViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) GYFunctionsView *functionsView;
@property (nonatomic, strong) NSMutableArray *timers;
- (void)reloadViews;
- (BOOL)updateTimers;
- (void)showEditFunctions;
- (void)hideEditFunctions;
@end

@interface ListViewController (TableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ListViewController (Action)
- (IBAction)didRefresh:(id)sender;
- (IBAction)didTapAddButton:(id)sender;
@end

@interface ListViewController (EditFunctions)
- (NSArray *)selectedIndexPaths;
- (void)setSelecteTimersEnabled:(BOOL)enabled;
- (IBAction)didTapEnableButton:(id)sender;
- (IBAction)didTapDisableButton:(id)sender;
- (IBAction)didTapDeleteButton:(id)sender;
- (IBAction)didTapEditButton:(id)sender;
@end

@interface ListViewController (Notification)
- (void)didFiredTimer:(NSNotification *)notification;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(didRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    [self setTimers:[NSMutableArray array]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFiredTimer:) name:[AppDelegate didReceiveTimerNotificationName] object:[UIApplication sharedApplication].delegate];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadViews];
}

- (void)reloadViews {
    BOOL updated = [self updateTimers];
    if (updated) {
        [self.tableView reloadData];
        [self hideEditFunctions];
    }
    if (self.functionsView) {
        [UIView animateWithDuration:[UIView defaultAnimationDuration] animations:^{
            [self.functionsView setAlpha:0.8f];
        }];
    }
}

- (BOOL)updateTimers {
    NSArray *timers = [[TimerService sharedService] allTimersShouldPostponePastTimers:YES];
    __block BOOL updated = timers.count != [self.timers count];
    if (!updated) {
        [timers enumerateObjectsUsingBlock:^(TimerDTO *obj, NSUInteger idx, BOOL *stop) {
            BOOL isSame = [obj isEqualToTimer:[self.timers objectAtIndex:idx]];
            if (!isSame) {
                updated = YES;
                (*stop) = YES;
            }
        }];
    }
    if (updated) {
        [[self timers] setArray:timers];
    }
    return updated;
}

- (void)showEditFunctions {
    if (!self.functionsView) {
        __block CGFloat backgroundColorRed = 250.0f / 255.0f;
        __block CGFloat backgroundColorGreen = 180.0f / 255.0f;
        __block CGFloat backgroundColorBlue = 80.0f / 255.0f;
        __block CGFloat backgroundColorAlpha = 0.8f;
        [self setFunctionsView:[GYFunctionsView functionsViewFrom:GYFunctionsViewPositionRight titles:@[@"edit", @"delete", @"enable", @"disable", @"cancel"] visualize:^(GYFunctionsView *functionsView, UIView *view, UIButton *button, NSString *title, NSUInteger index) {
            BOOL cancelButton = [title isEqualToString:@"cancel"];
            UIColor *buttonTitleColor = cancelButton ? [UIColor redColor] : [UIColor blueColor];
            [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];

            UIColor *color = [UIColor colorWithRed:backgroundColorRed green:backgroundColorGreen blue:backgroundColorBlue alpha:backgroundColorAlpha];
            [view setBackgroundColor:color];

            backgroundColorRed *= 1.4f;
            backgroundColorGreen *= 1.4f;
            backgroundColorBlue *= 1.3f;
        } selected:^(GYFunctionsView *functionsView, UIButton *sender, NSUInteger index) {
            if ([sender.titleLabel.text isEqualToString:@"edit"]) {
                [self didTapEditButton:sender];
                [UIView animateWithDuration:0.4f animations:^{
                    [functionsView setAlpha:0.0f];
                }];
                return;
            }
            if ([sender.titleLabel.text isEqualToString:@"delete"]) {
                [self didTapDeleteButton:sender];
            } else if ([sender.titleLabel.text isEqualToString:@"disable"]) {
                [self didTapDisableButton:sender];
            } else if ([sender.titleLabel.text isEqualToString:@"enable"]) {
                [self didTapEnableButton:sender];
            }
            [self hideEditFunctions];
        }]];
    }
    [self.functionsView show];
}

- (void)hideEditFunctions {
    [self.functionsView hide];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
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
    [cell setEnabledTimer:[[TimerService sharedService] isEnabledWithTimer:timer]];

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

- (IBAction)didRefresh:(UIRefreshControl *)sender {
    [sender beginRefreshing];
    [self reloadViews];
    [sender endRefreshing];
}

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

- (void)setSelecteTimersEnabled:(BOOL)enabled {
    NSArray *selectedIndexPaths = [self selectedIndexPaths];
    for (NSIndexPath *indexPath in [selectedIndexPaths reverseObjectEnumerator]) {
        TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];
        [[TimerService sharedService] setTimer:timer enabled:enabled];
    }
    [self.tableView reloadRowsAtIndexPaths:selectedIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)didTapEnableButton:(id)sender {
    [self setSelecteTimersEnabled:YES];
}

- (IBAction)didTapDisableButton:(id)sender {
    [self setSelecteTimersEnabled:NO];
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
    NSMutableArray *selectedTimers = [NSMutableArray array];
    NSArray *selectedIndexPaths = [self selectedIndexPaths];
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        TimerDTO *timer = [self.timers objectAtIndex:indexPath.row];

        [selectedTimers addObject:timer];
    }
    EditSetViewController *viewController = [EditSetViewController viewControllerWithTimers:selectedTimers];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (Notification)

- (void)didFiredTimer:(NSNotification *)notification {
    [self updateTimers];

    NSDictionary *firedTimerPropertyList = [[notification userInfo] objectForKey:[AppDelegate firedTimerKey]];
    if (!firedTimerPropertyList) {
        return;
    }
    TimerDTO *firedTimer = [NSObject instanceFromPropertyList:firedTimerPropertyList];
    if (!firedTimer) {
        return;
    }
    NSString *title = [TimerFormatter timerDateFormatWithDate:firedTimer.fireDatetime];
    NSString *message = firedTimer.message;
    [[AlertService sharedService] showAlertViewFromViewController:self title:title message:message cancelButtonTitle:@"OK"];
}

@end
