//
//  DMTenderViewController.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderViewController.h"
#import "DMTenderHeadView.h"
#import "DMTenderCheckCell.h"
#import "DMTenderDescCell.h"
#import "DMScafferCreditManager.h"
#import "DMTenderRuleCell.h"
#import "DMTenderDescModel.h"
#import "DMCreditDetailController.h"
#import "DMScatterConfirmBuyVC.h"
#import "DMScafferListModel.h"
#import "LJQBuyListCell.h"
#import "GZBuyListModel.h"
#import "DMLoginViewController.h"
#import "UIView+Shadow.h"
#import "DMCalculatorView.h"
#import "DMCalculateView.h"

typedef NS_ENUM(NSUInteger, MenuType) {
    AssetDesc,
    BuyList,
};

@interface DMTenderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) DMTenderDescModel *tenderModel;
@property (nonatomic, strong) NSMutableArray *authenArray;
@property (nonatomic, strong) DMTenderHeadView *headView;

@property (nonatomic) MenuType menuType;

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger totleCount;
@property (nonatomic, assign) NSInteger beforeCount;
@property (nonatomic, strong) CLTShareView *shareView;

@property (nonatomic, strong) UIView *botView;
@end

@implementation DMTenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 10;
    
    self.menuType = AssetDesc;
    self.navigationItem.title = @"散标详情";
    self.img.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self requestData];
    
    [self creatShareView];
    [self createViews];
    [self createCalculatorView];
}

- (void)createCalculatorView{
    CGFloat wide = 41 * DMDeviceWidth/375;
    DMCalculatorView *calculatorView = [[DMCalculatorView alloc] initWithFrame:CGRectMake(DMDeviceWidth-wide, 300, wide,wide)];
    calculatorView.TouchAction = ^{
        NSInteger type = [self.listModel.method isEqualToString:@"MonthlyInterest"]?0:1;
        NSString *rate;
        if ([self.listModel.interestRate isEqualToString:@"0"]) {
            rate = [NSString stringWithFormat:@"%@",self.listModel.rate];
        }else{
            rate = [NSString stringWithFormat:@"%d",[self.listModel.rate integerValue] + [self.listModel.interestRate integerValue]];
        }
        NSInteger month;
        if (self.listModel.termUnit == 1) {
            month=0;
        }else {
            month=[self.listModel.months integerValue] - 1;
        }
        DMCalculateView *calculView = [[DMCalculateView alloc] initWithFrame:DMDeviceFrame Type:type Rate:rate Month:month];
        [[UIApplication sharedApplication].keyWindow addSubview:calculView];
    };
    [self.view addSubview:calculatorView];
}

- (void)requestBuyListWithSize:(NSString *)size{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DMScafferCreditManager scafferDefault] getTenderBuyListWithLoadId:self.listModel.loanId Size:size success:^(NSArray *buyList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.listArray = [NSArray arrayWithArray:buyList];
        self.totleCount = self.listArray.count;
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithCompletionBlock:^{
            if (self.totleCount == self.beforeCount) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        if (self.listArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.listArray.count > 0) {
            self.tableView.tableFooterView = [UIView new];
        }else{
            UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 200)];
            footLabel.text = @"暂无数据";
            footLabel.textColor = UIColorFromRGB(0x878787);
            footLabel.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = footLabel;
        }

    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createViews{
    [self.view addSubview:self.tableView];
    [self setHeadView];
    [self setFootView];
    [self.view addSubview:self.botView];
    [self.botView addSubview:self.addButton];

    if ([self.listModel.progressNum isEqualToString:@"1"]) {
        self.addButton.userInteractionEnabled = NO;
        [self.addButton setImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
    }else{
        [_addButton setImage:[UIImage imageNamed:@"tender_buynow"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"tender_buynow"] forState:UIControlStateHighlighted];
        self.addButton.userInteractionEnabled = YES;
    }
}

- (void)requestData{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[DMScafferCreditManager scafferDefault] getCreditDescWithLoanId:self.listModel.loanId Success:^(DMTenderDescModel *tenderModel, NSArray *authenArray) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.tenderModel = tenderModel;
        self.authenArray = [authenArray mutableCopy];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } faild:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setHeadView{
    self.tableView.tableHeaderView = self.headView;
    self.headView.listModel = self.listModel;
}

- (DMTenderHeadView *)headView{
    if (!_headView) {
        self.headView = [[DMTenderHeadView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 242)];
        __weak __typeof(self) weakSelf = self;

        _headView.SelectButton = ^(NSInteger index) {
            if (index==0) {
                weakSelf.menuType = AssetDesc;
                [weakSelf requestData];
                weakSelf.tableView.mj_footer = nil;
            }else{
                weakSelf.menuType = BuyList;
                [weakSelf requestBuyListWithSize:[@(weakSelf.size) stringValue]];
                weakSelf.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                    weakSelf.size += 10;
                    [weakSelf requestBuyListWithSize:[@(weakSelf.size) stringValue]];
                }];
            }
        };
    }
    return _headView;
}

- (void)setFootView{
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 30)];
    warnLabel.text = @"市场有风险，投资需谨慎";
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
    warnLabel.textColor = UIColorFromRGB(0x9a9a9a);
    warnLabel.backgroundColor = UIColorFromRGB(0xf6f5fa);
    self.tableView.tableFooterView = warnLabel;
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-65-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xf6f5fa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DMTenderDescCell class] forCellReuseIdentifier:@"DMTenderDescCell"];
        [_tableView registerClass:[DMTenderCheckCell class] forCellReuseIdentifier:@"DMTenderCheckCell"];
        [_tableView registerClass:[DMTenderRuleCell class] forCellReuseIdentifier:@"DMTenderRuleCell"];
        [_tableView registerClass:[LJQBuyListCell class] forCellReuseIdentifier:@"LJQBuyListCell"];

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (self.menuType == AssetDesc) {
                [self requestData];
            }else{
                [self requestBuyListWithSize:[@(self.size) stringValue]];
            }
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.menuType == AssetDesc) {
        return 4;
    }else{
        self.beforeCount = self.listArray.count;
        return self.listArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.menuType == AssetDesc) {
        switch (indexPath.row) {
            case 0:{
                DMTenderCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMTenderCheckCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell createWithArryay:self.authenArray];
                return cell;
            }break;
            case 1:{
                DMTenderRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMTenderRuleCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.ruleStr = self.listModel.method;
                return cell;
            }break;
            case 2:{
                DMTenderDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DMTenderDescCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.loanDesc = self.tenderModel.loanDescription;
                return cell;
            }break;
            case 3:{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
                cell.textLabel.text = @"查看债权详情";
                cell.textLabel.font = FONT_Regular(13);
                cell.textLabel.textColor = UIColorFromRGB(0xff7c59);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSMutableAttributedString *cellstr=[[NSMutableAttributedString alloc]initWithString:cell.textLabel.text];
                [cellstr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 6)];
                cell.textLabel.attributedText = cellstr;
                return cell;
            }break;
            default:
                return nil;
                break;
        }
    }else{
        LJQBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LJQBuyListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GZBuyListModel *model = self.listArray[indexPath.row];
        cell.acountLabel.text = model.buyTime;
        cell.userLabel.text = model.mobile.length>9?[NSString stringWithFormat:@"%@****%@",[model.mobile substringToIndex:3],[model.mobile substringFromIndex:7]]:[NSString stringWithFormat:@"%@********",[model.mobile substringToIndex:3]];
        cell.timeLabel.text = [[NSString insertCommaWithString:model.investAmount] stringByAppendingString:@"元"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.menuType == BuyList) {
        return 43;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.menuType == BuyList) {
        return [self createHeaderView:CGRectMake(0, 0, SCREENWIDTH, 43)];
    }else{
        return nil;
    }
}

- (UIView *)createHeaderView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    NSArray *array = @[@"出借时间",@"出借用户",@"出借金额(元)"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 3 * i, 0, SCREENWIDTH / 3, 43) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentCenter) textFont:13.f];
        label.text = array[i];
        [view addSubview:label];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.menuType == AssetDesc) {
        switch (indexPath.row) {
            case 0:
                return self.authenArray.count>3?130:90;
                break;
            case 1:
                return [self getheight];
                break;
            case 2:{
                if (self.tenderModel.loanDescription) {
                    CGRect rect = [self.tenderModel.loanDescription boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_Regular(10)} context:nil];
                    return rect.size.height + 60;
                }else{
                    return 60;
                }
            }
                break;
            case 3:
                return 45;
                break;
            default:
                return 0;
                break;
        }
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.menuType == AssetDesc && indexPath.row == 3) {
        if (AccessToken) {
            DMCreditDetailController *creditDetailVC = [[DMCreditDetailController alloc] init];
            creditDetailVC.guarantyStyle = self.tenderModel.guarantyStyle;
            creditDetailVC.loanId = self.tenderModel.loanId;
            creditDetailVC.title = self.tenderModel.title;
            [self.navigationController pushViewController:creditDetailVC animated:YES];
        }else{
            DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
            loginvc.current = YES;
            [self.navigationController pushViewController:loginvc animated:YES];
        }
    }
}


- (UIButton *)addButton{
    if (!_addButton) {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(10, 0, DMDeviceWidth-20, 65);
        [_addButton addTarget:self action:@selector(joinJustNow:) forControlEvents:UIControlEventTouchUpInside];
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

- (NSMutableArray *)authenArray{
    if (!_authenArray) {
        self.authenArray = [@[] mutableCopy];
    }
    return _authenArray;
}

- (NSArray *)listArray{
    if (!_listArray) {
        self.listArray = [@[] copy];
    }
    return _listArray;
}

- (void)joinJustNow:(UIButton *)button{
    if (AccessToken) {
        DMScatterConfirmBuyVC *confirmBuy = [[DMScatterConfirmBuyVC alloc] init];
        confirmBuy.scafferModel = self.listModel;
        confirmBuy.assetId = self.listModel.storeId;
        confirmBuy.guarantyStyle = self.tenderModel.guarantyStyle;
        confirmBuy.ToBuyStyle = buyStyleOfScafferCredit;
        [self.navigationController pushViewController:confirmBuy animated:YES];
    }else{
        DMLoginViewController *loginvc=[[DMLoginViewController alloc] init];
        loginvc.current = YES;
        [self.navigationController pushViewController:loginvc animated:YES];
    }
}

- (CGFloat )getheight{
    NSString *str = @"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n等额本息：在还款期内，每月偿还同等数额的借款（包括本金和利息）计息日起每隔一个月，返回当月的本金和利息。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元";
    CGRect rect = [str boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];

    return rect.size.height + 36;
}

- (NSDictionary *)setLabelAttribute{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 4;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:FONT_Regular(12)};
    return dic;
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

@end
