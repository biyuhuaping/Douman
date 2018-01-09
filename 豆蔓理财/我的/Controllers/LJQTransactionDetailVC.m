//
//  LJQTransactionDetailVC.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQTransactionDetailVC.h"
#import "LJQTransactionDetailCell.h"
#import "LJQTransactionView.h"
@interface LJQTransactionDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *MyTableView;
@property (nonatomic, strong)UILabel *accountLabel;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)LJQTransactionView *transactionView;

@property (nonatomic, strong)NSString *leftTimeStr;//左边时间参数
@property (nonatomic, strong)NSString *rightTimeStr; //右边时间参数


@end

static NSString *const cellIdentifier = @"transactioncell";

static NSInteger listCount = 20;
@implementation LJQTransactionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.leftTimeStr = [self ReturnNowDate];
    self.rightTimeStr = [self ReturnNowDate];
    self.selectType = @"ASSET";
    self.title = @"交易明细";
    [self requestTradeDataSource:self.leftTimeStr endTime:self.rightTimeStr type:self.selectType page:1 size:listCount];
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self createTransactionView];
    
    self.MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 126, SCREENWIDTH, [UIScreen mainScreen].bounds.size.height - 238) style:(UITableViewStylePlain)];
    [self.MyTableView registerClass:[LJQTransactionDetailCell class] forCellReuseIdentifier:cellIdentifier];
    self.MyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    self.MyTableView.rowHeight = 40;
    [self.view addSubview:self.MyTableView];
    [self.MyTableView reloadData];
    
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    self.MyTableView.mj_header = [self setRefreshHeader:^{
        [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:weakSelf.selectType page:1 size:listCount];
    }];
    self.MyTableView.mj_header.automaticallyChangeAlpha = YES;
    //上拉加载
    self.MyTableView.mj_footer = [self setRefreshFooter:^{
        listCount += 10;
        [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:weakSelf.selectType page:1 size:listCount];
    }];
    [self createBottomView];

}


- (void)setFootView{
    if (self.dataSource.count == 0) {
        UILabel *label = [UILabel createLabelFrame:self.MyTableView.bounds labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
        label.text = @"暂无相关数据";
        self.MyTableView.tableFooterView = label;
    }else{
        self.MyTableView.tableFooterView = [UIView new];
    }
}


- (void)createTransactionView {
    self.transactionView = [[LJQTransactionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 118)];
 
    
    __weak LJQTransactionDetailVC *weakSelf = self;
    
    self.transactionView.leftTime = ^(NSString *string) {
        weakSelf.leftTimeStr = string;
        
        if ([weakSelf.rightTimeStr isEqualToString:@""]) {
           //  [weakSelf requestTradeDataSource:@"" endTime:@"" type:weakSelf.selectType page:1 size:listCount];
            weakSelf.rightTimeStr = [weakSelf ReturnNowDate];
            [weakSelf ruquestLaterData];
        }else{
            [weakSelf ruquestLaterData];
                  }
            };
    self.transactionView.rightTime = ^(NSString *string) {
        weakSelf.rightTimeStr = string;
        if ([weakSelf.leftTimeStr isEqualToString:@""]) {
          //   [weakSelf requestTradeDataSource:@"" endTime:@"" type:weakSelf.selectType page:1 size:listCount];
            weakSelf.leftTimeStr = [weakSelf ReturnNowDate];
            [weakSelf ruquestLaterData];
        }else{
            [weakSelf ruquestLaterData];
        }
            
    };
    
    self.transactionView.buttonSelectedBK = ^(NSInteger index) {
        switch (index) {
            case 0:
            {
                //认购
               // [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:@"ASSET" page:1 size:10];
                weakSelf.selectType = @"ASSET";
                [weakSelf ruquestLaterData];
            }
                break;
            case 1:
            {
                //回款
               // [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:@"INVEST_REPAY" page:1 size:10];
                weakSelf.selectType = @"INVEST_REPAY";
                [weakSelf ruquestLaterData];
            }
                break;
            case 2:
            {
                //充值
               // [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:@"DEPOSIT" page:1 size:10];
                weakSelf.selectType = @"DEPOSIT";
                [weakSelf ruquestLaterData];
            }
                break;
            case 3:
            {
                //提现
               // [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:@"WITHDRAW" page:1 size:10];
                weakSelf.selectType = @"WITHDRAW";
                [weakSelf ruquestLaterData];
            }
                break;
            case 4:
            {
                //红包奖金
               // [weakSelf requestTradeDataSource:weakSelf.leftTimeStr endTime:weakSelf.rightTimeStr type:@"REWARD_FXJL" page:1 size:10];
                weakSelf.selectType = @"REWARD_FXJL";
                [weakSelf ruquestLaterData];
            }
                break;
                case 5:
            {
                weakSelf.selectType = @"FEE";
                [weakSelf ruquestLaterData];
            }
                break;
                
            default:
                break;
        }
    };
    
    [self.view addSubview:self.transactionView];
}

- (void)createBottomView {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64 - 49, SCREENWIDTH, 50)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.accountLabel = [UILabel createLabelFrame:CGRectMake(23, 18, SCREENWIDTH, 13) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    [self.bottomView addSubview:self.accountLabel];
    [self.view addSubview:self.bottomView];
}

#pragma tableViewDataSource && delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createHeaderView:CGRectMake(0, 0, SCREENWIDTH, 43)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJQTransactionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (UIView *)createHeaderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    NSArray *array = @[@"项目",@"金额(元)",@"时间",@"状态"];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 4 * i, 0, SCREENWIDTH / 4, 43) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        label.text = array[i];
        [view addSubview:label];
    }
    return view;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.transactionView dismiss];
}

- (void)requestTradeDataSource:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type page:(NSInteger)page size:(NSInteger)size {
    
    [[LJQMineRequestManager RequestManager] LJQTradeDetailType:type startTime:startTime endTime:endTime page:page size:size successBlock:^(NSArray *array, CGFloat amount, NSInteger index, NSString *message) {
        
        NSString *string = [self stringFormatterDecimalStyle:@(amount)];
        self.accountLabel.text = [NSString stringWithFormat:@"查询范围内总金额：%@元",string];
        self.dataSource = [NSMutableArray arrayWithArray:array];
        [self.MyTableView reloadData];
        [self setFootView];
        [self.MyTableView.mj_header endRefreshing];
        [self.MyTableView.mj_footer endRefreshing];
    } faild:^{
        [self.MyTableView.mj_header endRefreshing];
        [self.MyTableView.mj_footer endRefreshing];
    }];
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}

- (void)ruquestLaterData {
    NSComparisonResult result = [self compareEarlyDate:self.leftTimeStr laterDate:self.rightTimeStr];
    if (result == NSOrderedAscending) {
        //开始时间 > 结束时间
        NSLog(@"开始时间 < 结束时间");
         [self requestTradeDataSource:self.leftTimeStr endTime:self.rightTimeStr type:self.selectType page:1 size:listCount];
    }
    if (result == NSOrderedSame) {
        //开始时间和结束时间相同
        NSLog(@"开始时间和结束时间相同");
        [self requestTradeDataSource:self.leftTimeStr endTime:self.rightTimeStr type:self.selectType page:1 size:listCount];
    }
    
    if (result == NSOrderedDescending) {
        //开始时间 < 结束时间早
        NSLog(@"开始时间 > 结束时间早");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择规范的时间" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];

    }

}


- (NSComparisonResult)compareEarlyDate:(NSString *)earlyDate laterDate:(NSString *)laterDate {
    NSDate *early = [self returnTimeDate:earlyDate];
    NSDate *later = [self returnTimeDate:laterDate];
    return  [early compare:later];
}

- (NSDate *)returnTimeDate:(NSString *)timeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:timeDate];
    return date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)ReturnNowDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}


@end
