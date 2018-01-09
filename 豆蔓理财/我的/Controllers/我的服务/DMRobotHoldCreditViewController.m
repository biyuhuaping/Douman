//
//  DMRobotHoldCreditViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobotHoldCreditViewController.h"
#import "DMRobotHoldCreditCell.h"
#import "DMScafferCreditManager.h"
#import "DMCreditDetailController.h"
#import "DMRobotHoldCreditModel.h"

@interface DMRobotHoldCreditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, assign) NSInteger beforeCount;


@end

@implementation DMRobotHoldCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainF5;
    self.navigationItem.title = @"当前服务持有债权";
    self.size = 10;
    
    [self.view addSubview:self.tableView];
    
    [self requestDataWithSize:self.size];
}

- (void)requestDataWithSize:(int)size{
    [[DMScafferCreditManager scafferDefault] getMyServerRobotHoldCreditRobotId:self.robotId Size:[@(size) stringValue]  success:^(NSArray *holdCredit) {
        self.dataArray = [NSArray arrayWithArray:holdCredit];
        [self.tableView reloadData];
        self.totleCount = self.dataArray.count;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (self.totleCount == self.beforeCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        if (self.dataArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.dataArray.count==0) {
            UILabel *footLabel = [[UILabel alloc] initWithFrame:self.tableView.bounds];
            footLabel.text = @"暂无数据";
            footLabel.textColor = UIColorFromRGB(0x878787);
            footLabel.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = footLabel;
        }else{
            self.tableView.tableFooterView = [UIView new];
        }
    } faild:^{
        
    }];
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f5fa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMRobotHoldCreditCell class] forCellReuseIdentifier:@"DMRobotHoldCreditCell"];
        _tableView.rowHeight = 74;
        __weak __typeof(self) weakSelf = self;
        _tableView.mj_header = [self setRefreshHeader:^{
            weakSelf.size = 10;
            [weakSelf requestDataWithSize:weakSelf.size];
        }];
        _tableView.mj_footer = [self setRefreshFooter:^{
            weakSelf.size += 10;
            [weakSelf requestDataWithSize:weakSelf.size];
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.beforeCount = self.dataArray.count;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMRobotHoldCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMRobotHoldCreditCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.creditModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCreditDetailController *detailVC = [[DMCreditDetailController alloc] init];
    DMRobotHoldCreditModel *model = self.dataArray[indexPath.row];
    detailVC.guarantyStyle = model.guarantyStyle;
    detailVC.loanId = model.loanId;
    detailVC.title = model.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [@[] copy];
    }
    return _dataArray;
}

@end
