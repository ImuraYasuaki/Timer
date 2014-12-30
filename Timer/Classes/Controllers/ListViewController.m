//
//  ListViewController.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ListViewController.h"

#import "RegisterViewController.h"

#import "TimerListCell.h"

#import "TimerService.h"

@interface ListViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timers;
@end

@interface ListViewController (TableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ListViewController (Action)
- (IBAction)didTapAddButton:(id)sender;
@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setTimers:[[[TimerService sharedService] allTimers] mutableCopy]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*! @todo 実装する */
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (Action)

- (void)didTapAddButton:(id)sender {
    RegisterViewController *viewController = [RegisterViewController viewController];
    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
