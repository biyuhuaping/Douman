//
//  GZBenefitDetailViewController.m
//  豆蔓理财
//
//  Created by armada on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZBenefitDetailViewController.h"

@interface GZBenefitDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UILabel *expectedPurchasedAmountTitleLabel;
    
    UILabel *expectedBenefitTitleLabel;
    
    UILabel *monthlyWithdrawTitleLabel;
}

/** 预计认购金额 */
@property(nonatomic, strong) UILabel *expectedPurchasedAmountLabel;
/** 预计收益 */
@property(nonatomic, strong) UILabel *expectedBenefitLabel;
/** 月收本息 */
@property(nonatomic, strong) UILabel *monthlyWithdrawLabel;

/** 购买详情面板 */
@property(nonatomic, strong) UIImageView *benefitDashboardImgView;
/** 预计每月回款进度详情列表 */
@property(nonatomic, strong) UITableView *tableView;
/** 头视图 */
@property(nonatomic, strong) UIView *tableHeaderView;

/** 回到顶部按钮 */
@property(nonatomic, strong) UIButton *topAnchorBtn;
/** 到达底部按钮 */
@property(nonatomic, strong) UIButton *bottomAnchorBtn;

@end

@implementation GZBenefitDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.expectedPurchasedAmountLabel.attributedText = [self getFormattedSumStr:self.expectedPurchasedAmount];
    self.expectedBenefitLabel.attributedText = [self getFormattedSumStr:self.expectedBenefit];
    self.monthlyWithdrawLabel.attributedText = [self getFormattedSumStr:self.monthlyWithdraw];
    
    [self.tableView reloadData];
}

#pragma mark - Lazy Loading

- (UIImageView *)benefitDashboardImgView {
    
    if(!_benefitDashboardImgView) {
        
        _benefitDashboardImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-85"]];
        [self.view addSubview:_benefitDashboardImgView];
        [_benefitDashboardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        
        //左侧分割竖线
        UIImageView *leftVerticalImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
        [_benefitDashboardImgView addSubview:leftVerticalImgView];
        [leftVerticalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_benefitDashboardImgView).offset(39+15);
            make.centerX.equalTo(_benefitDashboardImgView).offset(-DMDeviceWidth/6);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@35);
        }];
        
        //右侧分割竖线
        UIImageView *rightVerticalImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
        [_benefitDashboardImgView addSubview:rightVerticalImgView];
        [rightVerticalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_benefitDashboardImgView).offset(39+15);
            make.centerX.equalTo(_benefitDashboardImgView).offset(DMDeviceWidth/6);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@35);
        }];
        
        //"预计认购金额"标签
        expectedPurchasedAmountTitleLabel = [[UILabel alloc]init];
        [_benefitDashboardImgView addSubview:expectedPurchasedAmountTitleLabel];
        [expectedPurchasedAmountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_benefitDashboardImgView).offset(39);
            make.centerX.equalTo(leftVerticalImgView).offset(-DMDeviceWidth/6);
            make.height.mas_equalTo(@15);
        }];
        [expectedPurchasedAmountTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [expectedPurchasedAmountTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [expectedPurchasedAmountTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [expectedPurchasedAmountTitleLabel setText:@"预计认购金额"];
        
        //"预计收益"标签
        expectedBenefitTitleLabel = [[UILabel alloc]init];
        [_benefitDashboardImgView addSubview:expectedBenefitTitleLabel];
        [expectedBenefitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_benefitDashboardImgView).offset(39);
            make.centerX.equalTo(_benefitDashboardImgView);
            make.height.mas_equalTo(@15);
        }];
        [expectedBenefitTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [expectedBenefitTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [expectedBenefitTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [expectedBenefitTitleLabel setText:@"预计收益"];
        
        //"月收本息"标签
        monthlyWithdrawTitleLabel = [[UILabel alloc]init];
        [_benefitDashboardImgView addSubview:monthlyWithdrawTitleLabel];
        [monthlyWithdrawTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_benefitDashboardImgView).offset(39);
            make.centerX.equalTo(rightVerticalImgView).offset(DMDeviceWidth/6);
            make.height.mas_equalTo(@15);
        }];
        [monthlyWithdrawTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [monthlyWithdrawTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [monthlyWithdrawTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [monthlyWithdrawTitleLabel setText:@"月收本息"];
        
        [_benefitDashboardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.expectedBenefitLabel).offset(24);
        }];
    }
    return _benefitDashboardImgView;
}

//预期认购金额
- (UILabel *)expectedPurchasedAmountLabel {
    
    if(!_expectedPurchasedAmountLabel) {
        
        _expectedPurchasedAmountLabel = [[UILabel alloc]init];
        [self.benefitDashboardImgView addSubview:_expectedPurchasedAmountLabel];
        [_expectedPurchasedAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(expectedPurchasedAmountTitleLabel).offset(23);
            make.centerX.equalTo(expectedPurchasedAmountTitleLabel);
            make.height.mas_equalTo(@30);
        }];
        [_expectedPurchasedAmountLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _expectedPurchasedAmountLabel;
}

//预期收益
- (UILabel *)expectedBenefitLabel {
    
    if(!_expectedBenefitLabel) {
        
        _expectedBenefitLabel = [[UILabel alloc]init];
        [self.benefitDashboardImgView addSubview:_expectedBenefitLabel];
        [_expectedBenefitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(expectedBenefitTitleLabel).offset(23);
            make.centerX.equalTo(expectedBenefitTitleLabel);
            make.height.mas_equalTo(@30);
        }];
        [_expectedBenefitLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _expectedBenefitLabel;
}

//月收本息
- (UILabel *)monthlyWithdrawLabel {
    
    if(!_monthlyWithdrawLabel) {
        
        _monthlyWithdrawLabel = [[UILabel alloc]init];
        [self.benefitDashboardImgView addSubview:_monthlyWithdrawLabel];
        [_monthlyWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(monthlyWithdrawTitleLabel).offset(23);
            make.centerX.equalTo(monthlyWithdrawTitleLabel);
            make.height.mas_equalTo(@30);
        }];
        [_monthlyWithdrawLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _monthlyWithdrawLabel;
}

- (UIView *)tableHeaderView {
    
    if(!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc]init];
        [self.view addSubview:_tableHeaderView];
        [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.benefitDashboardImgView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        
        UIImageView *withdrawDetailImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"本息回收详情表"]];
        [_tableHeaderView addSubview:withdrawDetailImgView];
        [withdrawDetailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableHeaderView).offset(37);
            make.centerX.equalTo(_tableHeaderView);
            make.width.mas_equalTo(@321);
            make.height.mas_equalTo(@19);
        }];
        
        //"月份"标签
        UILabel *monthTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:monthTitleLabel];
        [monthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(withdrawDetailImgView.mas_bottom).offset(34);
            //make.centerX.equalTo(_tableHeaderView).offset(-DMDeviceWidth/5*1.5);
            make.centerX.equalTo(_tableHeaderView).offset(-(DMDeviceWidth/2-kCenterXtoMarginPadding));
            make.height.mas_equalTo(@18);
        }];
        [monthTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [monthTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [monthTitleLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        [monthTitleLabel setText:@"月份"];
        
        //"待回本金"标签
        UILabel *residualPrincipalTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:residualPrincipalTitleLabel];
        [residualPrincipalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(withdrawDetailImgView.mas_bottom).offset(34);
            //make.centerX.equalTo(_tableHeaderView).offset(-DMDeviceWidth/5*0.5);
            make.centerX.equalTo(_tableHeaderView).offset(-(DMDeviceWidth-2*kCenterXtoMarginPadding)/3*0.5);
            make.height.mas_equalTo(@18);
        }];
        [residualPrincipalTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [residualPrincipalTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [residualPrincipalTitleLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        [residualPrincipalTitleLabel setText:@"待回本金"];
        
        //"待结收益"标签
        UILabel *residualBenefitTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:residualBenefitTitleLabel];
        [residualBenefitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(withdrawDetailImgView.mas_bottom).offset(34);
            //make.centerX.equalTo(_tableHeaderView).offset(DMDeviceWidth/5*0.5);
            make.centerX.equalTo(_tableHeaderView).offset((DMDeviceWidth-2*kCenterXtoMarginPadding)/3*0.5);
            make.height.mas_equalTo(@18);
        }];
        [residualBenefitTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [residualBenefitTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [residualBenefitTitleLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        [residualBenefitTitleLabel setText:@"待结收益"];
        
        //"待结本息"标签
        UILabel *residualWithdrawTitleLabel = [[UILabel alloc]init];
        [_tableHeaderView addSubview:residualWithdrawTitleLabel];
        [residualWithdrawTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(withdrawDetailImgView.mas_bottom).offset(34);
            //make.centerX.equalTo(_tableHeaderView).offset(DMDeviceWidth/5*1.5);
            make.centerX.equalTo(_tableHeaderView).offset(DMDeviceWidth/2-kCenterXtoMarginPadding);
            make.height.mas_equalTo(@18);
        }];
        [residualWithdrawTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [residualWithdrawTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [residualWithdrawTitleLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        [residualWithdrawTitleLabel setText:@"待结本息"];
        
        //确定底部约束
        [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(residualBenefitTitleLabel).offset(15);
        }];
        
        UIImageView *separatorLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-1"]];
        [_tableHeaderView addSubview:separatorLineImgView];
        [separatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView).offset(20);
            make.right.equalTo(_tableHeaderView).offset(-20);
            make.bottom.equalTo(_tableHeaderView);
            make.height.mas_equalTo(@1);
        }];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView {
    
    if(!_tableView) {
        
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableHeaderView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-80);
        }];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GZBenefitDetailTableViewCell class] forCellReuseIdentifier: @"benefitDetailCell"];
        //[_tableView setTableHeaderView:self.tableHeaderView];
    }
    return _tableView;
}

- (UIButton *)topAnchorBtn {
    
    if(!_topAnchorBtn) {
        
        _topAnchorBtn = [[UIButton alloc]init];
        [self.view addSubview:_topAnchorBtn];
        [_topAnchorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.bottomAnchorBtn.mas_top);
            make.width.mas_equalTo(@(22*1.2));
            make.height.mas_equalTo(@(22*1.2));
        }];
        [_topAnchorBtn setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateNormal];
        [_topAnchorBtn setBackgroundImage:[UIImage imageNamed:@"top"] forState:UIControlStateHighlighted];
        [_topAnchorBtn addTarget:self action:@selector(topAnchorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topAnchorBtn;
}

-(UIButton *)bottomAnchorBtn {
    
    if (!_bottomAnchorBtn) {
        
        _bottomAnchorBtn = [[UIButton alloc]init];
        [self.view addSubview:_bottomAnchorBtn];
        [_bottomAnchorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-20);
            make.width.mas_equalTo(@(13*1.2));
            make.height.mas_equalTo(@(15*1.2));
        }];
        [_bottomAnchorBtn setBackgroundImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateNormal];
        [_bottomAnchorBtn setBackgroundImage:[UIImage imageNamed:@"下箭头"] forState:UIControlStateHighlighted];
        [_bottomAnchorBtn addTarget:self action:@selector(bottomAnchorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomAnchorBtn;
}

#pragma mark - Button Click Action

- (void)topAnchorBtnClick {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)bottomAnchorBtnClick {
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.months-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.months;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GZBenefitDetailTableViewCell *cell = [GZBenefitDetailTableViewCell cellWithTableView:tableView];
    cell.monthLabel.text = [NSString stringWithFormat:@"第%ld月",indexPath.row+1];
    cell.residualPrincipalLabel.text = @"1632元";
    cell.residualBenefitLabel.text = @"84元";
    cell.residualWithdrawLabel.text = @"8567元";

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 63.0;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(scrollView.contentOffset.y == 0 && scrollView == self.tableView) {
        
        self.topAnchorBtn.hidden = YES;
        
    }else if (scrollView == self.tableView) {
        
        self.topAnchorBtn.hidden = NO;
    }
}

#pragma mark - Function Helper

- (NSAttributedString *)getFormattedSumStr:(NSString *)originStr {
    
    NSAttributedString *attStr_1 = [[NSAttributedString alloc]initWithString:originStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_2 = [[NSAttributedString alloc]initWithString:@"元" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    return CombineAttributedStrings(attStr_1, attStr_2);
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
