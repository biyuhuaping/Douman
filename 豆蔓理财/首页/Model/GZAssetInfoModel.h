//
//  GZAssetInfoModel.h
//  豆蔓理财
//
//  Created by armada on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZAssetInfoModel : NSObject

/** 产品期数 */
@property(nonatomic, copy) NSString *periods;
/** 产品ID */
@property(nonatomic, copy) NSString *assetStoreId;
/** 状态 */
@property(nonatomic, strong) NSNumber *status;
/** 产品还款方式 */
@property(nonatomic, copy) NSString *repaymentMethod;
/** 最大投资金额 */
@property(nonatomic, strong) NSNumber *maxAmount;
/** 开始时间 */
@property(nonatomic, strong) NSNumber *openTime;
/** 结束时间 */
@property(nonatomic, strong) NSNumber *endTime;
/** 产品加息率 */
@property(nonatomic, strong) NSNumber *interestRate;
/** 产品包ID */
@property(nonatomic, copy) NSString *baseBagId;
/** 投资方式 */
@property(nonatomic, strong) NSNumber *interestWay;
/** 产品类别 */
@property(nonatomic, copy) NSString *category;
/** 最小投资金额 */
@property(nonatomic, strong) NSNumber *minAmount;
/** 产品利率 */
@property(nonatomic, strong) NSNumber *rate;
/** 产品已售金额 */
@property(nonatomic, strong) NSNumber *soldAmount;
/** 产品名称 */
@property(nonatomic, copy) NSString *name;
/** 产品总额 */
@property(nonatomic, strong) NSNumber *totalAmount;
/** 产品期限 */
@property(nonatomic, strong) NSNumber *productCycle;
/** 产品分类名称 */
@property(nonatomic, copy) NSString *guarantyName;
/** 产品分类 */
@property(nonatomic, copy) NSString *guarantyStyle;

@property (nonatomic, assign) int termUnit;

@end
