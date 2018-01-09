//
//  DMCreditRequestManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMCreditAssetListModel;
@class DMHoldCreditModel;
@class DMloanProportionModel;
@class DMSingleLoanModel;
@class DMCarPledgeModel;
@class DMCarPledgeListModel;
@class DMCreditTransferModel;
@interface DMCreditRequestManager : NSObject

+ (instancetype)manager;



/**
 获取持有详情列表界面
 */
- (void)getHoldCreditListWithStyle:(NSString *)Style
                              Size:(NSString *)size
                       Success:(void(^)(DMHoldCreditModel *creditModel,
                                        NSArray <DMCreditAssetListModel*>*assetList,
                                        NSArray <DMloanProportionModel*>*loans))success
                            Failed:(void(^)())failed;


/**
 单期持有债权
 */
- (void)getSingleHoldCreditWithAssetId:(NSString *)assetId
                                  page:(NSString *)page
                               Success:(void(^)(DMCreditAssetListModel *assetModel,
                                                NSArray <DMSingleLoanModel*>*loanList))success
                                Failed:(void(^)())failed;

/**
 车辆质押债权详情
 */

- (void)getRequstCarPledgeWithLoanId:(NSString *)loanId
                             Success:(void(^)(DMCarPledgeModel *pledgeModel,
                                              NSArray <DMCarPledgeListModel *>*listModel))success
                              failed:(void(^)())failed;


/**
 车险分期债权详情
 */
- (void)getRequestCarInsuranceWithLoanId:(NSString *)loanId
                                 Success:(void(^)(DMCarPledgeModel *pledgeModel,
                                                  NSArray <DMCarPledgeListModel *>*listModel))success
                                  failed:(void(^)())failed;



/**
 验证登录密码
 */

- (void)checkPassWordWithPassword:(NSString *)password
                          Success:(void(^)())success
                            Faild:(void(^)(NSString *message))failed;


/**
 债转转让列表
 */
- (void)getCreditTransferStatus:(NSString *)status
                        Success:(void(^)(NSArray <DMCreditTransferModel *>*listModel))success
                         failed:(void(^)())failed;

/**
 发起债转
 */

- (void)startCreditTransferInvestId:(NSString *)investId
                            Success:(void(^)())success
                             failed:(void(^)())failed;

/**
 发起债转
 */

- (void)revokeCreditTransferId:(NSString *)transferId
                       Success:(void(^)())success
                        failed:(void(^)())failed;


/**
 合同
 */
- (void)getCreditContactWithLoadId:(NSString *)loanId
                           Success:(void(^)(NSString *loanUrl))success
                            failed:(void(^)())failed;


/**
 已转让合同
 */
- (void)getTransferContactWithLoadId:(NSString *)loanId
                             Success:(void(^)(NSArray *contractArray))success
                              failed:(void(^)())failed;


/**
 提现  保存订单

 @param cash 金额
 */
- (void)withDrawCash:(NSString *)cash branchName:(NSString *)brancheName
             Success:(void(^)(NSString *requestId))success
              failed:(void(^)())failed;


/**
 提现——请求form表单数据
 */
- (void)getFormDataWithRequestId:(NSString *)requestId
                         Success:(void(^)(NSString *argument))success
                          failed:(void(^)())failed;


/**
 设置交易密码
 */

- (void)replacePassWordSuccess:(void(^)(NSString *argument))success
                        failed:(void(^)())failed;
@end
