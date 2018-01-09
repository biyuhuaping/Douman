//
//  DMSettledAssetsModel.h
//  豆蔓理财
//
//  Created by edz on 2016/12/28.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSettledAssetsModel : NSObject


//产品期数
@property (nonatomic ,strong)NSString *periods;

//投资类型
@property (nonatomic ,strong)NSString *investType;

//利率
@property (nonatomic ,strong)NSString *rate;

//已结本金
@property (nonatomic ,strong)NSString *settlePrincipal;

//已结清收益
@property (nonatomic ,strong)NSString *settleInterest;

//已结期数
@property (nonatomic ,strong)NSString *settlePeriod;

//结清日期
@property (nonatomic ,strong)NSString *lastSettleTime;




@property (nonatomic ,strong)NSString *repaymentMethod;

@property (nonatomic ,strong)NSString *assetId;

@property (nonatomic, assign)int termUnit;

@end
