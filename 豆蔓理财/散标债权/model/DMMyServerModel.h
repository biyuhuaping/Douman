//
//  DMMyServerModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMMyServerModel : NSObject

@property (nonatomic, assign) double totalAvailableAmount;  //剩余可投金额
@property (nonatomic, assign) int loanCount;                //持有债权总量
@property (nonatomic, assign) double totalAmount;           //服务持有总额
@property (nonatomic, assign) double totalInterest;         //已结收益总额
@property (nonatomic, assign) int robotCount;               //持有服务数量
@property (nonatomic, assign) double usageRate;             //总资金使用率


@end
