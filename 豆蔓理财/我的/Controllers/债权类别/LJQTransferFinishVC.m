//
//  LJQTransferFinishVC.m
//  豆蔓理财
//
//  Created by mac on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQTransferFinishVC.h"
#import "LJQTransferFinishCell.h"
@interface LJQTransferFinishVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

static NSString *const transferFinishIdentifier = @"transferFinishCell";
@implementation LJQTransferFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认转让";
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, DMDeviceWidth, DMDeviceHeight) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 380;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [self createFootView];
        [_tableView registerClass:[LJQTransferFinishCell class] forCellReuseIdentifier:transferFinishIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)createFootView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1000)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    return view;
}

#pragma tableViewDelegate && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQTransferFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:transferFinishIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.confirmTransfer = ^(UIButton *sender) {
        ShowMessage(@"确认转让");
    };
    return cell;
}

@end
