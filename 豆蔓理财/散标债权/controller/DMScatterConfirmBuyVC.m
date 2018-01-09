//
//  DMScatterConfirmBuyVC.m
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScatterConfirmBuyVC.h"
#import "DMScatterBuyCell.h"
#import "DMScafferBuyModel.h"
#import "DMScafferCreditManager.h"
#import "GZHomePageRequestManager.h"
#import "DMOpenPopUpView.h"
#import "DMSettingManager.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "DMCodeViewController.h"
#import "GZCouponsViewController.h"
#import "DMAmountInfoView.h"
#import "GZDistributionTargetViewController.h"
#import "GZInvestSignReminderView.h"

#import "DMHomeListModel.h"
@interface DMScatterConfirmBuyVC ()<UITableViewDelegate,UITableViewDataSource,OpenPopUpDelegate,LJQCouponCellDelegate,GZInvestSignSkipDelegate>
{
    NSString *couponID; //优惠券ID
    NSString *accountBalance; //账户余额
    NSString *confirmBuyAmount; //确认购买金额
    NSString *assetBuyRecordId; //购买记录id
    NSString *monthlyBilling; //本金和利息
    NSString *couponRateValue; //优惠券加息利率
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *couponBtn;
@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, strong)UILabel *rateLabel;//利率
@property (nonatomic, strong)UILabel *earnLabel;//收益

@property (nonatomic, strong)DMScafferBuyModel *buyModel;

@property (nonatomic, copy)NSString *balanceAmount; //可用余额
@end

static NSString *const scatterBuyIdentifier = @"DMScatterBuyCell";
@implementation DMScatterConfirmBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认购买";
    accountBalance = @"";
    self.balanceAmount = @"可用余额：--";
    couponRateValue = @"0"; //默认为0
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenkeyBoardEvent)];
    [self.tableView addGestureRecognizer:tapEvent];

    [self prepareForCouponList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareForUserAvailableAmount];
    
}


- (void)hiddenkeyBoardEvent {
    [self.tableView endEditing:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
        [_tableView registerClass:[DMScatterBuyCell class] forCellReuseIdentifier:scatterBuyIdentifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"scatterbuysystem"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = UIColorFromRGB(0xf3f3f3);
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self createScatterFootView];
    }
    return _tableView;
}

- (UIView *)createScatterFootView {
    UIImage *image = [UIImage imageNamed:@"confirmToNotBuyBuy"];
    CGFloat number = iPhone5 ? 60 : 140;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, DMDeviceHeight - 160)];
    view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
    [view addSubview:self.rateLabel];
    [view addSubview:self.earnLabel];
    
    self.confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.confirmButton.frame = CGRectMake((SCREENWIDTH - image.size.width) / 2, number, image.size.width, image.size.height);
    [self.confirmButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [self.confirmButton setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [self.confirmButton addTarget: self action:@selector(confirmBuyAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.confirmButton.userInteractionEnabled = NO;
    [view addSubview:self.confirmButton];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, 0, 0, 0) labelColor:UIColorFromRGB(0xadadad) textAlignment:(NSTextAlignmentLeft) textFont:12];
    label.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"点击'确认购买'即代表您已了解《风险提示函》以及《咨询与管理协议》"];
    
    label.attributedText = [self returnAttributeWithString:string color:UIColorFromRGB(0x00c79f) arrString:@[@"解",@"及"] length:@[@"7",@"9"]];
    
    CGFloat height = [self returenLabelHeight:string size:CGSizeMake(DMDeviceWidth - 100, 60) fontsize:12 isWidth:NO];
    __weak typeof(self) weakSelf = self;
    label.enabledTapEffect = NO;
    [label DM_addAttributeTapActionWithStrings:@[@"《风险提示函》",@"《咨询与管理协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        if ([string isEqualToString:@"《风险提示函》"]) {
            [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/cjfxtsh?fromapp=1"] Title:@"风险提示函" Type:@""];
        }else if([string isEqualToString:@"《咨询与管理协议》"]){
            
            if ([self.guarantyStyle isEqualToString:@"CarInsurance"]) {
                
                [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/cxzxgl?fromapp=1"] Title:@"咨询与管理协议" Type:@""];
            }else {
                
                [weakSelf getWebViewWithUrl:[NSString stringWithFormat:@"%@%@",weburl,@"mzc/help/protocol/grzxgl?fromapp=1"] Title:@"咨询与管理协议" Type:@""];
            }
        }
    }];
    
    [label setFrame:CGRectMake(50, LJQ_VIEW_MaxY(self.confirmButton) + 15, DMDeviceWidth - 100, height)];
    [view addSubview:label];
    
    UILabel *promptLabel = [UILabel createLabelFrame:CGRectMake(0, LJQ_VIEW_Height(view) - 90, DMDeviceWidth, 10) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:10.f];
    promptLabel.text = @"市场有风险，投资需谨慎";
    [view addSubview:promptLabel];
    
    return view;
}

//确认购买
- (void)confirmBuyAction:(UIButton *)sender {
    
    [self.tableView endEditing:YES];
    if ([confirmBuyAmount isEqualToString:@"提示"]) {
        return;
    }
    
    if ([confirmBuyAmount doubleValue] != 0) {
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            if ([self.scafferModel.surplusAmount doubleValue] >= 100 && [confirmBuyAmount doubleValue] < 100) {
                //债权余额>=100,输入金额<100
                DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"100元起投，请重新输入" flag:1];
                [infoView showView];
            }else
                if ([confirmBuyAmount doubleValue] > [accountBalance doubleValue]) {
                    //输入金额>账户余额
                    DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"账户余额不足，请先充值" flag:2];
                    infoView.jumpToAgreement = ^(NSInteger number) {
                        [self userIsRealNameRequest:1];
                    };
                    [infoView showView];
                }else
                    if ([self.scafferModel.surplusAmount doubleValue] < 100 && [confirmBuyAmount doubleValue] < [self.scafferModel.surplusAmount doubleValue]) {
                        //输入金额<债权余额<100
                        NSString *string = [NSString stringWithFormat:@"债权余额%@元，请输入剩余全部金额或点击‘全投’",self.scafferModel.surplusAmount];
                        DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:string flag:1];
                        [infoView showView];
                    }else {
                        
                        [self userIsRealNameRequest:2];
                    }
        }else {
            if ([confirmBuyAmount doubleValue] < 100) {
                DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"100元起投，请重新输入" flag:1];
                [infoView showView];
            }else
                if ([confirmBuyAmount doubleValue] > [accountBalance doubleValue]) {
                    //输入金额>账户余额
                    DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"账户余额不足，请先充值" flag:2];
                    infoView.jumpToAgreement = ^(NSInteger number) {
                        [self userIsRealNameRequest:1];
                    };
                    [infoView showView];
                }else {
                    [self userIsRealNameRequest:2];
                }
        }
    }else {
        ShowMessage(@"请输入认购金额");
    }
    
}

#pragma tableViewDelegate && dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 71;
    }else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DMScatterBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:scatterBuyIdentifier forIndexPath:indexPath];
        cell.AvailableBalance = accountBalance;
        if (self.ToBuyStyle == buyStyleOfProduct) {
            cell.isOrHidden = YES;
        }else {
            cell.isOrHidden = NO;
        }
        //全投
        cell.scatterAllBuy = ^(NSString *balanceStr) {
            if ([balanceStr isEqualToString:@"账户余额不足，请先充值"]) {
                confirmBuyAmount = @"0";
                DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:balanceStr flag:2];
                infoView.jumpToAgreement = ^(NSInteger number) {
                    if (number == 2) {
                        [self userIsRealNameRequest:1];
                    }
                };
                [infoView showView];
                [self calculateExpectedEarningsWithInputString:@"0"];
            }else
               if ([balanceStr isEqualToString:@"提示"]) {
                    confirmBuyAmount = @"提示";
                   DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"请输入100的整数倍金额" flag:1];
                   [infoView showView];
                   [self calculateExpectedEarningsWithInputString:@"0"];
                }else{
                [self.confirmButton setImage:[UIImage imageNamed:@"confirmToBuyBuy"] forState:(UIControlStateNormal)];
                self.confirmButton.userInteractionEnabled = YES;
                [self calculateExpectedEarningsWithInputString:balanceStr];
                confirmBuyAmount = balanceStr;
            }
        };
        
        //textField
        cell.changeStringBlock = ^(NSString *inputString) {
            [self calculateExpectedEarningsWithInputString:inputString];
            confirmBuyAmount = inputString;
            if (inputString.length != 0) {
                [self.confirmButton setImage:[UIImage imageNamed:@"confirmToBuyBuy"] forState:(UIControlStateNormal)];
                self.confirmButton.userInteractionEnabled = YES;
            }else {
                [self.confirmButton setImage:[UIImage imageNamed:@"confirmToNotBuyBuy"] forState:(UIControlStateNormal)];
                self.confirmButton.userInteractionEnabled = NO;
            }
        };
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            cell.listModel = self.scafferModel;
        }else {
            cell.productModel = self.productModel;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scatterbuysystem" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = UIColorFromRGB(0x878787);
        if (indexPath.row == 1) {
            NSRange range = [self.balanceAmount rangeOfString:@"："];
            cell.textLabel.attributedText = [self returnAttributeWithString:self.balanceAmount range:range length:self.balanceAmount.length - range.location - 1 color:UIColorFromRGB(0xff7255)];
            cell.accessoryView = [self createCustomView];
        }else {
            cell.textLabel.text = @"使用卡券";
            cell.accessoryView = self.couponBtn;
        }
        return cell;
    }
}

- (UIView *)createCustomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 16)];
    [button setTitle:@"充值" forState:(UIControlStateNormal)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = FONT_Regular(14.f);
    [button setTitleColor:UIColorFromRGB(0xff7255) forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(scatterTopUp:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];
    return view;
}

- (void)getWebViewWithUrl:(NSString *) url Title:(NSString *)title Type:(NSString *)type{
    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = title;
    chargeVC.type = type;
    chargeVC.webUrl = url;
    [self.navigationController pushViewController:chargeVC animated:YES];
}

//充值
- (void)scatterTopUp:(UIButton *)sender {
    [self userIsRealNameRequest:1];
}

#pragma 共用
- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, length)];
    return attribute;
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string color:(UIColor *)color arrString:(NSArray<NSString *>*)arrStr length:(NSArray *)lengthArr{
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    [attribute addAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, string.length - 1)];
    for (int i = 0; i < arrStr.count; i++) {
        NSRange range = [string rangeOfString:arrStr[i]];
        [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, [lengthArr[i] integerValue])];
    }
    
    return attribute;
}

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraph} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

- (void)hideHUD:(MBProgressHUD *)progress {
    __block MBProgressHUD *progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}

//格式化金额数目
- (NSString *)getFormattedAmountOfNumberWithString:(NSString *)str {
    
    NSString *strWithTwoDecimals = [NSString stringWithFormat:@"%.2f",str.doubleValue];
    
    NSArray *separatedStrs = [strWithTwoDecimals componentsSeparatedByString:@"."];
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[separatedStrs[0] length];i++) {
        
        [mutableStr insertString:[separatedStrs[0] substringWithRange:NSMakeRange([separatedStrs[0] length]-i, 1)] atIndex:0];
        
        if(i%3==0 && i != [separatedStrs[0] length]) {
            [mutableStr insertString:@"," atIndex:0];
        }
    }
    
    [mutableStr appendString:@"."];
    [mutableStr appendString:separatedStrs[1]];
    
    return mutableStr;
}

//预计收益计算
- (void)calculateExpectedEarningsWithInputString:(NSString *)string {
    /*
     月结收益：认购金额 * 利率 / 100 / 12 * 期限
     
     月结本息：
     按月付息到期还本：认购金额 * 利率 / 100 / 12
     
     等额本息：贷款本金×[月利率×（1+月利率）^还款月数]÷[（1+月利率）^还款月数—1]
     */
    //产品利率
    double interestRate;
    
    if (self.ToBuyStyle == buyStyleOfScafferCredit) {
        interestRate = [self.scafferModel.rate doubleValue] + [self.scafferModel.interestRate doubleValue] + [couponRateValue doubleValue];
    }else {
        interestRate = [self.productModel.assetRate doubleValue] + [self.productModel.assetInterestRate doubleValue] + [couponRateValue doubleValue];
    }
    //产品期限
    double productDuration;
    if (self.ToBuyStyle == buyStyleOfScafferCredit) {
        productDuration = [self.scafferModel.months doubleValue];
    }else {
        productDuration = [self.productModel.productCycle doubleValue];
    }
    if([self.assetId isEqualToString:@""]) {
        
        NSString *string = [NSString stringWithFormat:@"预计收益：%@元",[self getFormattedAmountOfNumberWithString:@"0.0"]];
        NSRange range = [string rangeOfString:@"："];
        self.earnLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 2 color:UIColorFromRGB(0xff7255)];
    }else {
        
        double baseAmount = string.doubleValue;
        NSString *method;
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            method = self.scafferModel.method;
        }else {
            method = self.productModel.assetRepaymentMethod;
        }
        if([method isEqualToString:@"MonthlyInterest"]) {//按月付息到期还本
            
            NSString *earning = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12*productDuration]];
            NSString *string = [NSString stringWithFormat:@"预计收益：%@元",earning];
            NSRange range = [string rangeOfString:@"："];
            self.earnLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 2 color:UIColorFromRGB(0xff7255)];
            
            monthlyBilling = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",baseAmount*interestRate/100/12]];
        }else {//等额本息
            
            double monthlyInterest = interestRate/100/12;
            
            double monthlyPayment = (baseAmount*monthlyInterest*pow(1+monthlyInterest, productDuration))/(pow(1+monthlyInterest, productDuration)-1);
            
            NSString *earning = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment*productDuration-baseAmount]];
            NSString *string = [NSString stringWithFormat:@"预计收益：%@元",earning];
            NSRange range = [string rangeOfString:@"："];
            self.earnLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 2 color:UIColorFromRGB(0xff7255)];
            
            monthlyBilling = [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment]];

            //应收利息
//            [self getFormattedAmountOfNumberWithString:[NSString stringWithFormat:@"%.2f",monthlyPayment*productDuration-baseAmount]];
        }
    }
}

#pragma networkRequest
//散标认购
- (void)scafferCreditToBuyWithAssetId:(NSString *)assetId loanId:(NSString *)loanId investAmount:(NSString *)investAmount couponId:(NSString *)couponId {
    DMScafferCreditManager *manager = [DMScafferCreditManager scafferDefault];
    [manager DMScafferCreditToBuyWithAssetId:assetId loanId:loanId investAmount:investAmount couponId:couponId showView:self.view successBlock:^(DMScafferBuyModel *buyModel) {
        self.buyModel = buyModel;
        if ([buyModel.bidResult isEqualToString:@"SUCCESSFUL"]) {
            //购买成功
            DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:@"认购成功，满标后开始计息" flag:3];
            infoView.jumpToAgreement = ^(NSInteger number) {
                if (number == 3) {
                    //资产配标
                    GZDistributionTargetViewController *dtvc = [[GZDistributionTargetViewController alloc]init];
                    dtvc.assetBuyRecordId = buyModel.storeId;
                    if (self.ToBuyStyle == buyStyleOfScafferCredit) {
                        dtvc.assetId = self.scafferModel.storeId;
                    }else {
                        dtvc.assetId = self.productModel.assetId;
                    }
                    
                    dtvc.repayAmount = monthlyBilling;
                    dtvc.hidesBottomBarWhenPushed = YES;
                    dtvc.navigationItem.title = @"资产配标";
                    [self.navigationController pushViewController:dtvc animated:NO];
                }
            };
            [infoView showView];
        }
        
    } faild:^(NSString *message) {
        DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:message flag:1];
        [infoView showView];
    }];
}

/** 可用余额 */
- (void)prepareForUserAvailableAmount {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[GZHomePageRequestManager defaultManager] requestForHomePageUserAvailableAmountWithUserId:USER_ID accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSString *availableAmount) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(result){
            self.balanceAmount = [NSString stringWithFormat:@"账户余额：%@元",[self getFormattedAmountOfNumberWithString:availableAmount]];
            accountBalance = [NSString stringWithFormat:@"%@",availableAmount];
        }else {
            ShowMessage(message);
            self.balanceAmount = @"账户余额：--";
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *err) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/** 可用优惠券 */
- (void)prepareForCouponList {
    
    NSString *assetID;
    if (self.ToBuyStyle == buyStyleOfScafferCredit) {
        assetID = self.scafferModel.storeId;
    }else {
        assetID = self.productModel.assetId;
    }
    [[GZHomePageRequestManager defaultManager] requestForHomePageCouponListWithUserId:USER_ID accessToken:AccessToken assetId:assetID successBlock:^(BOOL result, NSString *message, NSArray<GZCouponModel *> *couponList) {
        
        if(result){
            if (couponList.count != 0) {
                [self.couponBtn setEnabled:YES];
                NSString *string = [NSString stringWithFormat:@"%ld张可用>",(unsigned long)couponList.count];
                [self.couponBtn setTitle:string forState:(UIControlStateNormal)];
                [self.couponBtn setTitleColor:UIColorFromRGB(0xff7255) forState:(UIControlStateNormal)];
            }else {
                [self.couponBtn setEnabled:NO];
                [self.couponBtn setTitle:@"暂无卡券" forState:(UIControlStateNormal)];
                [self.couponBtn setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
            }
            
        }else {
            ShowMessage(message);
            [self.couponBtn setEnabled:NO];
            [self.couponBtn setTitle:@"暂无卡券" forState:(UIControlStateNormal)];
            [self.couponBtn setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *err) {
        
    }];
}

/** 检查自动签约状态 */
- (void)checkStatusOfAutoSign {
    
    [[GZHomePageRequestManager defaultManager] requestStatusOfAutoSignWithUserId:USER_ID successBlock:^(NSString *status, NSString *msg) {
        
        if([status isEqualToString:@"0"]) {
            //已签约,检查余额
            if (self.ToBuyStyle == buyStyleOfProduct) {
                [self scafferCreditToBuyWithAssetId:self.productModel.assetId loanId:@"" investAmount:confirmBuyAmount couponId:couponID];
            }else {
                [self scafferCreditToBuyWithAssetId:self.scafferModel.storeId loanId:self.scafferModel.loanId investAmount:confirmBuyAmount couponId:couponID];
            }
            
        }else if([status isEqualToString:@"1"]) {
            //托管开关未打开
            //[self loadAutomaticalInvestSignReminder];
            ShowMessage(msg);
            
        }else if([status isEqualToString:@"2"]){
            //未签约,弹出提示框
            [self loadAutomaticalInvestSignReminder];
        }
        
    } failureBlock:^(NSError *err,NSString *msg) {
        
        if (err) {
            ShowMessage(@"网络请求失败, 请检查您的网络");
        }
        
        if (msg) {
            ShowMessage(msg);
        }
    }];
}


//银行卡信息
- (void)MineBankCardInfoRequest:(NSInteger)index {
    DMSettingManager *settingManager = [DMSettingManager RequestManager];
    [settingManager requestForTieOnCardSuccess:^(BOOL sure) {
        
        if (sure == YES) {
            //帮过卡
            if (index == 1) {
                //充值
                DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
                chargeVC.title = @"充值";
                chargeVC.type = @"charge";
                chargeVC.webUrl = [[DMWebUrlManager manager] getChargeUrl];
                [self.navigationController pushViewController:chargeVC animated:YES];
            }
            if (index == 2) {
                //自动签约
                [self checkStatusOfAutoSign];
            }
        }else {
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:YES];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } Faild:^() {
        
    }];
}

//是否实名认证
- (void)userIsRealNameRequest:(NSInteger)index {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[LJQMineRequestManager RequestManager] LJQIsRealNamesuccessblock:^(NSString *result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([result isEqualToString:@"true"]) {
            //实名认证通过,判断是否绑卡
            [self MineBankCardInfoRequest:index];
        }else {
            //未实名认证//跳转实名认证页面
            DMOpenPopUpView *open = [[DMOpenPopUpView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight) HasBandCard:NO];
            open.delegate = self;
            [self.navigationController.tabBarController.view addSubview:open];
        }
    } faild:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)loadAutomaticalInvestSignReminder {
    
    [GZInvestSignReminderView showPopviewToView:self.view];
    [GZInvestSignReminderView setDelegateOfSingletonWith:self];
}

#pragma mark - GZInvestSignSkipDelegate
//自动投标
- (void)skipToDetailOfInvestSign {
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.title = @"自动投标签约";
    webVC.webUrl = [[DMWebUrlManager manager] getAutoMakeABid];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)skipToAutoSignAuthProtocol {
    
    DMWebViewController *webVC = [[DMWebViewController alloc] init];
    webVC.webUrl = [[DMWebUrlManager manager] getAutoSignAuthProtocolUrl];
    webVC.navigationItem.title = @"自动投标授权";
    
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma OpenPopUpDelegate
//开户页面
- (void) openpopupClick {
    DMCodeViewController *code = [[DMCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
}

#pragma mark - LJQCouponCellDelegate
- (void)updateUserInterfaceWithCouponModel:(LJQCouponsModel *)model {
    
    if([model.type isEqualToString:@"REBATE"]) {
        
        NSString *searchCardAttrStr = [NSString stringWithFormat:@"%@返%@",model.minimumInvest,model.parValue];
        [self.couponBtn setTitle:searchCardAttrStr forState:(UIControlStateNormal)];
        [self.couponBtn setTitleColor:UIColorFromRGB(0xff7255) forState:(UIControlStateNormal)];
        
        if(model.couponId) {
            couponID = model.couponId;
        }
        
    }else if([model.type isEqualToString:@"INTEREST"]){
        
        NSString *searchCardAttrStr = [NSString stringWithFormat:@"加息%@%%",model.parValue];
        [self.couponBtn setTitle:searchCardAttrStr forState:(UIControlStateNormal)];
        [self.couponBtn setTitleColor:UIColorFromRGB(0xff7255) forState:(UIControlStateNormal)];
        //取值带入
        couponRateValue = model.parValue;
        if(model.couponId) {
            couponID = model.couponId;
        }
        
        NSString *string;
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            string = [NSString stringWithFormat:@"年化利率：%.f%%",([self.scafferModel.rate doubleValue] + [self.scafferModel.interestRate doubleValue] + [model.parValue doubleValue]) ];
        }else {
            string = [NSString stringWithFormat:@"年化利率：%.f%%",([self.productModel.assetRate doubleValue] + [self.productModel.assetInterestRate doubleValue] + [model.parValue doubleValue]) ];
        }
        NSRange range = [string rangeOfString:@"："];
        self.rateLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0xff7255)];
        
        [self calculateExpectedEarningsWithInputString:confirmBuyAmount];
    }
}

- (void)cancelCouponSelection {
    
    //优惠券id清空
    couponID = @"";
    //重新获取优惠券个数
    [self prepareForCouponList];
}

#pragma buttonTouchEvent
//跳转优惠券
- (void)jumpToUseingCoupon {
    if(![self.assetId isEqualToString:@""]) {
        
        GZCouponsViewController *cvc = [[GZCouponsViewController alloc]init];
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            cvc.assetId = self.scafferModel.storeId;
        }else {
            cvc.assetId = self.productModel.assetId;
        }
        cvc.delegate = self;
        cvc.navigationItem.title = @"选择卡券";
        [self.navigationController pushViewController:cvc animated:YES];
    }

}

#pragma lazyLoading
//优惠券
- (UIButton *)couponBtn {
    if (!_couponBtn) {
        _couponBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_couponBtn setFrame:CGRectMake(0, 0, 70, 16)];
        [_couponBtn setTitle:@"暂无卡券" forState:(UIControlStateNormal)];
        [_couponBtn setTitleColor:UIColorFromRGB(0x878787) forState:(UIControlStateNormal)];
        _couponBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _couponBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _couponBtn.enabled = NO;
        [_couponBtn addTarget:self action:@selector(jumpToUseingCoupon) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _couponBtn;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(0, iPhone5 ? 30 : 110, DMDeviceWidth / 2 - 20, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentRight) textFont:12.f];
        NSString *string;
        if (self.ToBuyStyle == buyStyleOfScafferCredit) {
            string = [NSString stringWithFormat:@"年化利率：%.f%%",([self.scafferModel.rate doubleValue] + [self.scafferModel.interestRate doubleValue]) ];
        }else {
            string = [NSString stringWithFormat:@"年化利率：%.f%%",([self.productModel.assetRate doubleValue] + [self.productModel.assetInterestRate doubleValue]) ];
        }
        NSRange range = [string rangeOfString:@"："];
        _rateLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0xff7255)];
    }
    return _rateLabel;
}

- (UILabel *)earnLabel {
    if (!_earnLabel) {
        _earnLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2 + 20, iPhone5 ? 30 : 110 , DMDeviceWidth / 2 - 20, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        NSString *string = @"预计收益：--元";
        NSRange range = [string rangeOfString:@"："];
        _earnLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 2 color:UIColorFromRGB(0xff7255)];
    }
    return _earnLabel;
}


@end
