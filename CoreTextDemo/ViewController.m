//
//  ViewController.m
//  CoreTextDemo
//
//  Created by wxiubin on 2019/1/4.
//  Copyright © 2019 wxiubin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<CellViewModel *> *viewModels;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (IBAction)refresh:(UIBarButtonItem *)sender {

    if (self.timer.isValid) {
        self.timer.fireDate = [NSDate distantFuture];
    } else {
        self.timer.fireDate = [NSDate distantPast];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.timer) {
        __weak typeof(self) ws = self;
        self.timer = [NSTimer timerWithTimeInterval:0.1f repeats:YES block:^(NSTimer * _Nonnull timer) {
            [ws.viewModels addObject:[CellViewModel new]];
            [ws.tableView reloadData];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:TableViewCell.class forCellReuseIdentifier:@"TableViewCell"];
    self.tableView.backgroundColor = HEXCOLOR(0xeeeeee);

    int count = 100;
    self.viewModels = [NSMutableArray arrayWithCapacity:count];
    while (count--) {
        [self.viewModels addObject:[CellViewModel new]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModels[indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.viewModel = self.viewModels[indexPath.row];
    return cell;
}

@end
