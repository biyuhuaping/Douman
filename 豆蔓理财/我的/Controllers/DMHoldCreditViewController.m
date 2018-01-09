//
//  DMHoldCreditViewController.m
//  zaiquan
//
//  Created by wujianqiang on 2016/12/5.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMHoldCreditViewController.h"
#import "MenuButton.h"
#import "DMHoldTableCell.h"
#import "GZPieChartTwoView.h"
#import "GZOwnedSinglePeriodViewController.h"
#import "DMCreditDetailController.h"
#import "DMCreditRequestManager.h"
#import "DMMineViewController.h"
#import "LJQMoveBackTransition.h"
#import "DMCreditManageViewController.h"
#import "LJQEarlyReimbursementVC.h"
#import "DMHoldCreditModel.h"
#import "DMloanProportionModel.h"
#import "DMCreditAssetListModel.h"

typedef NS_ENUM (NSInteger,ListStyle){
    kTimeList,          //时间顺序
    kCarList,           //车险分期
    kConsumeList,       //消费分期
    kMortgageList       //车辆抵押
};

@interface DMHoldCreditViewController ()<UITableViewDelegate,UITableViewDataSource,MenuButtonDelegate>

@property (nonatomic, strong) UILabel *footlabel;
@property (nonatomic, strong) MenuButton *menuButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,assign) CGRect oldFrame;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@property (nonatomic, strong) DMHoldCreditModel *holdCreditModel;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSArray *loanArray;

@property (nonatomic, copy) NSString *style;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, assign) NSInteger beforeCount;
@end

@implementation DMHoldCreditViewController


- (instancetype)initWithIV:(UIView *)IV {
    self = [super init];
    if (self) {
        [self setup];
        self.oldFrame = [IV convertRect:IV.bounds toView:self.view];
        self.pieChartView.frame = self.oldFrame;
    }
    return self;
}

- (void)setup{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.backgroundColor = [UIColor clearColor];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"持有债权列表";
    self.style = @"";
    self.size = 10;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:UIColorFromRGB(0x4b5159)}];

    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self requestDataWithStyle:self.style Size:[@(self.size) stringValue]];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"债权管理" style:UIBarButtonItemStyleDone target:self action:@selector(creditManage)];
}

- (void)creditManage{
    DMCreditManageViewController *manageVC = [[DMCreditManageViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
}

- (void)requestDataWithStyle:(NSString *)style Size:(NSString *)size{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[DMCreditRequestManager manager] getHoldCreditListWithStyle:style Size:size Success:^(DMHoldCreditModel *creditModel, NSArray<DMCreditAssetListModel *> *assetList, NSArray<DMloanProportionModel *> *loans) {
        self.holdCreditModel = creditModel;
        self.loanArray = [NSArray arrayWithArray:loans];
        self.listArray = [NSMutableArray arrayWithArray:assetList];
        self.totleCount = self.listArray.count;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (self.totleCount == self.beforeCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        [self.tableView reloadData];
        if (self.listArray.count<10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count==0) {
            self.tableView.tableFooterView = self.footlabel;
        }else{
            self.tableView.tableFooterView = [UIView new];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } Failed:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refresh{
    [self requestDataWithStyle:self.style Size:[@(self.size) stringValue]];
}

- (void)footload{
    self.size +=10;
    [self requestDataWithStyle:self.style Size:[@(self.size) stringValue]];
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footload)];
    }
    return _tableView;
}


- (void)buttonAction:(UIButton *)buton{
    if ([self.holdCreditModel.aheadSettleNum floatValue] > 0) {
        [self.navigationController pushViewController:[[LJQEarlyReimbursementVC alloc] init] animated:YES];
    }else{
        ShowMessage(@"暂无提前还款信息");
    }
}

#pragma mark

- (void)selectButtonWithIndex:(NSInteger)index{
    NSArray *array = [NSArray arrayWithObjects:@"",@"CarPledge",@"CarInsurance",@"ConsumerInstallment",@"CarMortgate", nil];
    self.style = array[index];
    [self requestDataWithStyle:array[index] Size:@"10"];
}


#pragma mark ---------- tableview delegate --------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.beforeCount = self.listArray.count;
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMHoldTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"holdCell"];
    if (!cell) {
        cell = [[DMHoldTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"holdCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.listModel = self.listArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCreditAssetListModel *listModel = self.listArray[indexPath.row];
    if (listModel.isAssetFinished) {
        return 40;
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GZOwnedSinglePeriodViewController *ospv = [[GZOwnedSinglePeriodViewController alloc]init];
    DMCreditAssetListModel *listModel = self.listArray[indexPath.row];
    ospv.assetId = listModel.assetId;
    [self.navigationController pushViewController:ospv animated:YES];
    

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self creatChartView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DMDeviceWidth+30;
}

- (UIView *)creatChartView{
    UIImageView *chartView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceWidth)];
    chartView.userInteractionEnabled = YES;

    chartView.backgroundColor = mainBack;
    NSArray *colors = @[UIColorFromRGB(0x212d46),UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4),UIColorFromRGB(0xfc745d),UIColorFromRGB(0x66e3ff)];
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:0];
    if (self.loanArray.count != 0) {
        [self.loanArray enumerateObjectsUsingBlock:^(DMloanProportionModel *loanModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [values addObject:[NSString stringWithFormat:@"%@%%",loanModel.loanPro]];
            [classes addObject:loanModel.loanType];
        }];
    }
    self.pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake(0, -20, DMDeviceWidth, 350 * DMDeviceWidth / 400) portions:values portionColors:colors radius:(350 * DMDeviceWidth / 400) / 2 - 75 lineWidth:15 values:values classes:classes];
    [chartView addSubview:self.pieChartView];
    
    
    
    CGFloat numdis = iPhone5?35:45;
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.pieChartView.frame)-numdis, DMDeviceWidth, numdis)];
    numLabel.text = @"0";
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:45];
    numLabel.textColor = MainRed;
    [chartView addSubview:numLabel];
    UILabel *holdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.pieChartView.frame)+7, DMDeviceWidth, 11)];
    holdLabel.text = @"持有债权（个）";
    holdLabel.textAlignment = NSTextAlignmentCenter;
    holdLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:iPhone5?9:11];
    holdLabel.textColor = LightGray;
    [chartView addSubview:holdLabel];
    
    CGFloat holddis = iPhone5?5:12;
    UILabel *holdMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(holdLabel.frame)+holddis, DMDeviceWidth, 11)];
    holdMoney.text = @"持有总额：0元";
    holdMoney.textAlignment = NSTextAlignmentCenter;
    holdMoney.font = [UIFont fontWithName:@"PingFangSC-Light" size:iPhone5?10:12];
    holdMoney.textColor = DarkGray;
    [chartView addSubview:holdMoney];
    [chartView addSubview:self.menuButton];
    
    UILabel *exceedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.menuButton.frame)-40, DMDeviceWidth/2, 10)];
    exceedLabel.text = @"逾期债权：0个";
    exceedLabel.textAlignment = NSTextAlignmentCenter;
    exceedLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    exceedLabel.textColor = LightGray;
    [chartView addSubview:exceedLabel];
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame =CGRectMake(DMDeviceWidth/2, CGRectGetMinY(self.menuButton.frame)-50, DMDeviceWidth/2, 30);
    [payButton setTitle:@"提前还款：0个" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    [payButton setTitleColor:LightGray forState:UIControlStateNormal];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:payButton.titleLabel.text];
    NSRange dayRange = NSMakeRange(0, payButton.titleLabel.text.length);
    [hintString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:dayRange];
    payButton.titleLabel.attributedText = hintString;
    [payButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [chartView addSubview:payButton];
    UIImageView *botLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.menuButton.frame)- 20, DMDeviceWidth, 1)];
    botLine.image = [UIImage imageNamed:@"botline"];
//    [chartView addSubview:botLine];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.menuButton.frame)- 10, DMDeviceWidth, 8)];
//    lineView.alpha = 0.8f;
    lineView.backgroundColor = MainF5;
    [chartView addSubview:lineView];
    
    if (self.holdCreditModel) {
        numLabel.text = [NSString stringWithFormat:@"%@",self.holdCreditModel.loanNum];
        if (self.holdCreditModel.totalHasAmount) {
            holdMoney.text = [NSString stringWithFormat:@"持有总额：%@元",[NSString insertCommaWithString:self.holdCreditModel.totalHasAmount]];
        }
        exceedLabel.text = [NSString stringWithFormat:@"逾期债权：%@个",self.holdCreditModel.overdueNum];
        [payButton setTitle:[NSString stringWithFormat:@"提前还款：%@个",self.holdCreditModel.aheadSettleNum] forState:UIControlStateNormal];
    }
    
    return chartView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [@[] mutableCopy];
    }
    return _listArray;
}

- (NSArray *)loanArray{
    if (_loanArray == nil) {
        self.loanArray = [@[] copy];
    }
    return _loanArray;
}

- (MenuButton *)menuButton{
    if (_menuButton == nil) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, DMDeviceWidth-30, DMDeviceWidth, 40) TitleArray:@[@"时间顺序",@"质押快投",@"车保智投",@"分期慧投",@"抵押智投"] SelectColor:MainGreen UnselectColor:LightGray];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (UILabel *)footlabel{
    if (_footlabel == nil) {
        self.footlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 200)];
        _footlabel.text = @"没有相关数据";
        _footlabel.textColor = DarkGray;
        _footlabel.textAlignment = NSTextAlignmentCenter;
    }
    return _footlabel;
}
@end
