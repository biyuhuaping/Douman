//
//  DMRobtOpeningModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRobtOpeningModel : NSObject

@property (nonatomic, copy)NSString *guarantyStyleName; //投资类型名称
@property (nonatomic, copy)NSString *guarantyStyle; //投资类型
@property (nonatomic, copy)NSString *serviceFee; //服务费率
@property (nonatomic, copy)NSString *robotNumber; //编号
@property (nonatomic, copy)NSString *status; //状态 0未发布，1发布中，2已结束，3已取消
@property (nonatomic, copy)NSString *timeCreated; //创建次数
@property (nonatomic, copy)NSString *joinTimes;// 计划加入次数
@property (nonatomic, copy)NSString *minPurchaseAmount;//最小认购额度
@property (nonatomic, copy)NSString *subNum;//已加入次数
@property (nonatomic, copy)NSString *endTime;//结束时间
@property (nonatomic, copy)NSString *robotName;//名称
@property (nonatomic, copy)NSString *ID;//机器人id
@property (nonatomic, copy)NSString *disCountRate;//贴息率
@property (nonatomic, copy)NSString *purchaseCumulativeBase;//购买累加基数
@property (nonatomic, copy)NSString *robotCycle;//服务期限
@property (nonatomic, copy)NSString *openingTime;//开放时间
@property (nonatomic, copy)NSString *stopFee;//终止费用
@property (nonatomic, copy)NSString *saleStatus;// 0未开始，1已开始，2已结束
@property (nonatomic, copy)NSString *surplusTime;//剩余毫秒数
@property (nonatomic, copy) NSString *maxRate;  //最大标的利率
@property (nonatomic, copy) NSString *minRate;  //最小标的利率

@property (nonatomic, assign)BOOL isStopFeeFree; //是否收取终止费用
@property (nonatomic, assign)BOOL isServiceFeeFree; //是否收取服务费用

@end
