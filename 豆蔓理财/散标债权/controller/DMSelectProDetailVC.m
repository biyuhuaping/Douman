//
//  DMSelectProDetailVC.m
//  豆蔓理财
//
//  Created by edz on 2017/7/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMSelectProDetailVC.h"
#import "DMSelectProductHeaderView.h"
#import "DMSelectProductDetailCell.h"
#import "LJQBuyListCell.h"
#import "DMHomeFootView.h"
#import "DMHomeRequestManager.h"
#import "GZAssetInfoModel.h"
#import "GZBuyListModel.h"
#import "GZLoanListModel.h"
#import "DMHomeListModel.h"
#import "DMScatterConfirmBuyVC.h"
#import "DMLoginViewController.h"
#import "UIView+Shadow.h"
#import "DMCreditDetailController.h"
#import "DMLoginViewController.h"
#import "DMCalculatorView.h"
#import "DMCalculateView.h"

typedef NS_ENUM(NSUInteger ,selectedStyle) {
    selectedStyleDetail,
    selectedStyleBuyList,
    selectedStyleScafferCredit
};

@interface DMSelectProDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

{
    NSInteger pageNumber;
    NSInteger sizeNumberBuy;
    NSInteger sizeNumberLoan;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)DMSelectProductHeaderView *headerView;
@property (nonatomic, assign)selectedStyle loadStyle;

@property (nonatomic, strong)NSMutableArray *buyListArr;
@property (nonatomic, strong)NSMutableArray *loanListArr;

@property (nonatomic, strong)GZAssetInfoModel *assetInfoModel;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) CLTShareView *shareView;

@end

static NSString *const selectedStyleOne = @"DMSelectProductDetailCell";
static NSString *const selectedStyleTwo = @"selectedStyleTwobuy";
@implementation DMSelectProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    sizeNumberBuy = 10;
    sizeNumberLoan = 10;
    self.loadStyle = selectedStyleDetail;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.botView];
    [self.botView addSubview:self.addButton];

    
     [self addObserver:self forKeyPath:@"loadStyle" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestProductInfo];
    }];

    [self requestProductInfo];
    
    if ([self.productModel.assetStatus isEqualToString:@"HASENDED"]) {
        self.addButton.userInteractionEnabled = NO;
        [self.addButton setImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
    }else {
        [_addButton setImage:[UIImage imageNamed:@"tender_buynow"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"tender_buynow"] forState:UIControlStateHighlighted];
        self.addButton.userInteractionEnabled = YES;
    }
    

    [self creatShareView];
    [self createCalculatorView];
}

- (void)createCalculatorView{
    CGFloat wide = 41 * DMDeviceWidth/375;
    DMCalculatorView *calculatorView = [[DMCalculatorView alloc] initWithFrame:CGRectMake(DMDeviceWidth-wide, 300, wide,wide)];
    calculatorView.TouchAction = ^{
        NSInteger type = [self.productModel.assetRepaymentMethod isEqualToString:@"MonthlyInterest"]?0:1;
        NSString *rate;
        if ([self.productModel.assetInterestRate isEqualToString:@"0"]) {
            rate = [NSString stringWithFormat:@"%@",self.productModel.assetRate];
        }else{
            rate = [NSString stringWithFormat:@"%d",[self.productModel.assetRate integerValue] + [self.productModel.assetInterestRate integerValue]];
        }
        NSInteger month;
        if (self.productModel.termUnit == 1) {
            month=0;
        }else {
            month=[self.productModel.productCycle integerValue] - 1;
        }
        DMCalculateView *calculView = [[DMCalculateView alloc] initWithFrame:DMDeviceFrame Type:type Rate:rate Month:month];
        [[UIApplication sharedApplication].keyWindow addSubview:calculView];
    };
    [self.view addSubview:calculatorView];
}

- (void)creatShareView{
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share_friend_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    [self.navigationController.view addSubview:self.shareView];
    self.shareView.alpha = 0;
    
    _shareView.wechatBlock = ^(NSInteger index){
        if (index == 0) {
            [[ShareManager sharedManager] sharedFrindWithType:sharedTypeWeChat
                                                andController:weakSelf
                                                      andText:@"豆蔓智投喊你赚钱啦!"
                                                     andImage:[UIImage imageNamed:@"shareimage"]
                                                      Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                          Url:@"https://www.zlot.cn/mzc/lend"];
        }else{
            [[ShareManager sharedManager] sharedFrindWithType:sharedTypeFriendQurn
                                                andController:weakSelf
                                                      andText:@"豆蔓智投喊你赚钱啦！"
                                                     andImage:[UIImage imageNamed:@"shareimage"]
                                                      Content:@"定期理财 坐享收益 你本身就有做土豪的潜质"
                                                          Url:@"https://www.zlot.cn/mzc/lend"];
        }
    };
}

- (void)shareAction:(UIBarButtonItem *)item{
    [self.shareView show];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.shareView hide];
}

- (CLTShareView *)shareView{
    if (!_shareView) {
        self.shareView = [[CLTShareView alloc] init];
    }
    return _shareView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"loadStyle" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loadStyle"]) {
        
        if ([change[@"new"] integerValue] == 0) {
            NSLog(@"产品介绍");
            self.tableView.mj_footer = nil;
        }else if ([change[@"new"] integerValue] == 1){
            NSLog(@"购买列表");
            __weak typeof(self) weakSelf = self;
            weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                sizeNumberBuy += 10;
                [weakSelf requestBuyList];
            }];
        }else {
            NSLog(@"债权模式");
            __weak typeof(self) weakSelf = self;
            weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                sizeNumberLoan += 10;
                [weakSelf requestLoanList];
            }];
        }
        
    }
}


#pragma tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.loadStyle == selectedStyleDetail) {
        return 1;
    }else if (self.loadStyle == selectedStyleBuyList) {
        return self.buyListArr.count;
    }else {
        return self.loanListArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadStyle == selectedStyleDetail) {
        return [self getheight];
    }else if (self.loadStyle == selectedStyleBuyList) {
        return 44;
    }else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.loadStyle == selectedStyleDetail) {
        return 0;
    }else {
        return 46;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.loadStyle == selectedStyleDetail) {
        return nil;
    }else if (self.loadStyle == selectedStyleBuyList){
        return [self createHeaderView:CGRectMake(0, 0, DMDeviceWidth, 46) textArr:@[@"出借时间",@"出借用户",@"出借金额(元)"]];
    }else {
        return [self createHeaderView:CGRectMake(0, 0, DMDeviceWidth, 46) textArr:@[@"序号",@"债权名称",@"债权金额(元)"]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadStyle == selectedStyleDetail) {
        DMSelectProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedStyleOne forIndexPath:indexPath];
        cell.assetModel = self.assetInfoModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        LJQBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedStyleTwo forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.loadStyle == selectedStyleBuyList) {
            GZBuyListModel *buyModel = self.buyListArr[indexPath.row];
            cell.acountLabel.textColor = UIColorFromRGB(0x878787);
            cell.acountLabel.font = FONT_Regular(12.f);
            cell.userLabel.textColor = UIColorFromRGB(0x878787);
            cell.userLabel.font = FONT_Regular(12.f);
            cell.timeLabel.font = FONT_Regular(12.f);
            cell.timeLabel.textColor = UIColorFromRGB(0x878787);
            
            cell.acountLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(buyModel.buyTime) ? @"--" : buyModel.buyTime];
            cell.userLabel.text = [self userString:[NSString stringWithFormat:@"%@",isOrEmpty(buyModel.mobile) ? @"***********" : buyModel.mobile]];
            cell.timeLabel.text = [self stringFormatterDecimalStyle:isOrEmpty(buyModel.investAmount) ? @(0): @([buyModel.investAmount doubleValue])];
            
        }else {
            GZLoanListModel *loanModel = self.loanListArr[indexPath.row];
            cell.acountLabel.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
            cell.acountLabel.textColor = UIColorFromRGB(0x878787);
            cell.acountLabel.font = FONT_Regular(12.f);
            cell.userLabel.textColor = UIColorFromRGB(0x878787);
            cell.userLabel.font = FONT_Regular(12.f);
            cell.timeLabel.font = FONT_Regular(12.f);
            cell.timeLabel.textColor = UIColorFromRGB(0x878787);
            
            cell.userLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(loanModel.loanTitle)? @"--" : loanModel.loanTitle];
            cell.timeLabel.text = [self stringFormatterDecimalStyle:isOrEmpty([loanModel.loanAmount stringValue]) ? @(0) : loanModel.loanAmount];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.loadStyle == selectedStyleScafferCredit) {
        if (AccessToken) {
            GZLoanListModel *loanModel = self.loanListArr[indexPath.row];
            DMCreditDetailController *creditDetail = [[DMCreditDetailController alloc] init];
            creditDetail.guarantyStyle = loanModel.guarantyStyle;
            creditDetail.loanId = loanModel.loanId;
            creditDetail.title = loanModel.loanTitle;
            [self.navigationController pushViewController:creditDetail animated:YES];

        }else {
            [self SelectedComeToLogin];
        }
    }
}

- (void)SelectedComeToLogin {
    DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
    loginvc.current = YES;
    [self.navigationController pushViewController:loginvc animated:YES];
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

- (UIView *)createHeaderView:(CGRect)frame textArr:(NSArray *)textArr{
    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = UIColorFromRGB(0xffffff);
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((frame.size.width) / textArr.count * i, 0, frame.size.width / textArr.count, frame.size.height) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        label.font = FONT_Regular(12.f);
        label.backgroundColor = UIColorFromRGB(0xffffff);
        label.text = textArr[i];
        [view addSubview:label];
    }
    return view;
}

- (void)setFootView{
    UILabel *label = [UILabel initWithFrame:CGRectMake(0, 260, DMDeviceWidth, DMDeviceHeight - 260)
                                       Font:14
                                       Text:@""
                                  Alignment:NSTextAlignmentCenter
                                  TextColor:UIColorFromRGB(0x878787)];
    if (self.loadStyle == selectedStyleBuyList) {
        if (self.buyListArr.count == 0) {
            label.text = @"暂无购买数据";
            self.tableView.tableFooterView = label;
        }
    }
    
    if (self.loadStyle == selectedStyleScafferCredit) {
        if (self.loanListArr.count == 0) {
            label.text = @"暂无债权数据";
            self.tableView.tableFooterView = label;
        }
    }
    
}

#pragma 数据请求
//产品介绍
- (void)requestProductInfo {
    DMHomeRequestManager *manager = [DMHomeRequestManager manager];
    [manager DMGetProductInfoMessageWithAssetID:self.assetID showView:self.view success:^(GZAssetInfoModel *infoModel) {
        self.assetInfoModel = infoModel;
        self.navigationItem.title = [infoModel.guarantyName stringByAppendingString:@"-出借详情"];
        [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
    } faild:^(NSString *message) {
        ShowMessage(message);
         [self.tableView.mj_header endRefreshing];
    }];
}

//购买列表
- (void)requestBuyList {
    DMHomeRequestManager *manager = [DMHomeRequestManager manager];
    [manager DMGetProductBuyListWithAssetID:self.assetID page:pageNumber size:sizeNumberBuy showView:self.view success:^(NSArray<GZBuyListModel *> *buyListArr) {
        self.buyListArr = [NSMutableArray arrayWithArray:buyListArr];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (sizeNumberBuy == self.buyListArr.count) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    } faild:^(NSString *message) {
        ShowMessage(message);
    }];
}

//本期债权
- (void)requestLoanList {
    DMHomeRequestManager *manager = [DMHomeRequestManager manager];
    [manager DMGetLoanListWithAssetID:self.assetID page:pageNumber size:sizeNumberLoan showView:self.view success:^(NSArray<GZLoanListModel *> *loanListArr) {
        self.loanListArr = [NSMutableArray arrayWithArray:loanListArr];
        [self.tableView reloadData];
        [self setFootView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (sizeNumberLoan == self.loanListArr.count) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    } faild:^(NSString *message) {
        ShowMessage(message);
    }];
}

//立即购买
- (void)quickToBuy:(UIButton *)sender {
    if (AccessToken) {
        DMScatterConfirmBuyVC *confirmBuy = [[DMScatterConfirmBuyVC alloc] init];
        confirmBuy.productModel = self.productModel;
        confirmBuy.assetId = self.productModel.assetId;
        confirmBuy.guarantyStyle = self.assetInfoModel.guarantyStyle;
        confirmBuy.ToBuyStyle = buyStyleOfProduct;
        [self.navigationController pushViewController:confirmBuy animated:YES];
    }else{
        DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
        loginvc.current = YES;
        [self.navigationController pushViewController:loginvc animated:YES];
    }
}

#pragma lazyLoading

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight - 64 - 65) style:(UITableViewStylePlain)];
        [_tableView registerClass:[DMSelectProductDetailCell class] forCellReuseIdentifier:selectedStyleOne];
        [_tableView registerClass:[LJQBuyListCell class] forCellReuseIdentifier:selectedStyleTwo];
        _tableView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[DMHomeFootView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 50)];
    }
    return _tableView;
}

- (DMSelectProductHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DMSelectProductHeaderView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 247)];
        _headerView.assetModel = self.productModel;
        __weak typeof(self) weakSelf = self;
        _headerView.touchAction = ^(NSInteger index) {
            switch (index) {
                case 0:
                {
                    weakSelf.loadStyle = selectedStyleDetail;
                    [weakSelf.tableView reloadData];
                }
                    break;
                case 1:
                {
                    weakSelf.loadStyle = selectedStyleBuyList;
                     [weakSelf requestBuyList];
                    [weakSelf.tableView reloadData];
                }
                    break;
                case 2:
                {
                    weakSelf.loadStyle = selectedStyleScafferCredit;
                    [weakSelf requestLoanList];
                    [weakSelf.tableView reloadData];
                }
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _headerView;
}

- (NSMutableArray *)buyListArr {
    if (!_buyListArr) {
        _buyListArr = [@[] mutableCopy];
    }
    return _buyListArr;
}

- (NSMutableArray *)loanListArr {
    if (!_loanListArr) {
        _loanListArr = [@[] mutableCopy];
    }
    return _loanListArr;
}

- (UIButton *)addButton{
    if (!_addButton) {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(10, 0, DMDeviceWidth-20, 65);
        [_addButton addTarget:self action:@selector(quickToBuy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIView *)botView{
    if (!_botView) {
        self.botView = [[UIView alloc] initWithFrame:CGRectMake(0, DMDeviceHeight-64-65, DMDeviceWidth, 65)];
        _botView.backgroundColor = [UIColor whiteColor];
        [_botView setShadow];
    }
    return _botView;
}

- (CGFloat )getheight{
    NSString *str1;
    if ([self.assetInfoModel.guarantyStyle isEqualToString:@"CarInsurance"]) {
        str1 = @"车保智投是由豆蔓智投推出的一款具备高收益、低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }else if ([self.assetInfoModel.guarantyStyle isEqualToString:@""]) {
        str1 = @"质押快投(摇钱树)是由豆蔓智投推出的一款具备高收益、低风险的定期投资服务计划，产品采用按月付息到期还本的还款方式，让您省时安心。";
    }else if ([self.assetInfoModel.guarantyStyle isEqualToString:@""]) {
        str1 = @"分期慧投是由豆蔓智投推出的一款具备周期选择多样，资金使用灵活，低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }else {
        str1 = @"抵押智投是由豆蔓智投推出的一款具备长期稳定，资金使用灵活，低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }
    NSString *str2;
    if ([self.assetInfoModel.repaymentMethod isEqualToString:@"MonthlyInterest"]) {
        str2 = @"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n按月付息：购买产品计息后每自然月结息一次，利息收入计入账户余额，本金随最后一次结息日返还。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元";
    }else {
        str2 = @"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n等额本息：在还款期内，每月偿还同等数额的借款（包括本金和利息）计息日起每隔一个月，返回当月的本金和利息。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元";
    }
    CGRect oneRect = [str1 boundingRectWithSize:CGSizeMake(DMDeviceWidth-42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
    CGRect twoRect = [str2 boundingRectWithSize:CGSizeMake(DMDeviceWidth-42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
    return oneRect.size.height + twoRect.size.height + 18*4;
}
- (NSDictionary *)setLabelAttribute{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 4;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:FONT_Regular(12)};
    return dic;
}


@end
