//
//  LJQCreditTransferTheZoneVC.m
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

//债权转让专区
#import "LJQCreditTransferTheZoneVC.h"
#import "LJQConfirmTransferVC.h"
#import "LJQCreditTheZoneCell.h"
#import "DMCreditTransferListModel.h"
@interface LJQCreditTransferTheZoneVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *creditDataSource;

@property (nonatomic, assign)NSInteger listCount;
@end

static NSString *const CreditTheZoneIdentifier = @"CreditTheZoneIdentifiercell";
@implementation LJQCreditTransferTheZoneVC
@synthesize listCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"债权转让";
    listCount = 10;
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestCreditTransferData];
    }];
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        listCount += 10;
        [self requestCreditTransferData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestCreditTransferData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        [_tableView registerClass:[LJQCreditTheZoneCell class] forCellReuseIdentifier:CreditTheZoneIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setFootView{
    if (self.creditDataSource.count == 0) {
        self.tableView.scrollEnabled = NO;
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        UIImage *image = [UIImage imageNamed:@"creditNull"];
        UIImageView *pitcure = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth - image.size.width) / 2, (DMDeviceHeight - image.size.height) / 2 - 60, image.size.width, image.size.height)];
        pitcure.image = image;
        [view addSubview:pitcure];
        self.tableView.tableFooterView = view;
    }else{
        self.tableView.scrollEnabled = YES;
        self.tableView.tableFooterView = [UIView new];
    }
}

#pragma tableViewDelegate && tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.creditDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQCreditTheZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:CreditTheZoneIdentifier forIndexPath:indexPath];
    cell.listModel = self.creditDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.buyCredit = ^(UIButton *sender) {
        LJQConfirmTransferVC *confirmTransger = [[LJQConfirmTransferVC alloc] init];
        confirmTransger.listModel = self.creditDataSource[indexPath.row];
        [self.navigationController pushViewController:confirmTransger animated:YES];
    };
    return cell;
}

#pragma lazyLoading
- (NSMutableArray *)creditDataSource {
    if (!_creditDataSource) {
        _creditDataSource = [@[] mutableCopy];
    }
    return _creditDataSource;
}

#pragma request
- (void)requestCreditTransferData {
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager creditTransferListPage:1 size:listCount successBlock:^(NSArray *creditList) {
        self.creditDataSource = [NSMutableArray arrayWithArray:creditList];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } faild:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
