//
//  DMScafferCreditManager.h
//  豆蔓理财
//
//  Created by edz on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMScafferListModel.h"
@class DMTenderDescModel;
@class DMScafferBuyModel;
@class GZBuyListModel;
@class DMRobtOpeningModel;
@class DMRobtOpenInfoModel;
@class DMRobtEndListModel;
@class DMRobtDetailModel;
@class DMRobtEndDetailModel;
@class DMMyServerModel;
@interface DMScafferCreditManager : NSObject

+ (instancetype)scafferDefault;


/**
 散标债权列表
 @param page 页数
 @param size 条数
 @param months 期数
 */
- (void)DMGetScafferCreditListDataPage:(NSInteger)page size:(NSInteger)size months:(NSInteger)months showView:(UIView *)showView success:(void(^)(NSArray *dataList,NSInteger totalSize))success faild:(void(^)())faild;



//散标债权详情
- (void)getCreditDescWithLoanId:(NSString *)loadId
                        Success:(void(^)(DMTenderDescModel *tenderModel, NSArray *authenArray))success
                          faild:(void(^)())faild;

//散标购买列表
- (void)getTenderBuyListWithLoadId:(NSString *)loadId
                              Size:(NSString *)size
                           success:(void(^)(NSArray *buyList))success
                             faild:(void(^)())faild;

/**
 散标认购
 @param assetId 产品ID
 @param loanId 标的ID
 @param investAmount 投资金额
 @param couponId 优惠券ID
 @param showView 加载父视图
 */
- (void)DMScafferCreditToBuyWithAssetId:(NSString *)assetId loanId:(NSString *)loanId investAmount:(NSString *)investAmount couponId:(NSString *)couponId showView:(UIView *)showView successBlock:(void(^)(DMScafferBuyModel *buyModel))successBlock faild:(void(^)(NSString *message))faild;


/**
 小豆机器人在售
 @param robtCycle 服务期限
 */
- (void)DMRobtToGetOpeningWithRobtCycle:(NSString *)robtCycle showView:(UIView *)showView success:(void(^)(NSArray<DMRobtOpeningModel *> *robtOpenArr,NSArray<DMRobtOpenInfoModel *> *robtInfoArr))success faild:(void(^)())faild;

/**
 机器人往期列表

 @param page 页码
 @param size 条数
 */
- (void)DMRobtToGetEndRobtsWithPage:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void(^)(NSArray *endRobtArr))success faild:(void(^)())faild;

/**
 机器人详情

 @param robtID 机器人id
 */
- (void)DMRobtToGetDetailRobtWithRobtID:(NSString *)robtID showView:(UIView *)showView success:(void(^)(DMRobtEndDetailModel *detailModel))success faild:(void(^)())faild;

/**
 预约列表

 @param page 页码
 @param size 条数
 @param robtID 机器人ID

 */
- (void)DMRobtToGetListRobtBuyWithPage:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView robtID:(NSString *)robtID success:(void(^)(NSArray *buyArr))success faild:(void(^)())faild;


/**
 预约购买

 @param orderInvestAmount 预约金额
 @param robotID 机器人id
 */
- (void)DMRobtToMakeAppointmentToBuyWithOrderInvestAmount:(NSString *)orderInvestAmount robotID:(NSString *)robotID showView:(UIView *)showView success:(void(^)(NSString *message))success faild:(void(^)(NSString *message))faild;




#pragma mark --  我的服务

- (void)getMyServerRobotInfoSuccess:(void(^)(DMMyServerModel *serverModel))success
                              faild:(void(^)())faild;


- (void)getMyServerHoldListWithStatus:(NSString *)status
                                 Size:(NSString *)size
                              success:(void(^)(NSArray *holdList))success
                                faild:(void(^)())faild;

- (void)getMyServerRobotHoldCreditRobotId:(NSString *)robot
                                     Size:(NSString *)size
                                  success:(void(^)(NSArray *holdCredit))success
                                    faild:(void(^)())faild;
@end
