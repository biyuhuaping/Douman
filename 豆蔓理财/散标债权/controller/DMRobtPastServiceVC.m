//
//  DMRobtPastServiceVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtPastServiceVC.h"
#import "DMRobtPastServiceCell.h"
#import "DMPastServiceDetailVC.h"
#import "DMScafferCreditManager.h"
#import "DMRobtEndListModel.h"
@interface DMRobtPastServiceVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UILabel *promptLabel;
    NSInteger pageNumber;
    NSInteger sizeNumber;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listDataSource;
@end

static NSString *const pastServiceIdentifier = @"DMRobtPastServiceCellIdentifier";
@implementation DMRobtPastServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    sizeNumber = 10;
    [self requestEndRobots];
    self.title = @"往期服务";
    [self.view addSubview:self.tableView];
    
    //下拉刷新
     __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestEndRobots];
    }];
    
   
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        sizeNumber += 10;
        [weakSelf requestEndRobots];
    }];
    [self tableViewFootView];
}

- (void)tableViewFootView {
    UIView *footView = [UIView new];
    if (promptLabel) {
        [promptLabel removeFromSuperview];
    }
    promptLabel = [UILabel createLabelFrame:CGRectMake(0, DMDeviceHeight - 90, DMDeviceWidth, 10) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:10.f];
    promptLabel.text = @"市场有风险，投资需谨慎";
    
    if ((self.listDataSource.count * 139) < (DMDeviceHeight - 100) ) {
        [self.tableView addSubview:promptLabel];
    }else {
        [footView setFrame:CGRectMake(0, 0, DMDeviceWidth, 50)];
        [promptLabel setFrame:CGRectMake(0, 10, DMDeviceWidth, 10)];
        [footView addSubview:promptLabel];
        self.tableView.tableFooterView = footView;
    }
}

- (void)setFootView{
    if (self.listDataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:self.tableView.bounds
                                           Font:14
                                           Text:@"暂无往期数据"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x878787)];
        self.tableView.tableFooterView = label;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMRobtPastServiceCell class] forCellReuseIdentifier:pastServiceIdentifier];
        _tableView.rowHeight = 110;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma tableViewDelegate && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMRobtPastServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:pastServiceIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.listDataSource.count != 0) {
        DMRobtEndListModel *model = self.listDataSource[indexPath.row];
        cell.listModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DMRobtEndListModel *model = self.listDataSource[indexPath.row];
    [self jumpToPastServiceDetailWithRobotID:model.ID];
}

- (void)jumpToPastServiceDetailWithRobotID:(NSString *)robotID {
    DMPastServiceDetailVC *detail = [[DMPastServiceDetailVC alloc] init];
    detail.robotID = robotID;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma 网络请求
- (void)requestEndRobots {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToGetEndRobtsWithPage:pageNumber size:sizeNumber showView:self.view success:^(NSArray *endRobtArr) {
        self.listDataSource = [NSMutableArray arrayWithArray:endRobtArr];
        [self.tableView reloadData];
        if (endRobtArr.count <= 0) {
            [self setFootView];
        }else {
            [self tableViewFootView];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (sizeNumber == self.listDataSource.count) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    } faild:^{
        
    }];
}

#pragma lazyLoading
- (NSMutableArray *)listDataSource {
    if (!_listDataSource) {
        _listDataSource = [@[] mutableCopy];
    }
    return _listDataSource;
}

@end
