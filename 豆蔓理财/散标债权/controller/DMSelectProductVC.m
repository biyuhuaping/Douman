//
//  DMSelectProductVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//
     /* 精选产品 */

#import "DMSelectProductVC.h"
#import "DMSelectProductCell.h"
#import "DMHomeRequestManager.h"
#import "DMHomeListModel.h"
#import "DMSelectProDetailVC.h"
@interface DMSelectProductVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *promptLabel;
    NSInteger pageNumber;
    NSInteger sizeNumber;
    NSString *assetStatus;// 产品状态
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

static NSString *const selectedProductIdentifier = @"DMSelectProductCell";
@implementation DMSelectProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    sizeNumber = 10;
    [self.view addSubview:self.tableView];

    [self.view addConstrainsWithVisualFormat:@"H:|-0-[v0]-0-|" Views:@[self.tableView]];
    [self.view addConstrainsWithVisualFormat:@"V:|-0-[v0]-0-|" Views:@[self.tableView]];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [self setRefreshHeader:^{
        [weakSelf requestSelectProduct];
    }];
    
    self.tableView.mj_footer = [self setRefreshFooter:^{
        sizeNumber += 10;
        [weakSelf requestSelectProduct];
    }];
    
    [self requestSelectProduct];
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
                                           Text:@"暂无精选产品"
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
    DMSelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedProductIdentifier forIndexPath:indexPath];
    DMHomeListModel *listModel = self.dataSource[indexPath.row];
    cell.scafferListModel = listModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DMHomeListModel *listModel = self.dataSource[indexPath.row];
    DMSelectProDetailVC *detail = [[DMSelectProDetailVC alloc] init];
    detail.assetID = listModel.assetId;
    detail.productModel = listModel;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requestSelectProduct {
    DMHomeRequestManager *manager = [DMHomeRequestManager manager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager getRecommendPage:pageNumber Size:sizeNumber Success:^(NSArray *recommendArray) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        self.dataSource = [NSMutableArray arrayWithArray:recommendArray];
        [self.tableView reloadData];
        if (recommendArray.count <= 0) {
            [self setFootView];
        }else {
            [self tableViewFootView];
        }
        
        assetStatus = ((DMHomeListModel *)[self.dataSource lastObject]).assetStatus;
        
        [self.tableView.mj_header endRefreshing];
        if ([assetStatus isEqualToString:@"HASENDED"]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
                if (sizeNumber == recommendArray.count) {
                    [self.tableView.mj_footer endRefreshing];
                }else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        }
    } faild:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        [_tableView registerClass:[DMSelectProductCell class] forCellReuseIdentifier:selectedProductIdentifier];
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
