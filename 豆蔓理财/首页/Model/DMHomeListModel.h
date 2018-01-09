//
//  DMHomeListModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHomeListModel : NSObject

@property (nonatomic, copy) NSString *assetSoldPercent;     //已售出百分比
@property (nonatomic, copy) NSString *assetName;            //产品名称
@property (nonatomic, copy) NSString *assetInterestRate;    //产品贴息
@property (nonatomic, copy) NSString *assetMaxAmount;       //最大购买金额
@property (nonatomic, copy) NSString *productCycle;         //产品期限
@property (nonatomic, copy) NSString *assetSoldAmount;      //已认购金额
@property (nonatomic, copy) NSString *timeOut;              //募集截止时间
@property (nonatomic, copy) NSString *assetId;              //产品ID
@property (nonatomic, copy) NSString *assetType;            //产品类型
@property (nonatomic, copy) NSString *assetDescription;     //产品描述
@property (nonatomic, copy) NSString *assetTotalAmount;     //产品总额
@property (nonatomic, copy) NSString *openingTime;          //开放投标时间
@property (nonatomic, copy) NSString *assetPeriodNum;       //产品期数
@property (nonatomic, copy) NSString *assetRepaymentMethod; //还款方式
@property (nonatomic, copy) NSString *assetMinAmount;       //最小购买金额
@property (nonatomic, copy) NSString *assetRate;            //产品利率
@property (nonatomic, copy) NSString *assetTypeName;    //产品类型


@property (nonatomic, copy) NSString *assetStatus;          //产品状态
@property (nonatomic, copy) NSString *purchaseCumulativeBase;//购买累加基数
@property (nonatomic, copy) NSString *purchaseNumber;       //产品已认购次数

@property (nonatomic, copy) NSString *assetBalance;         //剩余可认购金额
@property (nonatomic, copy) NSString *noviceTask;           //是否新手产品

@property (nonatomic, assign)int termUnit; //期限单位

///** 产品分类名称 */
//@property(nonatomic, copy) NSString *guarantyStyleName;
///** 产品分类 */
//@property(nonatomic, copy) NSString *guarantyStyle;


@end
