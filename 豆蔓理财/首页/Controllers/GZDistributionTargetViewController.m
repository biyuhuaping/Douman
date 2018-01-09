//
//  GZDistributionTargetViewController.m
//  豆蔓理财
//
//  Created by armada on 2016/12/10.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZDistributionTargetViewController.h"

#import "GZDistributionLoanListModel.h"
#import "DMWebUrlManager.h"

#import "GZCircleProgressView.h"
#import "GZDistributionTargetTableViewCell.h"

#import "DMCurrentClaimsViewController.h"
#import "DMCreditDetailController.h"
#import "DMWebViewController.h"

@interface GZDistributionTargetViewController ()<UITableViewDelegate,UITableViewDataSource,GZCircleProgressViewPopViewProtocol>

{
    UIView *popView;
    
    NSInteger count;
}

@property(nonatomic,strong) UIImageView *sucessfulPurchaseRemainderBlock;

@property(nonatomic,strong) GZCircleProgressView *circleProgressView;

@property(nonatomic,strong) UILabel *amountOfPurchaseLabel;

@property(nonatomic,strong) UILabel *profitExplainationLabel;

@property(nonatomic,strong) UILabel *expectedRevenueLabel;

@property(nonatomic,strong) UIView *tableHeaderView;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray<GZDistributionLoanListModel *> *dataSource;

@property(nonatomic,copy) NSString *investAmount;

@end

@implementation GZDistributionTargetViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareForData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.circleProgressView removeLabelCountTimer];
}

#pragma mark - Network Request

- (void)prepareForData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GZHomePageRequestManager defaultManager] requestForHomePageLoanInfoWithAssetBuyId:self.assetBuyRecordId accessToken:AccessToken successBlock:^(BOOL result, NSString *message, NSNumber *paymentInterest, NSNumber *loanNumber, NSArray<GZDistributionLoanListModel *> *loanList, NSString *repaymentMethod, NSString *investAmount) {
        
        if(result) {
            count = loanList.count;
            
            self.circleProgressView.progress = 1.0;
            
            self.investAmount = investAmount;
            self.amountOfPurchaseLabel.text = [NSString stringWithFormat:@"成功购买%@元",investAmount];
            
            self.profitExplainationLabel.text = @"满标生成合同后开始计息";
            
            if([repaymentMethod isEqualToString:@"EqualInstallment"]) {
                [self setExpectedRevenueWithNumber:self.repayAmount andType:@"等额本息"];
            }else if([repaymentMethod isEqualToString:@"MonthlyInterest"]){
                [self setExpectedRevenueWithNumber: self.repayAmount andType:@"按月付息"];
            }else {
                [self setExpectedRevenueWithNumber: self.repayAmount andType:@""];
            }
            
            [self.dataSource addObjectsFromArray:loanList];
            [self.tableView reloadData];
            
        }else {
            ShowMessage(message);
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failureBlock:^(NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Lazy Loading
- (UIImageView *)sucessfulPurchaseRemainderBlock {
    
    if(!_sucessfulPurchaseRemainderBlock) {
        _sucessfulPurchaseRemainderBlock = [[UIImageView alloc]init];
        _sucessfulPurchaseRemainderBlock.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_sucessfulPurchaseRemainderBlock];
        [_sucessfulPurchaseRemainderBlock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(@120);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = MainF5;
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(120);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(@8);
            
        }];
        
    }
    return _sucessfulPurchaseRemainderBlock;
}

- (UILabel *)amountOfPurchaseLabel {
    
    if(!_amountOfPurchaseLabel) {
        _amountOfPurchaseLabel = [[UILabel alloc]init];
        [self.sucessfulPurchaseRemainderBlock addSubview:_amountOfPurchaseLabel];
        [_amountOfPurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sucessfulPurchaseRemainderBlock).offset(22);
            make.centerX.equalTo(self.sucessfulPurchaseRemainderBlock);
            make.height.mas_equalTo(@22);
        }];
        _amountOfPurchaseLabel.textAlignment = NSTextAlignmentCenter;
        _amountOfPurchaseLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        _amountOfPurchaseLabel.textColor = MainRed;
        
        UIImageView *sucessfulImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购买成功icon"]];
        [self.sucessfulPurchaseRemainderBlock addSubview:sucessfulImgView];
        [sucessfulImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_amountOfPurchaseLabel);
            make.right.equalTo(_amountOfPurchaseLabel.mas_left).offset(-6);
            make.width.mas_equalTo(@18);
            make.height.mas_equalTo(@18);
        }];
    }
    return _amountOfPurchaseLabel;
}

- (UILabel *)profitExplainationLabel {
    
    if(!_profitExplainationLabel) {
        _profitExplainationLabel = [[UILabel alloc]init];
        [self.sucessfulPurchaseRemainderBlock addSubview:_profitExplainationLabel];
        [_profitExplainationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.expectedRevenueLabel.mas_top).offset(-5);
            make.centerX.equalTo(self.sucessfulPurchaseRemainderBlock);
            make.width.equalTo(self.sucessfulPurchaseRemainderBlock);
            make.height.mas_equalTo(@15);
        }];
        
        [_profitExplainationLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
        [_profitExplainationLabel setTextAlignment:NSTextAlignmentCenter];
        [_profitExplainationLabel setTextColor:DarkGray];
    }
    return _profitExplainationLabel;
}

- (UILabel *)expectedRevenueLabel {
    
    if(!_expectedRevenueLabel) {
        _expectedRevenueLabel = [[UILabel alloc]init];
        [self.sucessfulPurchaseRemainderBlock addSubview:_expectedRevenueLabel];
        [_expectedRevenueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.sucessfulPurchaseRemainderBlock);
            make.bottom.equalTo(self.sucessfulPurchaseRemainderBlock).offset(-20);
            make.width.equalTo(self.sucessfulPurchaseRemainderBlock);
            make.height.mas_equalTo(@15);
        }];
        
        [_expectedRevenueLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _expectedRevenueLabel;
}

- (GZCircleProgressView *)circleProgressView {
    
    if(!_circleProgressView) {
        
        if(iPhone5) {
            _circleProgressView = [[GZCircleProgressView alloc]
                                   initWithFrame:CGRectMake(0, 0, 200, 200)
                                   circleRadius:70
                                   circleLineWidth:10
                                   titles:@[[NSString stringWithFormat:@"匹配债权%ld个",count],@"分散投标"]
                                   values:@[@"",@"降低风险"]
                                   dotColors:@[UIColorFromRGB(0xff7255),UIColorFromRGB(0xffb16b)]];
        }else {
            
            _circleProgressView = [[GZCircleProgressView alloc]
                                   initWithFrame:CGRectMake(0, 0, 250, 250)
                                   circleRadius:85
                                   circleLineWidth:12
                                   titles:@[[NSString stringWithFormat:@"匹配债权%ld个",count],@"分散投标"]
                                   values:@[@"",@"降低风险"]
                                   dotColors:@[UIColorFromRGB(0xff7255),UIColorFromRGB(0xffb16b)]];
        }
        [self.view addSubview:_circleProgressView];
        
        [_circleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sucessfulPurchaseRemainderBlock.mas_bottom).offset(15);
            make.centerX.equalTo(self.view);
            if(iPhone5) {
                make.height.mas_equalTo(@200);
                make.width.mas_equalTo(@200);
            }else {
                make.height.mas_equalTo(@250);
                make.width.mas_equalTo(@250);
            }
        }];
        _circleProgressView.delegate = self;
    }
    return _circleProgressView;
}

- (UIView *)tableHeaderView {
    
    if(!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc]init];
        [self.view addSubview:_tableHeaderView];
        [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.circleProgressView.mas_bottom);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(DMDeviceWidth);
            make.height.mas_equalTo(50);
        }];
        
        UILabel *orderTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:orderTitleLabel];
        [orderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView).offset(20);
            make.centerY.equalTo(_tableHeaderView);
            make.height.mas_equalTo(@20);
        }];
        
        [orderTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [orderTitleLabel setTextColor:MainRed];
        [orderTitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
        [orderTitleLabel setText:@"序号"];
        
        UILabel *debtNameTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:debtNameTitleLabel];
        [debtNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.equalTo(orderTitleLabel.mas_right).offset(45);
            make.centerX.equalTo(_tableHeaderView);
            make.centerY.equalTo(_tableHeaderView);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@180);
        }];
        [debtNameTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [debtNameTitleLabel setTextColor:MainRed];
        [debtNameTitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
        [debtNameTitleLabel setText:@"债权名称"];
        
        UILabel *sumOfDebtTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:sumOfDebtTitleLabel];
        [sumOfDebtTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeaderView.mas_right).offset(-30);
            make.centerY.equalTo(_tableHeaderView);
            make.height.mas_equalTo(@20);
        }];
        [sumOfDebtTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [sumOfDebtTitleLabel setTextColor:MainRed];
        [sumOfDebtTitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
        [sumOfDebtTitleLabel setText:@"债权金额"];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableHeaderView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        [_tableView registerClass:[GZDistributionTargetTableViewCell class] forCellReuseIdentifier:@"DistributionTargetCell"];
        _tableView.allowsSelection = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    
    if(!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GZDistributionTargetTableViewCell *cell = [GZDistributionTargetTableViewCell cellWithTableView:tableView];
    
    GZDistributionLoanListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setOrderLabelWithNum:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
    [cell setCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GZDistributionLoanListModel *model = [self.dataSource objectAtIndex:indexPath.row];
    DMCreditDetailController *cdc =  [[DMCreditDetailController alloc]init];
    cdc.guarantyStyle = model.guarantyStyle;
    cdc.loanId = model.loanId;
    [self.navigationController pushViewController:cdc animated:YES];
}

#pragma mark - GZCircleProgressViewPopViewProtocol

- (void)allMasksFadeAnimation {
    
    for(GZDistributionTargetTableViewCell *cell in _tableView.visibleCells) {
        
        [cell maskFadeAnimation];
    }
    
    [self performSelector:@selector(popRemainderView) withObject:nil afterDelay:2.f];
}

- (void)popRemainderView {
    
    //tableView 可选
    self.tableView.allowsSelection = YES;
    
    popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64)];
    popView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UITapGestureRecognizer *popTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClick)];
    [popView addGestureRecognizer:popTap];
    [self.view addSubview:popView];
    
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;

    [popView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(@287);
        make.height.mas_equalTo(@185);
    }];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = DarkGray;
    lable.text = @"系统配标完毕，等待满标计息...";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = SYSTEMFONT(14);
    [backImageView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView).offset(40);
        make.left.equalTo(backImageView);
        make.right.equalTo(backImageView);
        make.height.mas_equalTo(@15);
    }];
    
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *deadlineDate = [dateFormatter dateFromString:@"2017-6-14 23:59:59"];
    
    if ([deadlineDate timeIntervalSinceNow] >= 0) {
        
        int luckyDrawNum = self.investAmount.integerValue/5000;
        
        if(luckyDrawNum>0){
            
            UILabel *wishingCardLabel = [[UILabel alloc] init];
            [backImageView addSubview:wishingCardLabel];
            [wishingCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backImageView).offset(60);
                make.centerX.equalTo(backImageView);
                make.height.mas_equalTo(@20);
            }];
            [wishingCardLabel setTextAlignment:NSTextAlignmentCenter];
            [wishingCardLabel setTextColor:DarkGray];
            [wishingCardLabel setFont:[UIFont systemFontOfSize:15]];
            [wishingCardLabel setText:[NSString stringWithFormat:@"您已经获得%ld次抽奖机会，立即抽奖",self.investAmount.integerValue/5000]];
            
            UIButton *searchWishingCard = [UIButton buttonWithType:UIButtonTypeCustom];
            [backImageView addSubview:searchWishingCard];
            [searchWishingCard mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(backImageView);
                make.width.mas_equalTo(@65);
                make.height.mas_equalTo(@19);
            }];
            [searchWishingCard setBackgroundImage:[UIImage imageNamed:@"点击查看"] forState:UIControlStateNormal];
            [searchWishingCard setBackgroundImage:[UIImage imageNamed:@"点击查看"] forState:UIControlStateHighlighted];
            [searchWishingCard addTarget:self action:@selector(searchWishingCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIButton *searchProgressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImageView addSubview:searchProgressBtn];
    [searchProgressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView).offset(125);
        make.left.equalTo(backImageView).offset(36);
        make.width.mas_offset(@96);
        make.height.mas_offset(@31);
    }];
    [searchProgressBtn setBackgroundImage:[UIImage imageNamed:@"查看满标进度"] forState:UIControlStateNormal];
    [searchProgressBtn setBackgroundImage:[UIImage imageNamed:@"查看满标进度"] forState:UIControlStateHighlighted];
    [searchProgressBtn addTarget:self action:@selector(searchProgressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [searchProgressBtn setTitle:@"查看满标进度" forState:UIControlStateNormal];
    [searchProgressBtn setTitleColor:UIColorFromRGB(0xff7456) forState:UIControlStateNormal];
    searchProgressBtn.titleLabel.font = SYSTEMFONT(15);
    UIButton *continuePurchasingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImageView addSubview:continuePurchasingBtn];
    [continuePurchasingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView).offset(125);
        make.right.equalTo(backImageView).offset(-36);
        make.width.mas_offset(@96);
        make.height.mas_offset(@31);
    }];
    [continuePurchasingBtn setBackgroundImage:[UIImage imageNamed:@"继续购买"] forState:UIControlStateNormal];
    [continuePurchasingBtn setBackgroundImage:[UIImage imageNamed:@"继续购买"] forState:UIControlStateHighlighted];
    [continuePurchasingBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [continuePurchasingBtn setTitle:@"继续购买" forState:UIControlStateNormal];
    continuePurchasingBtn.titleLabel.font = SYSTEMFONT(15);
    [continuePurchasingBtn addTarget:self action:@selector(continuePurchasingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [popView addSubview:closeBtn];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(backImageView.mas_top).offset(10);
//        make.left.equalTo(backImageView.mas_right).offset(-15);
//        make.width.mas_equalTo(@18);
//        make.height.mas_equalTo(@18);
//    }];
//    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭icon-2"] forState:UIControlStateNormal];
//    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭icon-2"] forState:UIControlStateHighlighted];
//    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - click action

//查看许愿卡
- (void)searchWishingCardBtnClick {

    DMWebViewController *chargeVC = [[DMWebViewController alloc] init];
    chargeVC.title = @"";
    chargeVC.webUrl = [[DMWebUrlManager manager] getActivityUrl];
    [self.navigationController pushViewController:chargeVC animated:YES];
    
    [popView removeFromSuperview];
}
//查看筹标详情
- (void)searchProgressBtnClick {
    [popView removeFromSuperview];
    DMCurrentClaimsViewController *ccvc = [[DMCurrentClaimsViewController alloc]init];
    ccvc.assetId = self.assetId;
    [self.navigationController pushViewController:ccvc animated:YES];
}
//继续购买
- (void)continuePurchasingBtnClick {
    [popView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//关闭弹窗
- (void)closeBtnClick {
    [popView removeFromSuperview];
}
#pragma mark - helper functions
- (void)setExpectedRevenueWithNumber:(NSString *)number andType:(NSString *)type{
    
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc]initWithString:@"预期本月本息回款" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12],NSForegroundColorAttributeName:DarkGray}];
    
    [mutableAttString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",number] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:15],NSForegroundColorAttributeName:MainRed}]];
    
    [mutableAttString appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:13],NSForegroundColorAttributeName:MainRed}]];
    
    [mutableAttString appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@)",type] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12],NSForegroundColorAttributeName:MainRed}]];
    
    self.expectedRevenueLabel.attributedText = mutableAttString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
