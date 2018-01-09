//
//  DMMyServerHoldListModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMMyServerHoldListModel : NSObject

@property (nonatomic, copy) NSString *listId;           //预约ID
@property (nonatomic, assign) double orderAmount;       //预约金额
@property (nonatomic, copy) NSString *timeCreated;      // 预约时间
@property (nonatomic, copy) NSString *mobile;           //用户
@property (nonatomic, copy) NSString *robotName;        //服务名称
@property (nonatomic, copy) NSString *addRate;          //豆贴息
@property (nonatomic, assign) int robotCycle;           //期限
@property (nonatomic, assign) double interestAmountSum; //已结收益
@property (nonatomic, copy) NSString *orderEndDate;     //服务结束时间
@property (nonatomic, assign) double maxRate;           //预期最大利率
@property (nonatomic, assign) double minRate;           //预期最小利率
@property (nonatomic, copy) NSString *robotNumber;  

@property (nonatomic, strong) NSArray *contracts;


@end
