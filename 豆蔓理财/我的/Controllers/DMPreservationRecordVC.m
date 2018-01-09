//
//  DMPreservationRecordVC.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMPreservationRecordVC.h"
#import "DMWebViewController.h"
#import "DMKeepRecordCell.h"
#import "DMKeepRecordModel.h"
@interface DMPreservationRecordVC ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger pageNumber;
    NSInteger sizeNumber;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *keepRecordArr;
@end

static NSString *const keepRecordIdentifier = @"DMKeepRecordCell";
@implementation DMPreservationRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保全记录";
    pageNumber = 1;
    sizeNumber = 10;
    [self.view addSubview:self.tableView];
    
    [self requestPerservationRecordListWithType:@""];
    
    //刷新
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [self setRefreshHeader:^{
        [weakSelf loadKeepRecordData];
    }];

    self.tableView.mj_footer = [self setRefreshFooter:^{
        sizeNumber += 10;
        [weakSelf requestPerservationRecordListWithType:@""];
    }];
}

- (void)loadKeepRecordData {
    [self requestPerservationRecordListWithType:@""];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keepRecordArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 55)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [view addSubview:[self createHeaderView:CGRectMake(0, 10, DMDeviceWidth, 45) textArr:@[@"保全时间",@"保全类型",@"保全结果",@"保全结果"]]];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMKeepRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:keepRecordIdentifier forIndexPath:indexPath];
    if (self.keepRecordArr.count != 0) {
        cell.keepModel = self.keepRecordArr[indexPath.row];
    }
    cell.checkTheDetail = ^{
        DMKeepRecordModel *keepModel = self.keepRecordArr[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        if (!isOrEmpty(keepModel.SECURITYNUMBER)) {
            [weakSelf keepRecordDetailWithParameter:keepModel.SECURITYNUMBER title:@"保全详情"];
        }else {
            ShowMessage(@"暂无详情");
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)createHeaderView:(CGRect)frame textArr:(NSArray *)textArr{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((frame.size.width) / textArr.count * i, 0, frame.size.width / textArr.count, frame.size.height) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:14.f];
        label.font = FONT_Regular(14.f);
        label.backgroundColor = UIColorFromRGB(0xffffff);
        label.text = textArr[i];
        [view addSubview:label];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, DMDeviceWidth, 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [view addSubview:line];
    return view;
}

//保全记录详情
- (void)keepRecordDetailWithParameter:(NSString *)SECURITYNumber title:(NSString *)title{
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.title = title;
    webVC.webUrl = KeepRecord(SECURITYNumber);
    [self.navigationController pushViewController:webVC animated:YES];
}

//保全记录数据
- (void)requestPerservationRecordListWithType:(NSString *)type {
    
    LJQMineRequestManager *manager = [LJQMineRequestManager RequestManager];
    [manager DM_GetPreservationRecordDataWithPage:pageNumber size:sizeNumber type:type showView:self.view successBlock:^(NSArray<DMKeepRecordModel *> *keepRecordList) {
        
        self.keepRecordArr = [NSMutableArray arrayWithArray:keepRecordList];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (sizeNumber == keepRecordList.count) {
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight - 64) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMKeepRecordCell class] forCellReuseIdentifier:keepRecordIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)keepRecordArr {
    if (!_keepRecordArr) {
        _keepRecordArr = [@[] mutableCopy];
    }
    return _keepRecordArr;
}

@end
