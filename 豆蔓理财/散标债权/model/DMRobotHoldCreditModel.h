//
//  DMRobotHoldCreditModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRobotHoldCreditModel : NSObject

@property (nonatomic, copy) NSString *loanId;
@property (nonatomic, assign) double amount;            //资产总额
@property (nonatomic, copy) NSString *sourceOfAssets;   //资产来源
@property (nonatomic, copy) NSString *title;            //资产名称
@property (nonatomic, assign) double rate;              //利率
@property (nonatomic, copy) NSString *guarantyStyle;    //资产类型
@property (nonatomic, assign) int isSettled;            //是否已接
@property (nonatomic, assign) int period;               //期限
@property (nonatomic, copy) NSString *methodName;       //还款方式名称
@property (nonatomic, copy) NSString *guarantyStyleName;//资产类型名称
@property (nonatomic, copy) NSString *method;           //还款方式
@property (nonatomic, assign) double interestAmount;    //预计收益
@property (nonatomic, assign)int termUnit;              //期限单位

@end
