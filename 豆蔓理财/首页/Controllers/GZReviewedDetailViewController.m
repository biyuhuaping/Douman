//
//  GZReviewedDetailViewController.m
//  豆蔓理财
//
//  Created by armada on 2016/12/9.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZReviewedDetailViewController.h"

#import "GZCircleSlider.h"
#import "GZPurchaseProgressView.h"
#import "GZReviewedListViewController.h"

#import "LJQBuyListVC.h"
#import "DMCurrentClaimsViewController.h"

@interface GZReviewedDetailViewController ()

{
    UIButton *searchPastBtn;
    UIButton *purchaseBtn;
    UILabel *profitRateTitleLabel;
}

/** 滚动视图 */
@property(nonatomic,strong) UIScrollView *scrollView;
/** 容器视图 */
@property(nonatomic,strong) UIView *scrollContainerView;
/** 环形选择器 */
@property(nonatomic,strong) GZCircleSlider *circleSlider;
/** 收益率 */
@property(nonatomic,strong) UILabel *interestRateLabel;
/** 产品类型容器 */
@property(nonatomic,strong) UIView *productTypeBlockView;
/** 产品类型 */
@property(nonatomic,strong) UILabel *productTypeLabel;
/** 产品标签 */
@property(nonatomic,strong) UIImageView *productTypeTagImageView;
/** 年化利率 */
@property(nonatomic,strong) UILabel *profitRateLabel;
/** 借款期限 */
@property(nonatomic,strong) UILabel *productDurationLabel;
/** 剩余可购 */
@property(nonatomic,strong) UILabel *availablePurchaseLabel;
/** 筹标进度 */
@property(nonatomic,strong) GZPurchaseProgressView *progressView;
/** 筹标百分比显示 */
@property(nonatomic,strong) UILabel *progressPercentLabel;
/** 预期收益 */
@property(nonatomic,strong) UILabel *expectedProfitLabel;

@end

@implementation GZReviewedDetailViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self prepareForScrollContainer];
    
    [self prepareForBasicData];
}

#pragma mark - Network Request

- (void)prepareForBasicData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[GZHomePageRequestManager defaultManager] requestForHomePageAssetInfoWithAssetID:self.assetId successBlock:^(BOOL result, NSString *message, GZAssetInfoModel *assetInfoModel) {
        
        if(result) {
            self.interestRateLabel.attributedText = [self getInterestRatePercentString:[NSNumber numberWithDouble:assetInfoModel.rate.doubleValue+assetInfoModel.interestRate.doubleValue].stringValue];
            
            if([assetInfoModel.repaymentMethod isEqualToString:@"EqualInstallment"]) {
                self.productTypeLabel.attributedText = [self getProductTypeStringWithPeriod:assetInfoModel.periods andType:@"等额本息"];
            }else if([assetInfoModel.repaymentMethod isEqualToString:@"MonthlyInterest"]){
                self.productTypeLabel.attributedText = [self getProductTypeStringWithPeriod:assetInfoModel.periods andType:@"按月付息"];
            }else {
                self.productTypeLabel.attributedText = [self getProductTypeStringWithPeriod:assetInfoModel.periods andType:@""];
            }
            
            //产品类型标签
            if([assetInfoModel.guarantyName isEqualToString:@"分期慧投"]) {
                [self.productTypeTagImageView setImage:[UIImage imageNamed:@"分期慧投"]];
            }else if([assetInfoModel.guarantyName isEqualToString:@"车保智投"]){
                [self.productTypeTagImageView setImage:[UIImage imageNamed:@"车保智投"]];
            }else if([assetInfoModel.guarantyName isEqualToString:@"车险分期"]){
                [self.productTypeTagImageView setImage:[UIImage imageNamed:@"车保智投"]];
            }else {
                [self.productTypeTagImageView setImage:nil];
            }
            
            [self loadSeparatedRegion];
            
            self.profitRateLabel.attributedText = [self getFormatProfitRateWithBaseInterest:assetInfoModel.rate.stringValue andAdditionalInterest:assetInfoModel.interestRate.stringValue];
            self.productDurationLabel.attributedText = [self getFormatedProductDurationWithMonths:assetInfoModel.productCycle.intValue Type:assetInfoModel.termUnit];
            self.availablePurchaseLabel.text = [self getFormattedAmountOfNumberWithString:[NSNumber numberWithDouble:assetInfoModel.totalAmount.doubleValue-assetInfoModel.soldAmount.doubleValue].stringValue];
            
            if(assetInfoModel.totalAmount.doubleValue == 0){
                self.progressView.progress = 0;
            }else {
                self.progressView.progress = assetInfoModel.soldAmount.doubleValue/assetInfoModel.totalAmount.doubleValue;
            }
            
            if(assetInfoModel.totalAmount.doubleValue == 0){
                self.progressPercentLabel.text = @"0%";
            }else {
                self.progressPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",assetInfoModel.soldAmount.doubleValue/assetInfoModel.totalAmount.doubleValue*100];
            }
            
        }else {
            
            ShowMessage(message);
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(NSError *err) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - Lazy Loading

- (GZCircleSlider *)circleSlider {
    
    if(!_circleSlider) {
        
        if(iPhone5) {
            
            CGFloat circleViewSide = 200;
            _circleSlider = [[GZCircleSlider alloc]initWithFrame:CGRectMake(0, 0 , circleViewSide, circleViewSide) lineWidth:8 circleColor:UIColorFromRGB(0x323b4a) currentIndex:self.productCycle.intValue andHandleSytle:GZCircleHandleNone];
            _circleSlider.center = CGPointMake(DMDeviceWidth/2,20+_circleSlider.bounds.size.height/2+20);
        }else {
            
            CGFloat circleViewSide = 270;
            _circleSlider = [[GZCircleSlider alloc]initWithFrame:CGRectMake(0, 0 , circleViewSide, circleViewSide) lineWidth:10 circleColor:UIColorFromRGB(0x323b4a) currentIndex:self.productCycle.intValue andHandleSytle:GZCircleHandleNone];
            _circleSlider.center = CGPointMake(DMDeviceWidth/2, 20+_circleSlider.bounds.size.height/2+20);
        }
        
        [_circleSlider handlePanEnable:NO];
        
        [self.scrollContainerView addSubview:_circleSlider];
    }
    return _circleSlider;
}

//"利率"标签
- (UILabel *)interestRateLabel {
    
    if(!_interestRateLabel) {
        
        _interestRateLabel = [[UILabel alloc]init];
        [self.scrollView addSubview:_interestRateLabel];
        [_interestRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.circleSlider);
            make.height.mas_equalTo(@68);
        }];
        
        _interestRateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _interestRateLabel;
}

//产品类型容器
- (UIView *)productTypeBlockView {
    
    if(!_productTypeBlockView) {
        
        _productTypeBlockView = [[UIView alloc]init];
        [self.scrollContainerView addSubview:_productTypeBlockView];
        [_productTypeBlockView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(iPhone6plus) {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(50);
            }else {
                make.top.equalTo(self.circleSlider.mas_bottom).offset(40);
            }
            make.centerX.equalTo(self.scrollContainerView);
            make.left.mas_equalTo(self.productTypeLabel);
            make.right.mas_equalTo(self.productTypeTagImageView);
            make.height.mas_equalTo(@12);
        }];
    }
    return _productTypeBlockView;
}

//产品类型
- (UILabel *)productTypeLabel {
    
    if(!_productTypeLabel) {
        
        _productTypeLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_productTypeLabel];
        [_productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productTypeBlockView);
            make.right.equalTo(self.productTypeTagImageView.mas_left);
            make.height.mas_equalTo(@12);
        }];
        
        _productTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _productTypeLabel;
}

//"产品类型"标签
- (UIImageView *)productTypeTagImageView {
    
    if(!_productTypeTagImageView) {
        
        _productTypeTagImageView = [[UIImageView alloc]init];
        [self.scrollContainerView addSubview:_productTypeTagImageView];
        [_productTypeTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.productTypeBlockView);
            if(iPhone5) {
                
                make.width.mas_equalTo(@45);
                make.height.mas_equalTo(@15);
            }else {
                
                make.width.mas_equalTo(@63);
                make.height.mas_equalTo(@21);
            }
        }];
    }
    return _productTypeTagImageView;
}


- (GZPurchaseProgressView *)progressView{
    
    if(!_progressView) {
        
        if(iPhone5) {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 260, 3)];
        }else if(iPhone6) {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 290, 3)];
        }else {
            _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, 315, 3)];
        }
        
        [self.scrollContainerView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.productDurationLabel.mas_bottom).offset(20);
            make.left.equalTo(profitRateTitleLabel);
            if(iPhone5) {
                make.width.mas_equalTo(@260);
            }else if(iPhone6) {
                make.width.mas_equalTo(@290);
            }else {
                make.width.mas_equalTo(@315);
            }
            make.height.mas_equalTo(@3);
        }];
        
        _progressPercentLabel = [[UILabel alloc]init];
        [self.scrollContainerView addSubview:_progressPercentLabel];
        [_progressPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_progressView);
            make.left.equalTo(_progressView.mas_right).offset(8);
            make.width.mas_equalTo(@40);
            make.height.mas_equalTo(@20);
        }];
        [_progressPercentLabel setFont:[UIFont systemFontOfSize:12]];
        [_progressPercentLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        
        [self loadBottomButtons];
    }
    return _progressView;
}

#pragma mark - Layout

- (void)prepareForScrollContainer{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth, DMDeviceHeight-64)];
    [self.view addSubview:self.scrollView];
    
    _scrollContainerView = [[UIView alloc]init];
    [self.scrollView addSubview:self.scrollContainerView];
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsZero);
        make.width.equalTo(self.scrollView);
    }];
}

#pragma mark - Global Layout

- (void)loadSeparatedRegion {
    
    //top separator line
    UIImageView *separatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-首页"]];
    [self.scrollContainerView addSubview:separatorImgView];
    [separatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productTypeLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(@334);
        make.height.mas_equalTo(@12);
    }];
    
    //vertical separator line
    UIImageView *leftVerticalSeparatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
    [self.scrollContainerView addSubview:leftVerticalSeparatorImgView];
    [leftVerticalSeparatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorImgView.mas_bottom).offset(17);
        make.left.equalTo(self.scrollContainerView).offset(DMDeviceWidth/3);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@35);
    }];
    
    UIImageView *rightVerticalSeparatorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
    [self.scrollContainerView addSubview:rightVerticalSeparatorImgView];
    [rightVerticalSeparatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorImgView.mas_bottom).offset(17);
        make.right.equalTo(self.scrollContainerView).offset(-DMDeviceWidth/3);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@35);
    }];
    
    //profitRate
    profitRateTitleLabel = [[UILabel alloc]init];
    [self.scrollContainerView addSubview:profitRateTitleLabel];
    [profitRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftVerticalSeparatorImgView);
        make.right.equalTo(leftVerticalSeparatorImgView.mas_left).offset(-30);
        make.height.mas_equalTo(@13);
    }];
    [profitRateTitleLabel setTextAlignment:NSTextAlignmentRight];
    [profitRateTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [profitRateTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [profitRateTitleLabel setText:@"年化利率"];
    
    _profitRateLabel = [[UILabel alloc]init];
    [self.scrollContainerView addSubview:self.profitRateLabel];
    [self.profitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(profitRateTitleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.scrollContainerView.mas_left).offset(DMDeviceWidth/6);
        make.height.mas_equalTo(@25);
    }];
    [self.profitRateLabel setTextAlignment:NSTextAlignmentCenter];
    
    //Duration of product
    UILabel *productDurationTitleLabel =  [[UILabel alloc]init];
    [self.scrollContainerView addSubview:productDurationTitleLabel];
    [productDurationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftVerticalSeparatorImgView);
        make.centerX.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(@13);
    }];
    [productDurationTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [productDurationTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [productDurationTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [productDurationTitleLabel setText:@"借款期限"];
    
    _productDurationLabel = [[UILabel alloc]init];
    [self.scrollContainerView addSubview:self.productDurationLabel];
    [self.productDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productDurationTitleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(productDurationTitleLabel);
        make.height.mas_equalTo(@25);
    }];
    [self.productDurationLabel setTextAlignment:NSTextAlignmentCenter];
    
    //AvailablePurchase purchase
    UILabel *availablePurchaseTitleLabel = [[UILabel alloc]init];
    [self.scrollContainerView addSubview:availablePurchaseTitleLabel];
    [availablePurchaseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightVerticalSeparatorImgView);
        make.left.equalTo(rightVerticalSeparatorImgView.mas_right).offset(30);
        make.height.mas_equalTo(@13);
    }];
    [availablePurchaseTitleLabel setTextAlignment:NSTextAlignmentRight];
    [availablePurchaseTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [availablePurchaseTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    [availablePurchaseTitleLabel setText:@"剩余可购(元)"];
    
    _availablePurchaseLabel = [[UILabel alloc]init];
    [self.scrollContainerView addSubview:self.availablePurchaseLabel];
    [self.availablePurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.productDurationLabel);
        make.centerX.equalTo(self.scrollContainerView.mas_right).offset(-DMDeviceWidth/6);
        make.height.mas_equalTo(@15);
    }];
    [self.availablePurchaseLabel setTextAlignment:NSTextAlignmentCenter];
    [self.availablePurchaseLabel setFont:[UIFont systemFontOfSize:15]];
    [self.availablePurchaseLabel setTextColor:UIColorFromRGB(0xffd542)];
}

- (void)loadBottomButtons {
    //立即认购
    purchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollContainerView addSubview:purchaseBtn];
    [purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(24);
        make.centerX.equalTo(self.scrollContainerView);
        make.width.mas_equalTo(@146);
        make.height.mas_equalTo(@34);
    }];
    
    [purchaseBtn setEnabled:NO];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"立即认购-1"] forState:UIControlStateNormal];
    [purchaseBtn setBackgroundImage:[UIImage imageNamed:@"立即认购-1"] forState:UIControlStateDisabled];
    
    //本期债权
    UIButton *currentCreditorRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollContainerView addSubview:currentCreditorRightBtn];
    [currentCreditorRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(purchaseBtn);
        if(iPhone5) {
            make.right.equalTo(purchaseBtn.mas_left).offset(-8);
        }else if(iPhone6) {
            make.right.equalTo(purchaseBtn.mas_left).offset(-15);
        }else {
            make.right.equalTo(purchaseBtn.mas_left).offset(-25);
        }
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@23);
    }];
    [currentCreditorRightBtn setBackgroundImage:[UIImage imageNamed:@"本期债权"] forState:UIControlStateNormal];
    [currentCreditorRightBtn setBackgroundImage:[UIImage imageNamed:@"本期债权"] forState:UIControlStateHighlighted];
    [currentCreditorRightBtn addTarget:self action:@selector(currentCreditorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //认购列表
    UIButton *purchasedListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollContainerView addSubview:purchasedListBtn];
    [purchasedListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(purchaseBtn);
        if(iPhone5) {
            make.left.equalTo(purchaseBtn.mas_right).offset(8);
        }else if(iPhone6) {
            make.left.equalTo(purchaseBtn.mas_right).offset(15);
        }else {
            make.left.equalTo(purchaseBtn.mas_right).offset(25);
        }
        make.width.mas_equalTo(@70);
        make.height.mas_equalTo(@23);
    }];
    [purchasedListBtn setBackgroundImage:[UIImage imageNamed:@"认购列表"] forState:UIControlStateNormal];
    [purchasedListBtn setBackgroundImage:[UIImage imageNamed:@"认购列表"] forState:UIControlStateHighlighted];
    [purchasedListBtn addTarget:self action:@selector(purchasedListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(iPhone6plus) {
        [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(purchaseBtn.mas_bottom).offset(90);
        }];
        
    }else {
        [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(purchaseBtn.mas_bottom).offset(50);
        }];
    }
}

#pragma mark - button click action

//点击本期债权
- (void)currentCreditorBtnClick {
    
    DMCurrentClaimsViewController *ccvc = [[DMCurrentClaimsViewController alloc]init];
    ccvc.assetId =self.assetId;
    ccvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ccvc animated:YES];
}

//点击认购列表
- (void)purchasedListBtnClick {
    
    LJQBuyListVC *blvc = [[LJQBuyListVC alloc]init];
    blvc.assetId = self.assetId;
    [blvc.navigationItem setTitle:@"认购列表"];
    blvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:blvc animated:YES];
}

#pragma mark - Helper Function

- (NSMutableAttributedString *)getInterestRatePercentString:(NSString *)str {
    
    NSMutableAttributedString *mutableAttributedStr;
    
    if(iPhone5) {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }else {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:68],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:31],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }
    return mutableAttributedStr;
}

- (NSMutableAttributedString *)getProductTypeStringWithPeriod:(NSString *)period andType:(NSString *)type {
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"第%@期",period] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x86a7e8)}];
    
    NSAttributedString *typeString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"·%@",type] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x50f1bf)}];
    [mutableAttributedStr appendAttributedString:typeString];
    
    return mutableAttributedStr;
}

//格式化"年化利率"数值
- (NSAttributedString *)getFormatProfitRateWithBaseInterest:(NSString *)baseInterest andAdditionalInterest:(NSString *)additionalInterest{
    
    NSAttributedString *attStr_1 = [[NSAttributedString alloc]initWithString:baseInterest attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_2 = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    
    NSAttributedString *attStr_3;
    
    if (additionalInterest.doubleValue != 0) {
        
        attStr_3 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"+%@%%",additionalInterest] attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0x50f1bf)}];
        
        return CombineAttributedStrings(CombineAttributedStrings(attStr_1, attStr_2),attStr_3);
    }else {
        
        return CombineAttributedStrings(attStr_1, attStr_2);
    }
}

//格式化"借款期限"
- (NSAttributedString *)getFormatedProductDurationWithMonths:(int)month Type:(int)type{
    NSAttributedString *attStr_3 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",month] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    NSAttributedString *attStr_4;
    if (type == 1) {
        attStr_4 = [[NSAttributedString alloc]initWithString:@"天" attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    }else{
        attStr_4 = [[NSAttributedString alloc]initWithString:@"个月" attributes:@{NSAttachmentAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    }
    return CombineAttributedStrings(attStr_3, attStr_4);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
