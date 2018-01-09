//
//  GZProductListModel.h
//  豆蔓理财
//
//  Created by armada on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZProductListModel : NSObject
/** 产品名称 */
@property(nonatomic, copy) NSString *assetName;
/** 产品销售百分比 */
@property(nonatomic, copy) NSString *assetSoldPercent;
/** 产品加息率 */
@property(nonatomic, strong) NSNumber *assetInterestRate;
/** 最大投资金额 */
@property(nonatomic, strong) NSNumber *assetMaxAmount;
/** 产品已售金额 */
@property(nonatomic, copy) NSString *assetSoldAmount;
/** 产品期限 */
@property(nonatomic, strong) NSNumber *assetDuration;
/** 产品利率 */
@property(nonatomic, strong) NSNumber *assetRate;
/** 最小投资金额 */
@property(nonatomic, copy) NSString *assetMinAmount;
/** 产品还款方式 */
@property(nonatomic, copy) NSString *assetRepaymentMethod;
/** 产品剩余可购金额 */
@property(nonatomic, copy) NSString *assetBalance;
/** 产品ID */
@property(nonatomic, copy) NSString *assetId;
/** 产品类型 */
@property(nonatomic, copy) NSString *assetType;
/** 产品描述 */
@property(nonatomic, copy) NSString *assetDescription;
/** 产品类别 */
@property(nonatomic, copy) NSString *productCycle;
/** 产品总金额 */
@property(nonatomic, copy) NSString *assetTotalAmount;
/** 产品期数 */
@property(nonatomic, copy) NSString *assetPeriodNum;
/** 是否新手 */
@property(nonatomic, assign) BOOL noviceTask;
/** 购买累加基数 */
@property(nonatomic, strong) NSNumber *purchaseCumulativeBase;
/** 产品分类名称 */
@property(nonatomic, copy) NSString *guarantyName;
/** 产品分类 */
@property(nonatomic, copy) NSString *guarantyStyle;
/** 筹标截止时间 */
@property(nonatomic, copy) NSString *timeOut;

@property (nonatomic, assign) int termUnit;


@end
