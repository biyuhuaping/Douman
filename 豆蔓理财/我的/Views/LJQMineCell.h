//
//  LJQMineCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZPieChartTwoView.h"

typedef void(^withDrawalBlock)(UIButton *sender); //提现
typedef void(^HoldtheClaimBlock)(UIButton *sender); //持有债权
typedef void(^HoldAssetBlock)(UIButton *sender); //持有资产
typedef void(^topUpBlock)(UIButton *sender); //充值

typedef void(^myServiceActionBlock)(); //我的服务
typedef void(^sevenDayBlock)();

@class LJQMineModel;
@interface LJQMineCell : UITableViewCell
@property (nonatomic, strong)GZPieChartTwoView *pieChartView;
@property (nonatomic, copy)withDrawalBlock withDrawalBK;
@property (nonatomic, copy)HoldtheClaimBlock holdThebk;
@property (nonatomic, copy)HoldAssetBlock holdAssetBK;
@property (nonatomic, copy)topUpBlock topUpBK;
@property (nonatomic, copy)myServiceActionBlock serviceBK;

@property (nonatomic, copy)sevenDayBlock sevenDay;
@property (nonatomic, strong)LJQMineModel *model;

@end
