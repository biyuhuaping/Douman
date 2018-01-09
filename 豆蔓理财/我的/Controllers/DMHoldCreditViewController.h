//
//  DMHoldCreditViewController.h
//  zaiquan
//
//  Created by wujianqiang on 2016/12/5.
//  Copyright © 2016年 wujianqiang. All rights reserved.
// 持有债权
//

#import "DMBaseViewController.h"
#import "GZPieChartTwoView.h"
@interface DMHoldCreditViewController : DMBaseViewController

- (instancetype)initWithIV:(UIView *)IV;

@property (nonatomic, strong)GZPieChartTwoView *pieChartView;

@end
