//
//  ViewController.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ViewController.h"

#import <TimerLib/TimerService.h>

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@interface ViewController (TableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ViewController (Action)
- (IBAction)didTapAddButton:(id)sender;
@end

@implementation ViewController
@end

////////////////////////////////////////////////////////////////////////////////

@implementation ViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*! @todo 実装する */
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ViewController (Action)

- (void)didTapAddButton:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
