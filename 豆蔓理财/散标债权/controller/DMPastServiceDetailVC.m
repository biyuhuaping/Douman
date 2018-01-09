//
//  DMPastServiceDetailVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMPastServiceDetailVC.h"
#import "DMPastServiceHeadView.h"
#import "DMPastServiceDetailCell.h"
#import "LJQBuyListCell.h"
#import "DMScafferCreditManager.h"
#import "DMRobtEndDetailModel.h"
#import "DMRobtDetailModel.h"
typedef NS_ENUM(NSUInteger ,loadingType) {
   loadingTypeOfService,
    loadingTypeOfJoinList
};

@interface DMPastServiceDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger pageNumber;
    NSInteger sizeNumber;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)loadingType loadType;
@property (nonatomic, strong)DMPastServiceHeadView *headerView;

@property (nonatomic, strong)DMRobtEndDetailModel *detailModel;
@property (nonatomic, strong)NSMutableArray *joinListArr;
@end

static NSString *const pastDetailIdentifer = @"DMPastServiceDetailCellIdentifier";
static NSString *const PastListIdentifier = @"LJQBuyListCellIdentifier";
@implementation DMPastServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    sizeNumber = 10;
    self.title = @"往期服务详情";
    self.loadType = loadingTypeOfService;
    [self.view addSubview:self.tableView];
    [self addObserver:self forKeyPath:@"loadType" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
     [self requestEndRobotDetailWithID:self.robotID];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:@"loadType"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"loadType"]) {
        
        if ([change[@"new"] integerValue] == 0) {
            NSLog(@"服务");
            self.tableView.mj_footer = nil;
            self.tableView.tableFooterView = [UIView new];
        }else {
            NSLog(@"列表");
            __weak typeof(self) weakSelf = self;
            weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                sizeNumber += 10;
                [weakSelf requestJoinList];
            }];
        }
        
    }
}

#pragma tableViewDelegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.loadType == loadingTypeOfService) {
        return 1;
    }else {
        return self.joinListArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadType == loadingTypeOfService) {
        DMPastServiceDetailCell *cell = [[DMPastServiceDetailCell alloc] init];
        return [cell returnRowHeight] + 10;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.loadType == loadingTypeOfService) {
        return 0;
    }else {
        return 43;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.loadType == loadingTypeOfService) {
        return nil;
    }else {
        return [self createHeaderView:CGRectMake(0, 0, DMDeviceWidth, 43)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadType == loadingTypeOfService) {
        DMPastServiceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:pastDetailIdentifer forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.detailModel;
        return cell;
    }else {
        LJQBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:PastListIdentifier forIndexPath:indexPath];
        if (self.joinListArr.count != 0) {
            DMRobtDetailModel *model = self.joinListArr[indexPath.row];
            
            cell.timeLabel.text = [self stringFormatterDecimalStyle:@([model.orderAmount floatValue])];
            cell.userLabel.text = [self userString:model.mobile];
            cell.acountLabel.text = [NSString stringWithFormat:@"%@",model.timeCreated];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSString *)userString:(NSString *)string {
    NSString *str = string;
    for (int i = 0; i < string.length; i++) {
        if (i > 2 && i < 6) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(i ,1) withString:@"*"];
        }
    }
    return str;
}


- (UIView *)createHeaderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    NSArray *array = @[@"认购时间",@"认购用户",@"认购金额(元)"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((frame.size.width) / 3 * i, 0, frame.size.width / 3, 43) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        label.backgroundColor = UIColorFromRGB(0xffffff);
        label.text = array[i];
        [view addSubview:label];
    }
    return view;
}

- (void)setFootView{
    if (self.joinListArr.count == 0) {
        UILabel *label = [UILabel initWithFrame:CGRectMake(0, 260, DMDeviceWidth, DMDeviceHeight - 260)
                                           Font:14
                                           Text:@"暂无预约数据"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x878787)];
        self.tableView.tableFooterView = label;
    }
}

#pragma 网络请求
//详情
- (void)requestEndRobotDetailWithID:(NSString *)robotID {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToGetDetailRobtWithRobtID:robotID showView:self.view success:^(DMRobtEndDetailModel *detailModel) {
    
        self.detailModel = detailModel;
        self.headerView.model = detailModel;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];

    } faild:^{
        [self.tableView.mj_header endRefreshing];
        
    }];
}

//加入列表
- (void)requestJoinList {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMRobtToGetListRobtBuyWithPage:pageNumber size:sizeNumber showView:self.view robtID:self.robotID success:^(NSArray *buyArr) {
        self.joinListArr = [NSMutableArray arrayWithArray:buyArr];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (sizeNumber == self.joinListArr.count) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];

    } faild:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma lazyLoading 

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        [_tableView registerClass:[DMPastServiceDetailCell class] forCellReuseIdentifier:pastDetailIdentifer];
        [_tableView registerClass:[LJQBuyListCell class] forCellReuseIdentifier:PastListIdentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.headerView;
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.loadType == loadingTypeOfService) {
                [weakSelf requestEndRobotDetailWithID:weakSelf.robotID];
            }else {
                [weakSelf requestJoinList];
            }
        }];
    }
    return _tableView;
}

- (DMPastServiceHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[DMPastServiceHeadView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 262)];
        __weak typeof(self) weakSelf = self;
        _headerView.touchBtnEvent = ^(NSInteger index) {
            if (index == 0) {
                weakSelf.loadType = loadingTypeOfService;
                [weakSelf.tableView reloadData];
            }else {
                weakSelf.loadType = loadingTypeOfJoinList;
                [weakSelf requestJoinList];
                [weakSelf.tableView reloadData];
            }
        };
    }
    return _headerView;
}

- (NSMutableArray *)joinListArr {
    if (!_joinListArr) {
        _joinListArr = [@[] mutableCopy];
    }
    return _joinListArr;
}

@end
