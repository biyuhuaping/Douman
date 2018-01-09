//
//  GZHomePageRequestManager.h
//  豆蔓理财
//
//  Created by armada on 2016/12/17.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GZProductListModel.h"
#import "GZCouponModel.h"
#import "GZBuyListModel.h"
#import "GZLoanListModel.h"
#import "GZAssetInfoModel.h"
#import "GZLoanListModel.h"
#import "GZDistributionLoanListModel.h"
#import "LJQCouponsModel.h"
#import "DMHoldingAssetsModel.h"
#import "DMSettledAssetsModel.h"

@interface GZHomePageRequestManager : NSObject

typedef void (^failureBlock)(NSError* err);

/**
 * 请求单例
 */
+(instancetype)defaultManager;


/**
 * @brief 新手专享
 * @param userId 用户ID
 * @param accessToken 用户登录token
 */
- (void)requestForHomePageIsInvestWithUserId:(NSString *)userId
                                 accessToken:(NSString *)accessToken
                                successBlock:(void(^)(
                                                      BOOL result,
                                                      NSString *message,
                                                      NSNumber *isInvested
                                                      )
                                              )successBlock
                                failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页基本数据
 * @param type 产品类型
 * @param userId 用户ID
 */
- (void)requestForHomePageBasicDataWithType:(NSString *)type
                                     userId:(NSString *)userId
                               successBlock:(void(^)(
                                                     BOOL result,
                                                     NSString *message,
                                                     NSString *platformInvestTotalAmount,
                                                     NSNumber *platformTotalnvestor,
                                                     NSString *totalAmount,
                                                     NSString *hasAmount
                                                     )
                                             )successBlock
                               failureBlock:(failureBlock)failureBlock;
/**
 * @brief 首页产品
 * @param month 产品对应的月份
 * @param clientType 客户类型
 */
- (void)requestForHomePageProductWithMonth:(NSString *)month
                                    clientType:(NSString *)clientType
                               successBlock:(void(^)(
                                                     BOOL result,
                                                     NSString *message,
                                                     NSArray<GZProductListModel *> *productList
                                                     )
                                             )successBlock
                               failureBlock:(failureBlock)failureBlock;
/**
 * @brief 首页用户可用余额
 * @param userId 用户id
 */
- (void)requestForHomePageUserAvailableAmountWithUserId:(NSString *)userId
                                            accessToken:(NSString*)accessToken
                                           successBlock:(void(^)(
                                                                 BOOL result,
                                                                 NSString *message,
                                                                 NSString *availableAmount
                                                                )
                                                         )successBlock
                                           failureBlock:(failureBlock)failureBlock;
/**
 * @brief 首页产品可用优惠券
 * @param userId 用户id
 * @param accessToken 用户登录token
 * @param assetId 产品id
 */
- (void)requestForHomePageCouponListWithUserId:(NSString *)userId
                                   accessToken:(NSString *)accessToken
                                       assetId:(NSString *)assetId
                                  successBlock:(void(^)(
                                                        BOOL result,
                                                        NSString *message,
                                                        NSArray<LJQCouponsModel *> *couponList
                                                        )
                                                )successBlock
                                          failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页产品的购买列表
 * @param assetId 产品ID
 * @param pageNo 当前页（从1开始）
 * @param pageSize 一页的数量
 */
- (void)requestForHomePageBuyListWithAssetID:(NSString *)assetId
                                      pageNo:(int)pageNo
                                    pageSize:(int)pageSize
                                successBlock:(void(^)(
                                                      BOOL result,
                                                      NSString *message,
                                                      NSString *periods,
                                                      NSArray<GZBuyListModel *> *buyList,
                                                      NSString *totalSize
                                                      )
                                              )successBlock
                                failureBlock:(failureBlock)failureBlock;
/**
 * @brief 首页产品的债权列表
 * @param assetId 产品ID
 */
- (void)requestForHomePageLoanListWithAssetID:(NSString *)assetId
                                successBlock:(void(^)(
                                                      BOOL result,
                                                      NSString *message,
                                                      NSString *sourceOfAssets,
                                                      NSString *periods,
                                                      NSString *guarantStyle,
                                                      NSString *totalAmount,
                                                      NSString *bidNumber,
                                                      NSString *totalBidpercent,
                                                      NSArray<GZLoanListModel *> *loanList,
                                                      NSNumber *userHasLoan
                                                      )
                                              )successBlock
                                failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页产品的债权基础信息
 * @param assetId 产品ID
 */
- (void)requestForHomePageLoansInfoOfAssetWithAssetID:(NSString *)assetId
                                               UserID:(NSString *)userId
                                         successBlock:(void(^)(
                                                               BOOL result,
                                                               NSString *message,
                                                               NSString *sourceOfAssets,
                                                               NSString *periods,
                                                               NSString *guarantStyle,
                                                               NSString *totalAmount,
                                                               NSString *bidNumber,
                                                               NSString *totalBidpercent,
                                                               NSNumber *userHasLoan,
                                                               NSString *assetId,
                                                               NSString *guarant
                                                               )
                                                       )successBlock
                                         failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页产品的购买列表
 * @param assetId  page  size
 */

- (void)requestForHomePagegetLoanListWithAssetID:(NSString *)assetId
                                            Page:(NSString *)page
                                            Size:(NSString *)size
                                    successBlock:(void(^)(
                                                          BOOL result,
                                                          NSString *message,
                                                          NSArray<GZLoanListModel *> *loanList,
                                                          NSString *assetId
                                                  ))successBlock
                                    failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页往期产品列表
 * @param month 产品月份
 * @param clientType 客户端类型
 * @param type 产品类型
 * @param pageNo 当前页码
 * @param pageSize 一页几条
 */
- (void)requestForHomePageLoanListWithMonth:(NSString *)month
                                 clientType:(NSString *)clientType
                                       type:(NSString *)type
                                     pageNo:(NSString *)pageNo
                                   pageSize:(NSString *)pageSize
                                 successBlock:(void(^)(
                                                       BOOL result,
                                                       NSString *message,
                                                       NSArray<GZProductListModel*> *productList,
                                                       NSString *totalSize
                                                       )
                                               )successBlock
                                 failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页往期产品详情
 * @param assetId 产品ID
 */
- (void)requestForHomePageAssetInfoWithAssetID:(NSString *)assetId
                                 successBlock:(void(^)(
                                                       BOOL result,
                                                       NSString *message,
                                                       GZAssetInfoModel *assetInfoArr
                                                       )
                                               )successBlock
                                 failureBlock:(failureBlock)failureBlock;

/**
 * @brief 认购
 * @param userId 用户ID
 * @param accessToken accessToken
 * @param assetId 产品ID
 * @param investAmount 投资金额
 * @param couponId 优惠券id
 * @param source 来源
 */
- (void)requestForPurchasingAssetsWithUserId:(NSString *)userId
                                 accessToken:(NSString *)accessToken
                                     assetId:(NSString *)assetId
                                investAmount:(NSString *)investAmount
                                    couponId:(NSString *)couponId
                                      source:(NSString *)source
                                successBlock:(void(^)(
                                                      BOOL status,
                                                      NSArray *err,
                                                      NSNumber *interest,
                                                      NSString *bidResult,
                                                      NSNumber *investAmount,
                                                      NSString *storeId
                                                    )
                                              )sucessBlock
                                failureBlock:(failureBlock)failureBlock;

/**
 * @brief 首页购买成功页面
 * @param assetBuyRecordId 购买记录ID
 * @param accessToken accessToken
 */
- (void)requestForHomePageLoanInfoWithAssetBuyId:(NSString *)assetBuyRecordId
                                     accessToken:(NSString *)accessToken
                                  successBlock:(void(^)(
                                                        BOOL result,
                                                        NSString *message,
                                                        NSNumber *paymentInterest,
                                                        NSNumber *loanNumber,
                                                        NSArray<GZDistributionLoanListModel *> *loanList,
                                                        NSString *repaymentMethod,
                                                        NSString *investAmount
                                                        )
                                                )successBlock
                                  failureBlock:(failureBlock)failureBlock;

/**
 * @brief 持有资产页面
 * @param userID 用户ID
 * @param repaymethod 还款方式
 * @param ordertype 订单类型
 * @param months 月份
 * @param page 页数
 * @param size 每页显示的数据
 */
- (void)requestForHomePageuserAccountWithUserId:(NSString *)userID
                                    repaymethod:(NSString *)repaymethod
                                      orderType:(NSString *)ordertype
                                         months:(NSString *)months
                                           page:(NSString *)page
                                           size:(NSString *)size
                                    isSevenBack:(BOOL)isSevenBack
                                   access_token:(NSString *)access_token
                                   successBlock:(void(^)(NSArray *arr,
                                                 NSString *str))sccessBlock
                                   failureBlock:(void(^)())failureBlock;

/**
 * @brief 是否自动投标签约
 * @param userId 用户ID
 */

- (void)requestStatusOfAutoSignWithUserId:(NSString *)userId
                           successBlock:(void(^)(
                                                 NSString *status,
                                                 NSString *msg))successBlock
                       failureBlock:(void(^)(NSError *err, NSString *msg))failureBlock;

/**
 * @brief 表单信息
 * @param userId 用户ID
 */
- (void)requestForFormInfoWithUserId:(NSString *)userId
                        successBlock:(void(^)(
                                              NSMutableDictionary *infoDict
                                              )
                                      )successBlock
                        failureBlock:(void(^)(NSError *err, NSString *msg))failureBlock;


/**
 * @brief  已结清产品列表
 */

- (void)requestForSettledAssetesWithUserId:(NSString *)userId
                               repayMethod:(NSString *)repayMethod
                                amountType:(NSString *)amountType
                                    months:(NSString *)months
                                      page:(NSString *)page
                                      size:(NSString *)size
                              access_token:(NSString *)access_token
                              successBlock:(void(^)(NSArray *arr,
                                                    NSString *str))sccessBlock
                              failureBlock:(void(^)())failureBlock;

/**
 * @brief  持有详情
 */

- (void)requestForHolfDetailsUserId:(NSString *)userId
                           recordId:(NSString *)assetId
                       access_token:(NSString *)access_token
                       successBlock:(void(^)(NSArray *arr,
                                             NSString *totalInterest,
                                             NSString *noSettleInterest,
                                             NSString *settleInterest,
                                             NSString *noSettlePrincipal,
                                             NSString *settlePrincipal,
                                             NSString *repaymentMethod,
                                             NSString *periods,
                                             NSString *investAmount,
                                             NSString *rate,
                                             NSString *monthSettleAmount,
                                             NSString *settlePeriod,
                                             NSString *noSettleAmount,
                                             NSString *buyTime,
                                             NSString *interestTime,
                                             NSString *assetId,
                                             NSString *termUnit
                                             
                                             ))sccessBlock
                       failureBlock:(void(^)())failureBlock;



- (void)requestForHolfDetailsUserId:(NSString *)userId
                       WithrecordId:(NSString *)recordId
                       successBlock:(void(^)(NSArray *dataArr))sccessBlock
                       failureBlock:(void(^)())failureBlock;





/**
 * @brief 已结清页面已结金额
 */

- (void)requestForSettledDetailsUserId:(NSString *)userId
                           repayMethod:(NSString *)repayMethod
                            amountType:(NSString *)amountType
                                months:(NSString *)months
                          access_token:(NSString *)access_token
                          successBlock:(void(^)(NSNumber *settleAmount))sccessBlock
                          failureBlock:(void(^)())failureBlock;

/**
 * @brief 已结清产品详情：
 */
- (void)requestForSettledDetailsUserId:(NSString *)userId
                           recordId:(NSString *)recordId
                       access_token:(NSString *)access_token
                       successBlock:(void(^)(NSArray *arr,
                                             NSString *totalInterest,
                                             NSString *noSettleInterest,
                                             NSString *settleInterest,
                                             NSString *buyTime,
                                             NSString *interestTime,
                                             NSString *amountPrincipal
                                             
                                             ))sccessBlock
                       failureBlock:(void(^)())failureBlock;


- (void)requestForInformationWithContractId:(NSString *)contractId
                               successBlock:(void(^)(
                                                     
                                                     NSString *url
                                                     
                                                     ))sccessBlock
                               failureBlock:(void(^)())failureBlock;






@end
