//
//  ListViewController.m
//  Timer
//
//  Created by myuon on 2014/12/14.
//  Copyright (c) 2014年 yasu. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@interface ListViewController (TableView) <UITableViewDataSource, UITableViewDelegate>
@end

@interface ListViewController (Action)
- (IBAction)didTapAddButton:(id)sender;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation ListViewController (TableView)

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

@implementation ListViewController (Action)

- (void)didTapAddButton:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
