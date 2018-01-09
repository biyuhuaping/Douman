//
//  DMHoldDetailsViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMHoldDetailsViewController.h"
#import "GZPieChartView.h"
#import "DMHoldCreditViewController.h"
#import "iCarouselView.h"
#import "OtheriCarouselView.h"
#import "DMWebViewController.h"
#import "DMWebUrlManager.h"
#import "LJQTransactionDetailVC.h"
#import "GZOwnedSinglePeriodViewController.h"
#import "elesICarousel.h"
#import "GZHomePageRequestManager.h"
#import "GZPieChartTwoView.h"
#import "GZProtocolListViewController.h"
#import "GZContractModel.h"
#import "AZT_PDFReader.h"


@interface DMHoldDetailsViewController ()
{
    NSArray *values;
    NSArray *portions;
    
    NSArray *values2;
    NSArray *portions2;
    
    
    UILabel *centerL;
    UILabel *centerL2;
    
    NSString *str1;
    NSString *investType;
    
    NSString *newassetId;
    
    BOOL count;
    
}


@property (nonatomic, strong)UIButton * slideBtn;

@property (nonatomic, strong) UIScrollView *bigScroll;

@property (nonatomic, strong) UILabel *stageL;

//年化利率
@property (nonatomic, strong) UILabel *AnnualyieldL;
@property (nonatomic, strong) UILabel *AnnualyieldMoneyL;
//月结本息
@property (nonatomic, strong) UILabel *MonthlyinterestL;
@property (nonatomic, strong) UILabel *monthlyL;
//已结期数
@property (nonatomic, strong) UILabel *NumberofknotsL;
@property (nonatomic, strong) UILabel *numberL;
//未结总额
@property (nonatomic, strong) UILabel *TotaloutstandingL;
@property (nonatomic, strong) UILabel *moneyL;

//线
@property (nonatomic, strong) UILabel *fline;
@property (nonatomic, strong) UILabel *sline;
@property (nonatomic, strong) UILabel *tline;
//箭头
@property (nonatomic, strong) UIImageView *ArrowImg;

//两个圆
@property (nonatomic, strong) GZPieChartView *pieChartView;
@property (nonatomic, strong) GZPieChartView *dowmpieChartView;

//本金利息筛选框
@property (nonatomic, strong) UIImageView *screen;
@property (nonatomic, strong) UILabel *screenL;

@property (nonatomic, strong) UIButton *CreditorsrightsBtn;
@property (nonatomic, strong) UIButton *ProductdescriptionBtn;

@property (nonatomic, strong) UIImageView *slImg;

@property (nonatomic, strong) OtheriCarouselView *icar;

@property (nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) UIImageView *bottomLine; // 8

@end

@implementation DMHoldDetailsViewController


- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        values = [NSArray array];
        portions = [NSArray array];
        
        
        values2 = [NSArray array];
        portions2 = [NSArray array];
        
        
        _dataArray = [NSArray array];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"持有详情";
    
 
    [self request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //电子签章PDF返回时隐藏Tabbar
//    self.tabBarController.tabBar.hidden = YES;
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)CreateUI {
    
    [self CreateNav];
    [self.view addSubview:self.bigScroll];
    [_bigScroll addSubview:self.stageL];
    [_bigScroll addSubview:self.AnnualyieldL];
    [_bigScroll addSubview:self.AnnualyieldMoneyL];
//    [_bigScroll addSubview:self.fline];
    [_bigScroll addSubview:self.MonthlyinterestL];
    [_bigScroll addSubview:self.monthlyL];
//    [_bigScroll addSubview:self.sline];
    [_bigScroll addSubview:self.NumberofknotsL];
    [_bigScroll addSubview:self.numberL];
//    [_bigScroll addSubview:self.tline];
    [_bigScroll addSubview:self.TotaloutstandingL];
    [_bigScroll addSubview:self.moneyL];
    [_bigScroll addSubview:self.bottomLine];
//    [self.bigScroll addSubview:self.ArrowImg];
    
    
    
    [self.bigScroll addSubview:self.CreditorsrightsBtn];
    [self.bigScroll addSubview:self.ProductdescriptionBtn];

    
}


- (void)request {
    
    
    
    
    [[GZHomePageRequestManager defaultManager] requestForHolfDetailsUserId:USER_ID recordId:self.assetId access_token:AccessToken successBlock:^(                                               NSArray *arr,
                                                                                                                                                 NSString *totalInterest,
                                                                                                                                                 NSString *noSettleInterest,
                                                                                                                                                 NSString *settleInterest,
                                                                                                                                                 NSString *noSettlePrincipal,
                                                                                                                                                 NSString *settlePrincipal,
                                                                                                                                                 NSString *repaymentMethod,
                                                                                                                                                 NSString *periods,
                                                                                                                                                 NSString *investAmount,
                                                                                                                                                 NSString *rate,
                                                                                                                                                 NSString *monthSettleAmount,
                                                                                                                                                 NSString *settlePeriod,
                                                                                                                                                 NSString *noSettleAmount,
                                                                                                                                                 NSString *buyTime,
                                                                                                                                                 NSString *interestTime,
                                                                                                                                                 NSString *assetId,
                                                                                                                        
                                                                                                                            NSString *termUnit                                                                                                                          ){
        
        
        if ([repaymentMethod isEqualToString:@"MonthlyInterest"]) {
            investType = @"按月付息";
        } else {
            investType = @"等额本息";
        }
        
         newassetId = assetId;
        
         [self CreateUI];
        

        
        if ([investType isEqualToString:@"按月付息"]) {
            
            if (!periods) {
                
            } else {
                
                NSString *str = [NSString stringWithFormat:@"第%@期 · %@",periods,investType];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:MainRed ////////////ffd542
                                      range:NSMakeRange(10, 7)];
                
                _stageL.attributedText = AttributedStr;
            }
            
        } else if ([investType isEqualToString:@"等额本息"]){
            
            if (!periods) {
                
            } else {
                
                NSString *str = [NSString stringWithFormat:@"第%@期 · %@",periods,investType];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:MainGreen //////////////50f1bf
                                      range:NSMakeRange(10, 7)];
                
                _stageL.attributedText = AttributedStr;
            }
            
        }
        
        if ([investType isEqualToString:@"按月付息"]) {
            
            _AnnualyieldL.text = investAmount;
            _AnnualyieldMoneyL.text = @"认购金额(元)";
            _MonthlyinterestL.text = [NSString stringWithFormat:@"%@%%",rate];
            _monthlyL.text = @"年化利率";
            _NumberofknotsL.text = monthSettleAmount;
            if ([termUnit isEqualToString:@"1"]) {
                _numberL.text = @"待结利息(元)";
                _TotaloutstandingL.text = @"0/1";
            }else {
                _numberL.text = @"月结利息(元)";
                _TotaloutstandingL.text = settlePeriod;
            }
            
            _moneyL.text = @"已结期数";

        } else {
            
            _AnnualyieldL.text = [NSString stringWithFormat:@"%@%%",rate];
            _AnnualyieldMoneyL.text = @"年化利率";
            _MonthlyinterestL.text = monthSettleAmount;
            
            if ([termUnit isEqualToString:@"1"]) {
              _monthlyL.text = @"待结本息";
                _NumberofknotsL.text = @"0/1";
            }else {
              _monthlyL.text = @"月结本息";
                _NumberofknotsL.text = settlePeriod;
            }
            
            
            _numberL.text = @"已结期数";
            _TotaloutstandingL.text = noSettleAmount;
            _moneyL.text = @"未结总额(元)";
            [self.bigScroll addSubview:self.slImg];
        }
 
        if ([noSettleInterest isEqualToString:@"0"] || [settleInterest isEqualToString:@"0"]) {
            portions = @[@"1",@"1"];
        } else {
            portions = @[noSettleInterest,settleInterest];
        }
        
        
        if ([investType isEqualToString:@"按月付息"]) {
            
        } else {
        
        if ([noSettlePrincipal isEqualToString:@"0"] || [settlePrincipal isEqualToString:@"0"]) {
             portions2 = @[@"1",@"1"];
        }
        else {
            portions2 = @[noSettlePrincipal,settlePrincipal];
            values2 = @[noSettlePrincipal,settlePrincipal];
        }

        }

        values = @[noSettleInterest,settleInterest];

         if ([investType isEqualToString:@"按月付息"]) {
             
             [self CreatepieChartView];
             
             self.bottomLine.frame = CGRectMake(0, 330, SCREENWIDTH, 8);
    
             NSDictionary *dic = @{@"time":buyTime,@"settleStatus":@(2),@"panduan":@"1",@"investAmount":investAmount};
             NSDictionary *dicc = @{@"time":interestTime,@"settleStatus":@(2),@"panduan":@"2",@"investAmount":investAmount};
             
             if ([buyTime isEqualToString:interestTime]) {
                 NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic, nil];
                 [mutablearray addObjectsFromArray:arr];
                 elesICarousel *elesicar = [[elesICarousel alloc] initWithFrame:CGRectMake(0, 360, DMDeviceWidth, 100) arr:mutablearray];
                 elesicar.rate = investAmount;
                 [_bigScroll addSubview:elesicar];
                 
             } else {
                 NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic,dicc, nil];
                 [mutablearray addObjectsFromArray:arr];
                  elesICarousel *elesicar = [[elesICarousel alloc] initWithFrame:CGRectMake(0, 360, DMDeviceWidth, 100) arr:mutablearray];
                 elesicar.rate = investAmount;
                 [_bigScroll addSubview:elesicar];
             }


             centerL.text = totalInterest;
             
         } else {
             
             UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.AnnualyieldMoneyL.mj_y+self.AnnualyieldMoneyL.mj_h+15, DMDeviceWidth, 8)];
             topLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
             [self.bigScroll addSubview:topLine];
             
             [self CreatepieChartView];
             [self CreatedowmpieChartView];
             
             self.bottomLine.frame = CGRectMake(0, 583, SCREENWIDTH, 8);
           
             
             centerL.text = investAmount;
             centerL2.text = totalInterest;
             
             NSDictionary *dic = @{@"time":buyTime,@"settleStatus":@(2),@"panduan":@"1",@"investAmount":investAmount};
             NSDictionary *dicc = @{@"time":interestTime,@"settleStatus":@(2),@"panduan":@"2",@"investAmount":investAmount};
             
             if ([buyTime isEqualToString:interestTime]) {
                 NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic, nil];
                 [mutablearray addObjectsFromArray:arr];
                 _icar = [[OtheriCarouselView alloc] initWithFrame:CGRectMake(0, 640, DMDeviceWidth, 100) arr:mutablearray];
             } else {
                 NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic,dicc, nil];
                 [mutablearray addObjectsFromArray:arr];
                 _icar = [[OtheriCarouselView alloc] initWithFrame:CGRectMake(0, 640, DMDeviceWidth, 100) arr:mutablearray];
             }

             [self.bigScroll addSubview:_icar];
         }

        
        [self requestdelegata];
        
        
    } failureBlock:^{
        
        ShowMessage(@"请检查您的网络");
    }];
    
    
    
}


- (void)requestdelegata {
    
    [[GZHomePageRequestManager defaultManager] requestForHolfDetailsUserId:USER_ID WithrecordId:newassetId successBlock:^(NSArray *dataArr) {
        
        if (dataArr.count == 0) {
            [self.bigScroll addSubview:self.CreditorsrightsBtn];
            [self.bigScroll addSubview:self.ProductdescriptionBtn];
            [_ProductdescriptionBtn setHidden:YES];

            if ([investType isEqualToString:@"按月付息"]) {
                
                if (iPhone5) {
                    _CreditorsrightsBtn.frame = CGRectMake((DMDeviceWidth - 292/2/1.2)/2, self.view.frame.size.height - 64 - 61, 292/2/1.2, 31/1.2);
                } else {
                    _CreditorsrightsBtn.frame = CGRectMake((DMDeviceWidth - 292/2)/2, self.view.frame.size.height - 64 - 61, 292/2, 31);
                }
                
            } else {
                
                if (iPhone5) {
                    _CreditorsrightsBtn.frame = CGRectMake((DMDeviceWidth - 292/2/1.2)/2, self.bigScroll.contentSize.height - 64 - 61, 292/2/1.2, 31/1.2);
                } else {
                    _CreditorsrightsBtn.frame = CGRectMake((DMDeviceWidth - 292/2)/2, self.bigScroll.contentSize.height - 64 - 61, 292/2, 31);
                }
                
            }

        } else if (dataArr.count == 1){
            
            count =YES;
            _dataArray = dataArr;

        } else {
            
            count =NO;
            _dataArray = dataArr;
        }
        
        
    } failureBlock:^{
        
    }];

    
    
}


- (UIScrollView *)bigScroll {
    
    if (!_bigScroll) {
        
        _bigScroll = [[UIScrollView alloc] init];
        _bigScroll.frame = DMDeviceFrame;
        _bigScroll.contentSize = CGSizeMake(0, 900);
        if ([investType isEqualToString:@"按月付息"]) {
            if (iPhone5) {
                _bigScroll.contentSize = CGSizeMake(0, 600);
            }else{
                _bigScroll.pagingEnabled = NO;
            }
            
         }else {
             _bigScroll.contentSize = CGSizeMake(0, 900);
         }
    }
    return _bigScroll;
    
}

- (void)CreateNav {
    
    _slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _slideBtn.frame = CGRectMake(0, 0, 15, 16);
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"detail_icon"] forState:UIControlStateNormal]; ////////////明细
    [_slideBtn setBackgroundImage:[UIImage imageNamed:@"detail_icon"] forState:UIControlStateHighlighted]; ////////////明细
    [_slideBtn addTarget: self action:@selector(slideClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_slideBtn];
}


- (void)slideClick:(id)sender{
    
    [self.navigationController pushViewController:[[LJQTransactionDetailVC alloc] init] animated:YES];
    
}


- (UIImageView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 583, SCREENWIDTH, 8)];
        _bottomLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _bottomLine;
}


- (UILabel *)stageL {
    
    if (!_stageL) {
        _stageL = [[UILabel alloc] init];
        _stageL.frame = CGRectMake(15, 15, 150, 12);
        _stageL.textColor = LightGray; //////////////4b6ca7
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"第20160909期 · 等额本息"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:MainGreen //////////////50f1bf
                              range:NSMakeRange(10, 7)];
        _stageL.font = SYSTEMFONT(12);
    }
    
    return _stageL;
}

-(UILabel *)AnnualyieldL {
    
    if (!_AnnualyieldL) {
        _AnnualyieldL = [[UILabel alloc] init];
        _AnnualyieldL.frame = CGRectMake(0, 40, DMDeviceWidth/4 - 10, 12);
        _AnnualyieldL.font = SYSTEMFONT(14);
        _AnnualyieldL.textColor = MainRed; ////////////////ffd542
        _AnnualyieldL.textAlignment = NSTextAlignmentCenter;
//        _AnnualyieldL.text = @"10%";
        
    }
    return _AnnualyieldL;
}

-(UILabel *)AnnualyieldMoneyL {
    
    if (!_AnnualyieldMoneyL) {
        _AnnualyieldMoneyL = [[UILabel alloc] init];
        _AnnualyieldMoneyL.frame = CGRectMake(0, 63, DMDeviceWidth/4 - 10, 12);
        _AnnualyieldMoneyL.font = SYSTEMFONT(11);
        _AnnualyieldMoneyL.textColor = LightGray; //////////////4b6ca7
        _AnnualyieldMoneyL.textAlignment = NSTextAlignmentCenter;
        _AnnualyieldMoneyL.text = @"年化利率";
        
    }
    return _AnnualyieldMoneyL;
}

- (UILabel *)fline {
    
    if (!_fline) {
        _fline = [[UILabel alloc] init];
        _fline.frame = CGRectMake(DMDeviceWidth/4 - 10, 40, 1, 35);
        _fline.backgroundColor = LightGray; //////////////4b6ca7
    }
    
    return _fline;
}


-(UILabel *)MonthlyinterestL {
    
    if (!_MonthlyinterestL) {
        _MonthlyinterestL = [[UILabel alloc] init];
        _MonthlyinterestL.frame = CGRectMake(DMDeviceWidth/4 - 10, 40, DMDeviceWidth/4 , 12);
        _MonthlyinterestL.font = SYSTEMFONT(14);
        _MonthlyinterestL.textColor = MainRed; ////////////////ffd542
        _MonthlyinterestL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _MonthlyinterestL;
}

-(UILabel *)monthlyL {
    
    if (!_monthlyL) {
        _monthlyL = [[UILabel alloc] init];
        _monthlyL.frame = CGRectMake(DMDeviceWidth/4 - 10, 63, DMDeviceWidth/4 , 12);
        _monthlyL.font = SYSTEMFONT(11);
        _monthlyL.textColor = LightGray; ///////////////4b6ca7
        _monthlyL.textAlignment = NSTextAlignmentCenter;
        _monthlyL.text = @"月结本息";
        
    }
    return _monthlyL;
}

- (UILabel *)sline {
    
    if (!_sline) {
        _sline = [[UILabel alloc] init];
        _sline.frame = CGRectMake(DMDeviceWidth/2-10, 40, 1, 35);
        _sline.backgroundColor = LightGray; /////////////////4b6ca7
    }
    
    return _sline;
}


-(UILabel *)NumberofknotsL {
    
    if (!_NumberofknotsL) {
        _NumberofknotsL = [[UILabel alloc] init];
        _NumberofknotsL.frame = CGRectMake(DMDeviceWidth/2-10, 40, DMDeviceWidth/4 , 12);
        _NumberofknotsL.font = SYSTEMFONT(14);
        _NumberofknotsL.textColor = MainRed; ////////////////ffd542
        _NumberofknotsL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _NumberofknotsL;
}

-(UILabel *)numberL {
    
    if (!_numberL) {
        _numberL = [[UILabel alloc] init];
        _numberL.frame = CGRectMake(DMDeviceWidth/2 - 10, 63, DMDeviceWidth/4 , 12);
        _numberL.font = SYSTEMFONT(11);
        _numberL.textColor = LightGray; ///////////////4b6ca7
        _numberL.textAlignment = NSTextAlignmentCenter;
        _numberL.text = @"已结期数";
        
    }
    return _numberL;
}

- (UILabel *)tline {
    
    if (!_tline) {
        _tline = [[UILabel alloc] init];
        _tline.frame = CGRectMake(DMDeviceWidth/4 *3 - 10, 40, 1, 35);
        _tline.backgroundColor = LightGray; ///////////////4b6ca7
    }
    
    return _tline;
}


-(UILabel *)TotaloutstandingL {
    
    if (!_TotaloutstandingL) {
        _TotaloutstandingL = [[UILabel alloc] init];
        _TotaloutstandingL.frame = CGRectMake(DMDeviceWidth/4 *3 - 10, 40, DMDeviceWidth/4+ 10, 12);
        _TotaloutstandingL.font = SYSTEMFONT(14);
        _TotaloutstandingL.textColor = MainRed; /////////////////ffd542
        _TotaloutstandingL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _TotaloutstandingL;
}

-(UILabel *)moneyL {
    
    if (!_moneyL) {
        _moneyL = [[UILabel alloc] init];
        _moneyL.frame = CGRectMake(DMDeviceWidth/4 *3 - 10, 63, DMDeviceWidth/4+ 10, 12);
        _moneyL.font = SYSTEMFONT(11);
        _moneyL.textColor = LightGray; ///////////////4b6ca7
        _moneyL.textAlignment = NSTextAlignmentCenter;
        _moneyL.text = @"未结总额(元)";
        
    }
    return _moneyL;
}

-(UIImageView *)ArrowImg {
    
    if (!_ArrowImg) {
        _ArrowImg = [[UIImageView alloc] init];
        _ArrowImg.frame = CGRectMake(DMDeviceWidth - 12, 52, 7, 25/2);
        _ArrowImg.image = [UIImage imageNamed:@"向右箭头"];
    }
    
    return _ArrowImg;
}

- (void)CreatepieChartView {
    
        if ([investType isEqualToString:@"按月付息"]) {
            
            
            NSArray *colors = @[MainGreen, MainRed]; //////////////51e0a2\ffd542
            NSArray *classes = @[@"待结收益",@"已结收益"];

            GZPieChartTwoView *pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake((DMDeviceWidth -300)/2, 100, 300, 200) portions:portions portionColors:colors radius:60 lineWidth:11 values:values classes:classes];
            [self.bigScroll addSubview:pieChartView];
            
            centerL = [[UILabel alloc] init];
            centerL.frame =  CGRectMake(0, 0, 70, 30);
            centerL.center = pieChartView.center;
            centerL.textAlignment = NSTextAlignmentCenter;
            centerL.textColor = MainRed; ////////////////////ffd542
            centerL.font = SYSTEMFONT(15);
            [self.bigScroll addSubview:centerL];
            
            UILabel *total = [[UILabel alloc] init];
            total.frame = CGRectMake(centerL.frame.origin.x, centerL.frame.origin.y + 30, 70, 12);
            total.textColor = LightGray; ///////////////4b6ca7
            total.textAlignment = NSTextAlignmentCenter;
            total.text =@"预计收益(元)";
            total.font = SYSTEMFONT(12);
            [self.bigScroll addSubview:total];

            
        } else {
            
            
            NSArray *colors = @[MainGreen, MainRed]; //////////////////ffd542换fc6f57
            NSArray *classes = @[@"待回款",@"已回款"];
            
            GZPieChartTwoView *pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake((DMDeviceWidth -300)/2, 120, 300, 200) portions:portions2 portionColors:colors radius:60 lineWidth:11 values:values2 classes:classes];
            [self.bigScroll addSubview:pieChartView];
            
            centerL = [[UILabel alloc] init];
            centerL.frame =  CGRectMake(0, 0, 70, 30);
            centerL.center = pieChartView.center;
            centerL.textAlignment = NSTextAlignmentCenter;
            centerL.textColor = MainRed; /////////////////ffd542
            centerL.font = SYSTEMFONT(15);
            [self.bigScroll addSubview:centerL];
            
            UILabel *total = [[UILabel alloc] init];
            total.frame = CGRectMake(centerL.frame.origin.x, centerL.frame.origin.y + 30, 70, 12);
            total.textColor = LightGray; ///////////////4b6ca7
            total.textAlignment = NSTextAlignmentCenter;
            total.text =@"出借本金(元)";
            total.font = SYSTEMFONT(12);
            [self.bigScroll addSubview:total];
        }
        
        

}

- (UIImageView *)slImg {
    
    if (!_slImg) {
        _slImg = [[UIImageView alloc] init];
        _slImg.frame = CGRectMake((DMDeviceWidth - 30/2)/2, 310 + (40-65/2)/2+5, 30/2, 53/2);
        _slImg.image = [UIImage imageNamed:@"details_arrow_icon@2x(1)"]; ///////////////矢量智能
    }
    
    return _slImg;
}


- (void)CreatedowmpieChartView {
    

    NSArray *colors = @[MainGreen,MainRed]; /////////////////ffd542
    NSArray *classes = @[@"待结",@"已结"];
    
    GZPieChartTwoView *pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake((DMDeviceWidth -300)/2, 360, 300, 200) portions:portions portionColors:colors radius:60 lineWidth:11 values:values classes:classes];
    [self.bigScroll addSubview:pieChartView];
    
    centerL2 = [[UILabel alloc] init];
    centerL2.frame =  CGRectMake(0, 0, 70, 30);
    centerL2.center = pieChartView.center;
    centerL2.textAlignment = NSTextAlignmentCenter;
    centerL2.textColor = MainRed; /////////////////ffd542
    centerL2.font = SYSTEMFONT(15);
    [self.bigScroll addSubview:centerL2];
    
    UILabel *total = [[UILabel alloc] init];
    total.frame = CGRectMake(centerL2.frame.origin.x, centerL2.frame.origin.y + 30, 70, 12);
    total.textColor = LightGray; /////////////4b6ca7
    total.textAlignment = NSTextAlignmentCenter;
    total.text =@"预计收益(元)";
    total.font = SYSTEMFONT(12);
    [self.bigScroll addSubview:total];

    
}

- (UIButton *)CreditorsrightsBtn {
    
    if (!_CreditorsrightsBtn) {
        
        
        _CreditorsrightsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       

         if ([investType isEqualToString:@"按月付息"]) {
             
             if (iPhone5) {
                 _CreditorsrightsBtn.frame = CGRectMake(19, self.view.frame.size.height-10, 292/2/1.2, 31/1.2);
             } else {
                 _CreditorsrightsBtn.frame = CGRectMake(19, self.view.frame.size.height  - 64, 292/2, 31);
             }
             
         } else {
             
             if (iPhone5) {
                 _CreditorsrightsBtn.frame = CGRectMake(19, self.bigScroll.contentSize.height - 64 - 61, 292/2/1.2, 31/1.2);
             } else {
                 _CreditorsrightsBtn.frame = CGRectMake(19, self.bigScroll.contentSize.height - 64 - 61, 292/2, 31);
             }
             
         }
        
        [_CreditorsrightsBtn setImage:[UIImage imageNamed:@"details_button"] forState:UIControlStateNormal]; //////////持有债券详情
        [_CreditorsrightsBtn setImage:[UIImage imageNamed:@"details_button"] forState:UIControlStateHighlighted]; //////////持有债券详情
        [_CreditorsrightsBtn addTarget:self action:@selector(creditorAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CreditorsrightsBtn;
}

- (UIButton *)ProductdescriptionBtn {
    
    if (!_ProductdescriptionBtn) {
        _ProductdescriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([investType isEqualToString:@"按月付息"]) {
            
            if (iPhone5) {
                _ProductdescriptionBtn.frame = CGRectMake(DMDeviceWidth - 19 - 292/2/1.2, self.view.frame.size.height-10 , 292/2/1.2, 31/1.2);
            } else {
                _ProductdescriptionBtn.frame = CGRectMake(DMDeviceWidth - 19 - 292/2, self.view.frame.size.height - 64, 292/2, 31);
                
            }
            
        } else {
            
            if (iPhone5) {
                _ProductdescriptionBtn.frame = CGRectMake(DMDeviceWidth - 19 - 292/2/1.2, self.bigScroll.contentSize.height - 64 - 61, 292/2/1.2, 31/1.2);
            } else {
                _ProductdescriptionBtn.frame = CGRectMake(DMDeviceWidth - 19 - 292/2, self.bigScroll.contentSize.height - 64 - 61, 292/2, 31);
                
            }
            
        }
        
        [_ProductdescriptionBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        [_ProductdescriptionBtn setImage:[UIImage imageNamed:@"相关协议及风险提示-new"] forState:UIControlStateNormal];
        [_ProductdescriptionBtn setImage:[UIImage imageNamed:@"相关协议及风险提示-new"] forState:UIControlStateHighlighted];
    }
    return _ProductdescriptionBtn;
}

- (void)Click {

    if (count == YES) {
    
        [self downLoadPDF:[_dataArray[0] objectForKey:@"path"] andTitle:[_dataArray[0] objectForKey:@"name"]];
        
        [self.downloadTask resume];

    } else {
        
        GZProtocolListViewController *plvc = [[GZProtocolListViewController alloc] init];
        plvc.dataSource = [GZContractModel mj_objectArrayWithKeyValuesArray:_dataArray];
        plvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:plvc animated:YES];
    }
}

- (void)creditorAction:(id)sender {
    
    GZOwnedSinglePeriodViewController *ospv = [[GZOwnedSinglePeriodViewController alloc] init];
    ospv.assetId = self.storeId;
    [self.navigationController pushViewController:ospv animated:YES];
    
}

//下载PDF文件
- (void)downLoadPDF:(NSString *)urlString andTitle:(NSString *)title{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //File Url
    NSString* fileUrl = urlString;
    //创建 Request
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    //下载进行中的事件
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度---%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        CGFloat number = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        if (number == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *string = [NSString stringWithFormat:@"%@.pdf",response.suggestedFilename];
        
        NSString *path = [cachesPath stringByAppendingPathComponent:string];
        
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *imgFilePath = [filePath path];
        //设置签章验证的颜色
        [[AZT_PDFReader getInstance] setShowSignatureViewMainColor:[UIColor whiteColor]];
        //打开阅读器
        [[AZT_PDFReader getInstance] openPDFWithViewCtr:self PDFPath:imgFilePath ViewCtrTitle:title];
    }];
}

@end
