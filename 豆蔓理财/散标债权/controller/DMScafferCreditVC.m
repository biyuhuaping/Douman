//
//  DMScafferCreditVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScafferCreditVC.h"
#import "DMScafferListCell.h"
#import "DMTenderViewController.h"
#import "DMScafferCreditManager.h"
#import "DMScafferListModel.h"
#import "DMAdzukibeanRobtVC.h"
#import "DMSelectProductVC.h"
@interface DMScafferCreditVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UILabel *promptLabel;
    
   // DMSelectProductVC *productVC;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger pageNumber; //页码
@property (nonatomic, assign)NSInteger sizeNumber; //每页条数
@property (nonatomic, assign)NSInteger totalSize; //总条数

@property (nonatomic, strong)UIButton *productBtn;
@property (nonatomic, strong)UIButton *scafferBtn;
@property (nonatomic, strong)UIButton *robotBtn;

@end
static NSString *const listIdentifer = @"DMScafferListCell";
@implementation DMScafferCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNumber = 1;
    self.sizeNumber = 10;
    [self getScafferCreditListData];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:self.tableView];
    

    [self.view addConstrainsWithVisualFormat:@"H:|-0-[v0]-0-|" Views:@[self.tableView]];
    [self.view addConstrainsWithVisualFormat:@"V:|-0-[v0]-0-|" Views:@[self.tableView]];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [self setRefreshHeader:^{
        [weakSelf getScafferCreditListData];
    }];
    
    self.tableView.mj_footer = [self setRefreshFooter:^{
        weakSelf.sizeNumber += 10;
        [weakSelf getScafferCreditListData];
    }];
    
  
}

- (void)setNavBar {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 30;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:self.scafferBtn];
    self.navigationItem.leftBarButtonItems = @[space,leftBtn];
    
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space2.width = 30;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:self.robotBtn];
    self.navigationItem.rightBarButtonItems = @[rightBtn,space2];
    
    self.navigationItem.titleView = self.productBtn;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self getScafferCreditListData];
}

- (void)tableViewFootView {
    UIView *footView = [UIView new];
    if (promptLabel) {
        [promptLabel removeFromSuperview];
    }
    promptLabel = [UILabel createLabelFrame:CGRectMake(0, DMDeviceHeight - 140, DMDeviceWidth, 10) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:10.f];
    promptLabel.text = @"市场有风险，投资需谨慎";

    if ((self.dataSource.count * 130) < (DMDeviceHeight - 100) ) {
        [self.tableView addSubview:promptLabel];
    }else {
        [footView setFrame:CGRectMake(0, 0, DMDeviceWidth, 50)];
        [promptLabel setFrame:CGRectMake(0, 10, DMDeviceWidth, 10)];
        [footView addSubview:promptLabel];
        self.tableView.tableFooterView = footView;
    }
}

- (void)setFootView{
    if (self.dataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:self.tableView.bounds
                                           Font:14
                                           Text:@"暂无可售散标债权"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x878787)];
        self.tableView.tableFooterView = label;
    }
}

#pragma tableViewDelegage && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMScafferListCell *cell = [tableView dequeueReusableCellWithIdentifier:listIdentifer forIndexPath:indexPath];
    DMScafferListModel *scafferModel = self.dataSource[indexPath.row];
    if (self.dataSource.count != 0) {
         cell.scafferListModel = scafferModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DMScafferListModel *model = self.dataSource[indexPath.row];
    
    if (![model.status isEqualToString:@"OPENED"]) {

    }else {
        DMTenderViewController *tenderVC = [[DMTenderViewController alloc] init];
        tenderVC.listModel = model;
        [self.navigationController pushViewController:tenderVC animated:YES];
    }
   
}

#pragma requestEvent

- (void)getScafferCreditListData {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMGetScafferCreditListDataPage:self.pageNumber size:self.sizeNumber months:0 showView:self.view success:^(NSArray *dataList,NSInteger totalSize) {
        self.totalSize = totalSize;
        self.dataSource = [NSMutableArray arrayWithArray:dataList];
        [self.tableView reloadData];
        if (dataList.count <= 0) {
            [self setFootView];
        }else {
            [self tableViewFootView];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (self.sizeNumber == self.totalSize) {
                 [self.tableView.mj_footer endRefreshing];
            }else {
                 [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    } faild:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self setFootView];
    }];
}

#pragma lazyLoading

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [_tableView registerClass:[DMScafferListCell class] forCellReuseIdentifier:listIdentifer];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}



@end
