//
//  DMSettledDetailsViewController.m
//  豆蔓理财
//
//  Created by edz on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettledDetailsViewController.h"
#import "GZFullPieChartView.h"
#import "LJQTransactionDetailVC.h"
#import "GZOwnedSinglePeriodViewController.h"

#import "GZHomePageRequestManager.h"
#import "elseiCarouselView.h"
#import "OtheriCarouselView.h"
#import "elesICarousel.h"
#import "DMFullPieChartTwoView.h"

@interface DMSettledDetailsViewController ()
{
    UILabel *centerL;
    UILabel *centerL2;
    NSArray *arr1;
    NSArray *arr2;
}

@property (nonatomic, strong) UIScrollView *bigScroll;

@property (nonatomic, strong) UILabel *stageL;


@property (nonatomic, strong) UIImageView *slImg;

//本金回款
@property (nonatomic, strong) UILabel *theprincipalpaymentL;
@property (nonatomic, strong) UILabel *paymentL;

//年化利率
@property (nonatomic, strong) UILabel *annualyieldL;
@property (nonatomic, strong) UILabel *annualyieldMoneyL;

//已结期数
@property (nonatomic, strong) UILabel *numberofknotsL;
@property (nonatomic, strong) UILabel *numberL;

//已结收益
@property (nonatomic, strong) UILabel *amounthasbeenL;
@property (nonatomic, strong) UILabel *moneyL;

//线
@property (nonatomic, strong) UILabel *fline;
@property (nonatomic, strong) UILabel *sline;
@property (nonatomic, strong) UILabel *tline;
//箭头
@property (nonatomic, strong) UIImageView *ArrowImg;

//圆
@property (nonatomic, strong) GZFullPieChartView *pieChartView;

@property (nonatomic, strong) UIButton *CreditorsrightsBtn;
@property (nonatomic, strong) UIButton *ProductdescriptionBtn;


//本金利息筛选框
@property (nonatomic, strong) UIImageView *screen;
@property (nonatomic, strong) UILabel *screenL;

@property (nonatomic, strong) elseiCarouselView *elesicar;
@property (nonatomic, strong) OtheriCarouselView *icar;

@end

@implementation DMSettledDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"已结清资产详情";
    
    [self.view addSubview:self.bigScroll];
    
    [self request];
    [self requestdetails];
    
    [self.bigScroll addSubview:self.stageL];
    [self.bigScroll addSubview:self.theprincipalpaymentL];
    [self.bigScroll addSubview:self.paymentL];
//    [self.bigScroll addSubview:self.fline];
    [self.bigScroll addSubview:self.annualyieldL];
    [self.bigScroll addSubview:self.annualyieldMoneyL];
//    [self.bigScroll addSubview:self.sline];
    [self.bigScroll addSubview:self.numberofknotsL];
    [self.bigScroll addSubview:self.numberL];
//    [self.bigScroll addSubview:self.tline];
    [self.bigScroll addSubview:self.amounthasbeenL];
    [self.bigScroll addSubview:self.moneyL];
//    [self.bigScroll addSubview:self.ArrowImg];
    
   // [self.bigScroll addSubview:self.CreditorsrightsBtn];
    [self.bigScroll addSubview:self.ProductdescriptionBtn];

    
    
    if ([_model.investType isEqualToString:@"按月付息"]) {
        
        if (!_model.periods) {
            
        } else {
            
            NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:MainRed ///////////////ffd542
                                  range:NSMakeRange(10, 7)];
            
            _stageL.attributedText = AttributedStr;
        }
        
    } else if ([_model.investType isEqualToString:@"等额本息"]){
        
        if (!_model.periods) {
            
        } else {
            
            NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:UIColorFromRGB(0x50f1bf)
                                  range:NSMakeRange(10, 7)];
            
            _stageL.attributedText = AttributedStr;
        }
        
    }

    
    
    if ([self.model.investType isEqualToString:@"按月付息"]) {
        

        
    } else {
        

        [self.bigScroll addSubview:self.slImg];
        
        
    }
}

- (void)request {
    
    [[GZHomePageRequestManager defaultManager] requestForSettledDetailsUserId:USER_ID repayMethod:@"" amountType:@"" months:@"" access_token:AccessToken successBlock:^(NSNumber *settleAmount){
        
        if ([self.model.investType isEqualToString:@"按月付息"]) {
            
            
//            arr2 = @[self.model.rate,self.model.settleInterest];
            
             [self CreatepieChartView];
            centerL.text = self.model.settleInterest;
            
        } else {
        
//            arr1 = @[self.model.settleInterest];
            
            [self CreatepieChartView];
            [self CreatedowmpieChartView];
            centerL2.text = self.model.settleInterest;
            
        }
        
    } failureBlock:^{
        
    }];

}

- (void)requestdetails {
    

    
    [[GZHomePageRequestManager defaultManager] requestForSettledDetailsUserId:USER_ID recordId:self.recordId access_token:AccessToken successBlock:^(NSArray *arr, NSString *totalInterest, NSString *noSettleInterest, NSString *settleInterest,NSString *buyTime,
                                                                                                                                                     NSString *interestTime,
                                                                                                                                                     NSString *amountPrincipal) {

        
            
            if ([self.model.investType isEqualToString:@"按月付息"]) {
                
                NSDictionary *dic = @{@"time":isOrEmpty(buyTime) ? @"--" : buyTime,@"settleStatus":@(2),@"panduan":@"1",@"monthAmount":isOrEmpty(amountPrincipal) ? @"--" : amountPrincipal};
                NSDictionary *dicc = @{@"time":isOrEmpty(interestTime) ? @"--" : interestTime,@"settleStatus":@(2),@"panduan":@"2",@"monthAmount":isOrEmpty(amountPrincipal) ? @"--" : amountPrincipal};
                
                if ([buyTime isEqualToString:interestTime]) {
                    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic, nil];
                    [mutablearray addObjectsFromArray:arr];
                    elesICarousel *elesicar = [[elesICarousel alloc] initWithFrame:CGRectMake(0, 350, DMDeviceWidth, 100) arr:mutablearray];
                    [self.bigScroll addSubview:elesicar];
                    
                } else {
                    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic,dicc, nil];
                    [mutablearray addObjectsFromArray:arr];
                    elesICarousel *elesicar = [[elesICarousel alloc] initWithFrame:CGRectMake(0, 350, DMDeviceWidth, 100) arr:mutablearray];
                    [self.bigScroll addSubview:elesicar];
                }

                
            } else {
                
                NSDictionary *dic = @{@"time":isOrEmpty(buyTime) ? @"--" : buyTime,@"settleStatus":@(2),@"panduan":@"1",@"investAmount":isOrEmpty(amountPrincipal) ? @"--" : amountPrincipal};
                NSDictionary *dicc = @{@"time":isOrEmpty(interestTime) ? @"--" : interestTime,@"settleStatus":@(2),@"panduan":@"2",@"investAmount":isOrEmpty(amountPrincipal) ? @"--" : amountPrincipal};
                
                if ([buyTime isEqualToString:interestTime]) {
                    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic, nil];
                    [mutablearray addObjectsFromArray:arr];
                    _icar = [[OtheriCarouselView alloc] initWithFrame:CGRectMake(0, 620, DMDeviceWidth, 100) arr:mutablearray];
                    
                } else {
                    NSMutableArray *mutablearray = [NSMutableArray arrayWithObjects:dic,dicc, nil];
                    [mutablearray addObjectsFromArray:arr];
                    _icar = [[OtheriCarouselView alloc] initWithFrame:CGRectMake(0, 620, DMDeviceWidth, 100) arr:mutablearray];
                }
                
                [self.bigScroll addSubview:_icar];

            }



        
    } failureBlock:^{
        
    }];
    
    
    
}



- (UIScrollView *)bigScroll {
    
    if (!_bigScroll) {
        
        _bigScroll = [[UIScrollView alloc] init];
        _bigScroll.frame = DMDeviceFrame;
        _bigScroll.contentSize = CGSizeMake(0, 900);

        if ([self.model.investType isEqualToString:@"按月付息"]) {
            
            _bigScroll.scrollEnabled = NO;
            
        } else {
            
        }
        
    }
    return _bigScroll;
    
}

- (UILabel *)stageL {
    
    if (!_stageL) {
        _stageL = [[UILabel alloc] init];
        _stageL.frame = CGRectMake(15, 15, 150, 12);
        _stageL.textColor = LightGray; /////////////4b6ca7
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"第20160909期 · 等额本息"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x50f1bf)
                              range:NSMakeRange(10, 7)];
        _stageL.font = SYSTEMFONT(12);
    }
    
    return _stageL;
}

-(UILabel *)theprincipalpaymentL {
    
    if (!_theprincipalpaymentL) {
        _theprincipalpaymentL = [[UILabel alloc] init];
        _theprincipalpaymentL.frame = CGRectMake(0, 40, DMDeviceWidth/4 , 12);
        _theprincipalpaymentL.font = SYSTEMFONT(14);
        _theprincipalpaymentL.textColor = MainRed; /////////////ffd542
        _theprincipalpaymentL.textAlignment = NSTextAlignmentCenter;
        _theprincipalpaymentL.text = self.model.settlePrincipal;
        
    }
    return _theprincipalpaymentL;
}

-(UILabel *)paymentL {
    
    if (!_paymentL) {
        _paymentL = [[UILabel alloc] init];
        _paymentL.frame = CGRectMake(0, 63, DMDeviceWidth/4 , 12);
        _paymentL.font = SYSTEMFONT(11);
        _paymentL.textColor = LightGray; ////////////////4b6ca7
        _paymentL.textAlignment = NSTextAlignmentCenter;
        _paymentL.text = @"本金回款(元)";
        
    }
    return _paymentL;
}

- (UILabel *)fline {
    
    if (!_fline) {
        _fline = [[UILabel alloc] init];
        _fline.frame = CGRectMake(DMDeviceWidth/4 , 40, 1, 35);
        _fline.backgroundColor = LightGray; ///////////////4b6ca7
    }
    
    return _fline;
}


-(UILabel *)annualyieldL {
    
    if (!_annualyieldL) {
        _annualyieldL = [[UILabel alloc] init];
        _annualyieldL.frame = CGRectMake(DMDeviceWidth/4 , 40, DMDeviceWidth/4 , 12);
        _annualyieldL.font = SYSTEMFONT(14);
        _annualyieldL.textColor = MainRed; //////////////ffd542
        _annualyieldL.textAlignment = NSTextAlignmentCenter;
        _annualyieldL.text = [NSString stringWithFormat:@"%@%%",self.model.rate];

        
    }
    return _annualyieldL;
}

-(UILabel *)annualyieldMoneyL {
    
    if (!_annualyieldMoneyL) {
        _annualyieldMoneyL = [[UILabel alloc] init];
        _annualyieldMoneyL.frame = CGRectMake(DMDeviceWidth/4 , 63, DMDeviceWidth/4 , 12);
        _annualyieldMoneyL.font = SYSTEMFONT(11);
        _annualyieldMoneyL.textColor = LightGray; //////////////4b6ca7
        _annualyieldMoneyL.textAlignment = NSTextAlignmentCenter;
        _annualyieldMoneyL.text = @"年化利率";
        
    }
    return _annualyieldMoneyL;
}

- (UILabel *)sline {
    
    if (!_sline) {
        _sline = [[UILabel alloc] init];
        _sline.frame = CGRectMake(DMDeviceWidth/2, 40, 1, 35);
        _sline.backgroundColor = LightGray; /////////////////
    }
    
    return _sline;
}


-(UILabel *)numberofknotsL {
    
    if (!_numberofknotsL) {
        _numberofknotsL = [[UILabel alloc] init];
        _numberofknotsL.frame = CGRectMake(DMDeviceWidth/2 ,40, DMDeviceWidth/4 , 12);
        _numberofknotsL.font = SYSTEMFONT(14);
        _numberofknotsL.textColor = MainRed; ///////////////ffd542
        _numberofknotsL.textAlignment = NSTextAlignmentCenter;
        if (self.model.termUnit == 1) {
            _numberofknotsL.text = @"1/1";
        }else {
            _numberofknotsL.text = self.model.settlePeriod;
        }
        
    }
    return _numberofknotsL;
}

-(UILabel *)numberL {
    
    if (!_numberL) {
        _numberL = [[UILabel alloc] init];
        _numberL.frame = CGRectMake(DMDeviceWidth/2 , 63, DMDeviceWidth/4 , 12);
        _numberL.font = SYSTEMFONT(11);
        _numberL.textColor = LightGray; /////////////////4b6ca7
        _numberL.textAlignment = NSTextAlignmentCenter;
        _numberL.text = @"已结期数";
        
    }
    return _numberL;
}

- (UILabel *)tline {
    
    if (!_tline) {
        _tline = [[UILabel alloc] init];
        _tline.frame = CGRectMake(DMDeviceWidth/4 *3 , 40, 1, 35);
        _tline.backgroundColor = LightGray; /////////////////4b6ca7
    }
    
    return _tline;
}


-(UILabel *)amounthasbeenL {
    
    if (!_amounthasbeenL) {
        _amounthasbeenL = [[UILabel alloc] init];
        _amounthasbeenL.frame = CGRectMake(DMDeviceWidth/4 *3 , 40, DMDeviceWidth/4, 12);
        _amounthasbeenL.font = SYSTEMFONT(14);
        _amounthasbeenL.textColor = MainRed; ///////////////ffd542
        _amounthasbeenL.textAlignment = NSTextAlignmentCenter;
        _amounthasbeenL.text = self.model.settleInterest;
        
    }
    return _amounthasbeenL;
}

-(UILabel *)moneyL {
    
    if (!_moneyL) {
        _moneyL = [[UILabel alloc] init];
        _moneyL.frame = CGRectMake(DMDeviceWidth/4 *3, 63, DMDeviceWidth/4, 12);
        _moneyL.font = SYSTEMFONT(11);
        _moneyL.textColor = LightGray; /////////////4b6ca7
        _moneyL.textAlignment = NSTextAlignmentCenter;
        _moneyL.text = @"已结总额(元)";
        
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

    
    if ([self.model.investType isEqualToString:@"按月付息"]) {
        
        
        DMFullPieChartTwoView *chat = [[DMFullPieChartTwoView alloc] initWithFrame:CGRectMake((DMDeviceWidth -320)/2, 120, 320, (60+20)*2) radius:55 lineWidth:11 circleColor:MainRed dashLineColors:@[LightGray, MainRed] radians:@[[NSNumber numberWithFloat:M_PI_4],[NSNumber numberWithFloat:M_PI_4*5]] titles:@[[NSString stringWithFormat:@"%@%%",self.model.rate],self.model.settleInterest] values:@[@"预计年化利率",@"预期收益"]]; /////////////dashLineColors:4b6ca7      circleColor:ffd542      dashLineColors:ffd542
        [self.bigScroll addSubview:chat];
        
        
        centerL = [[UILabel alloc] init];
        centerL.frame =  CGRectMake(0, 0, 70, 30);
        centerL.center = chat.center;
        centerL.textAlignment = NSTextAlignmentCenter;
        centerL.textColor = MainRed; //////////////ffd542
        centerL.font = SYSTEMFONT(18);
        [self.bigScroll addSubview:centerL];
        
        UILabel *total = [[UILabel alloc] init];
        total.frame = CGRectMake(centerL.frame.origin.x, centerL.frame.origin.y + 30, 70, 12);
        total.textColor = LightGray; /////////////4b6ca7
        total.textAlignment = NSTextAlignmentCenter;
        total.text =@"已结利息";
        total.font = SYSTEMFONT(12);
        [self.bigScroll addSubview:total];

        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, chat.mj_y+chat.mj_h+30, DMDeviceWidth, 8)];
        bottomLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [self.bigScroll addSubview:bottomLine];
        
    }else {
    DMFullPieChartTwoView *chat = [[DMFullPieChartTwoView alloc] initWithFrame:CGRectMake((DMDeviceWidth -320)/2, 100, 320, (60+20)*2) radius:55 lineWidth:11 circleColor:MainRed dashLineColors:@[MainRed] radians:@[[NSNumber numberWithFloat:M_PI_4*5]] titles:@[self.model.settlePrincipal] values:@[@"按期还款"]];
    [self.bigScroll addSubview:chat]; ///////////////circleColor:ffd542     dashLineColors:ffd542
    
    centerL = [[UILabel alloc] init];
    centerL.frame =  CGRectMake(0, 0, 70, 30);
    centerL.center = chat.center;
    centerL.textAlignment = NSTextAlignmentCenter;
    centerL.textColor = MainRed; ////////////ffd542
    centerL.font = SYSTEMFONT(18);
    [self.bigScroll addSubview:centerL];
    
    UILabel *total = [[UILabel alloc] init];
    total.frame = CGRectMake(centerL.frame.origin.x, centerL.frame.origin.y + 30, 70, 12);
    total.textColor = LightGray; //////////////4b6ca7
    total.textAlignment = NSTextAlignmentCenter;
    total.text =@"本金回放";
    total.font = SYSTEMFONT(12);
    [self.bigScroll addSubview:total];
    }
    
    
    

}
- (UIImageView *)slImg {
    
    if (!_slImg) {
        _slImg = [[UIImageView alloc] init];
        _slImg.frame = CGRectMake((DMDeviceWidth - 30/2)/2, 260 + (40-65/2)/2, 30/2, 65/2);
        _slImg.image = [UIImage imageNamed:@"矢量智能"];
    }
    
    return _slImg;
}


- (void)CreatedowmpieChartView {
    
    
//    NSArray *colors = @[UIColorFromRGB(0x51e0a2),UIColorFromRGB(0xffd542)];
//    NSArray *classes = @[@"待结",@"已结"];
    
    DMFullPieChartTwoView *chat = [[DMFullPieChartTwoView alloc] initWithFrame:CGRectMake((DMDeviceWidth -320)/2, 300, 320, (60+20)*2) radius:55 lineWidth:11 circleColor:MainRed dashLineColors:@[MainRed] radians:@[[NSNumber numberWithFloat:M_PI_4]] titles:@[self.model.settleInterest] values:@[@"预期收益"]];
    [self.bigScroll addSubview:chat];  ///////////////circleColor:ffd542     dashLineColors:ffd542
    
    
    centerL2 = [[UILabel alloc] init];
    centerL2.frame =  CGRectMake(0, 0, 70, 30);
    centerL2.center = chat.center;
    centerL2.textAlignment = NSTextAlignmentCenter;
    centerL2.textColor = MainRed; /////////////ffd542
    centerL2.font = SYSTEMFONT(20);
    [self.bigScroll addSubview:centerL2];
    
    UILabel *total = [[UILabel alloc] init];
    total.frame = CGRectMake(centerL2.frame.origin.x, centerL2.frame.origin.y + 30, 70, 12);
    total.textColor = LightGray; //////////////4b6ca7
    total.textAlignment = NSTextAlignmentCenter;
    total.text =@"已结利息(元)";
    total.font = SYSTEMFONT(12);
    [self.bigScroll addSubview:total];
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, chat.mj_y+chat.mj_h+30, DMDeviceWidth, 8)];
    bottomLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.bigScroll addSubview:bottomLine];
}






- (UIButton *)CreditorsrightsBtn {
    
    if (!_CreditorsrightsBtn) {
        
        
        _CreditorsrightsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if ([self.model.investType isEqualToString:@"按月付息"]) {
            
            if (iPhone5) {
                _CreditorsrightsBtn.frame = CGRectMake(19, self.view.frame.size.height - 64 - 61, 292/2/1.2, 31/1.2);
            } else {
                _CreditorsrightsBtn.frame = CGRectMake(19, self.view.frame.size.height - 64 - 61, 292/2, 31);
            }
            
        } else {
            
            if (iPhone5) {
                _CreditorsrightsBtn.frame = CGRectMake(19, self.bigScroll.contentSize.height - 64 - 61, 292/2/1.2, 31/1.2);
            } else {
                _CreditorsrightsBtn.frame = CGRectMake(19, self.bigScroll.contentSize.height - 64 - 61, 292/2, 31);
            }
            
        }
        
        [_CreditorsrightsBtn setImage:[UIImage imageNamed:@"details_button"] forState:UIControlStateNormal]; ///////////持有债券详情
        [_CreditorsrightsBtn setImage:[UIImage imageNamed:@"details_button"] forState:UIControlStateHighlighted]; ///////////持有债券详情
        [_CreditorsrightsBtn addTarget:self action:@selector(creditorAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CreditorsrightsBtn;

}

- (UIButton *)ProductdescriptionBtn {
    
    if (!_ProductdescriptionBtn) {
        _ProductdescriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([self.model.investType isEqualToString:@"按月付息"]) {
            
            if (iPhone5) {
                _ProductdescriptionBtn.frame = CGRectMake((DMDeviceWidth - 292/2/1.2) / 2, self.view.frame.size.height - 64 - 61, 292/2/1.2, 31/1.2);
            } else {
                _ProductdescriptionBtn.frame = CGRectMake((DMDeviceWidth - 292/2) / 2, self.view.frame.size.height - 64 - 61, 292/2, 31);
                
            }
            
        } else {
            
            if (iPhone5) {
                _ProductdescriptionBtn.frame = CGRectMake((DMDeviceWidth - 292/2/1.2) / 2, self.bigScroll.contentSize.height - 64 - 61, 292/2/1.2, 31/1.2);
            } else {
                _ProductdescriptionBtn.frame = CGRectMake((DMDeviceWidth - 292/2) / 2, self.bigScroll.contentSize.height - 64 - 61, 292/2, 31);
                
            }
            
        }
        
        [_ProductdescriptionBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];

        
        [_ProductdescriptionBtn setImage:[UIImage imageNamed:@"Trading-_button"] forState:UIControlStateNormal]; ////////////交易明细
        [_ProductdescriptionBtn setImage:[UIImage imageNamed:@"Trading-_button"] forState:UIControlStateHighlighted];


    }
    return _ProductdescriptionBtn;
    
}

- (void)Click {
    
    [self.navigationController pushViewController:[[LJQTransactionDetailVC alloc] init] animated:YES];
}
- (void)creditorAction:(id)sender {
    
    GZOwnedSinglePeriodViewController *ospv = [[GZOwnedSinglePeriodViewController alloc] init];
    ospv.assetId = self.recordId;
    [self.navigationController pushViewController:ospv animated:YES];
}





@end
