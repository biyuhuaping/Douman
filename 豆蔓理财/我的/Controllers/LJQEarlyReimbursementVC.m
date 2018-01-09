//
//  LJQEarlyReimbursementVC.m
//  豆蔓理财
//
//  Created by mac on 2016/12/9.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQEarlyReimbursementVC.h"
#import "LJQEarlyReimbursementCell.h"
#import "DMCreditDetailController.h"
#import "LJQEarlyBackMoneyModel.h"
static NSString *const earlyReimbursementIdentifier = @"LJQEarlyReimbursementCell";
@interface LJQEarlyReimbursementVC ()

@property (nonatomic, strong)NSMutableArray *DataSource;

@end

static NSInteger listCount = 20;
@implementation LJQEarlyReimbursementVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestDatapage:1 size:listCount];
    self.title = @"提前还款列表";

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[LJQEarlyReimbursementCell class] forCellReuseIdentifier:earlyReimbursementIdentifier];

    self.tableView.separatorColor = MainLine;
    [self.tableView reloadData];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDatapage:1 size:listCount];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        listCount += 10;
        [self requestDatapage:1 size:listCount];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.DataSource.count;
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createHeaderView:CGRectMake(0, 0, SCREENWIDTH, 43)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    LJQEarlyReimbursementCell *cell = [tableView dequeueReusableCellWithIdentifier:earlyReimbursementIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.numberLabel.text = [@(indexPath.row + 1) stringValue];
    cell.model = self.DataSource[indexPath.row];
    return cell;
}

- (UIView *)createHeaderView:(CGRect)frame {
//    UIImage *image = [UIImage imageNamed:@"深色统一"];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    NSArray *array = @[@"所属产品",@"债权名称",@"持有金额"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 3 * i, 0, SCREENWIDTH / 3, 43) labelColor:DarkGray textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        if (i== 0) {
            label.frame = CGRectMake(22, 0, SCREENWIDTH / 3, 43);
            label.textAlignment = NSTextAlignmentLeft;
        }
        if (i == 2) {
            label.frame = CGRectMake(SCREENWIDTH - SCREENWIDTH / 3 - 22, 0, SCREENWIDTH / 3, 43);
            label.textAlignment = NSTextAlignmentRight;
        }
        label.text = array[i];
        [view addSubview:label];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x,frame.size.height-1,frame.size.width,1)];
    lineView.backgroundColor = MainLine;
    [view addSubview:lineView];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DMCreditDetailController *credit = [[DMCreditDetailController alloc] init];
//    LJQEarlyBackMoneyModel *model = self.DataSource[indexPath.row];
//    credit.title = model.title;
//    credit.loanId = model.loanId;
//    credit.guarantyStyle = model.guarantyStyle;
//    [self.navigationController pushViewController:credit animated:YES];
    
}

- (NSMutableArray *)DataSource {
    if (!_DataSource) {
        self.DataSource = [@[] mutableCopy];
    }
    return _DataSource;
}

- (void)requestDatapage:(NSInteger)page size:(NSInteger)size {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQEarlyBackMoneypage:page size:size SuccessBlock:^(NSInteger index, NSArray *array, NSString *message) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.DataSource = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)setFootView{
    if (self.DataSource.count == 0) {
        UILabel *label = [UILabel initWithFrame:self.tableView.bounds
                                           Font:17
                                           Text:@"暂无数据"
                                      Alignment:NSTextAlignmentCenter
                                      TextColor:UIColorFromRGB(0x595757)];
        self.tableView.tableFooterView = label;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
}


-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
