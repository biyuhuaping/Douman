//
//  DMHoldingAssetsModel.h
//  豆蔓理财
//
//  Created by edz on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHoldingAssetsModel : NSObject

//产品期数
@property (nonatomic ,copy)NSString *periods;

@property (nonatomic, copy)NSString *storeId;///不知道什么

//投资类型
@property (nonatomic, copy)NSString *investType;

//结清日期
@property (nonatomic, copy)NSString *lastSettleTime;

//月结本息
@property (nonatomic, copy)NSString *monthSettleAmount;

//已结期数
@property (nonatomic, copy)NSString *settlePeriod;

//待结总额
@property (nonatomic, copy)NSString *noSettleAmount;

//最后一次结算日起
@property (nonatomic, copy)NSString *nextSettleTime;

//未结息 已结息
@property (nonatomic, copy)NSString *isLoanEnd;


//////////////-------------------------------------


@property (nonatomic, copy)NSString *assetId;

//年化利率
@property (nonatomic, copy)NSString *rate;

//投资期限
@property (nonatomic, copy)NSString *period;

//认购本金
@property (nonatomic, copy)NSString *investAmout;

@property (nonatomic, assign) int termUnit;


@end
