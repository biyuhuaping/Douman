//
//  DMCreditUrlManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCreditUrlManager : NSObject

+ (instancetype)manager;


/**
 持有债权列表
 */
- (NSString *)getHoldCreditListUrlWithStyle:(NSString *)style Size:(NSString *)size;


/**
 单期持有债权
 */
- (NSString *)getSingleHoldCreditWithAssetid:(NSString *)assetId
                                        Page:(NSString *)page;



/**
 车辆质押债权详情
 */
- (NSString *)getCarPledgeCreditDetailWithLoanId:(NSString *)loanId;


/**
 车险分期债权详情

 @param loanId 债权ID
 */
- (NSString *)getCarInsuranceCreditDetailWithLoanId:(NSString *)loanId;



/**
 手势解锁 验证登录密码
 */
- (NSString *)getCheckPassWordUrl;


/**
 我的账户 债转转让列表
 */
- (NSString *)getCreditTransferListUrlStatus:(NSString *)status;



/**
 我的账户 发起债转

 @param investId 投资记录ID
 */
- (NSString *)getCreditTransferStartUrlInvestId:(NSString *)investId;


/**
 我的账户 撤销债转
 
 */
- (NSString *)getCreditTransferRevokeUrlTransferId:(NSString *)transferId;

// 合同
- (NSString *)getCreditContactUrl:(NSString *)loanId;


//已转让合同
- (NSString *)getTransferContactUrl:(NSString *)assignId;


/**
 提现——保存订单
 */
- (NSString *)getdrawSavePayUrl;


/**
 提现——请求form表单数据
 */
- (NSString *)getFormDataUrl;


/**
 设置交易密码
 */
- (NSString *)getReplacePassWordUrl;

@end
