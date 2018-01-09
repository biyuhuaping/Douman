//
//  LJQMineRequestManager.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJQMineModel.h"
#import "LJQPlanformNoticeModel.h"
#import "LJQSystemMessageModel.h"
#import "LJQTradeDetailModel.h"
#import "LJQEarlyBackMoneyModel.h"
#import "LJQCouponsModel.h"
#import "LJQUserInfoModel.h"
#import "DMCreditTransferListModel.h"
#import "DMGetBranchNameModel.h"

@class DMKeepRecordModel;
@interface LJQMineRequestManager : NSObject

@property (nonatomic, strong)NSMutableDictionary *mutableDic;

+ (instancetype)RequestManager;

- (void)saveDic:(NSMutableDictionary *)dic;

- (NSDictionary *)readDic;

//我的账户
- (void)LJQRequestMineDataStringSuccessBlock:(void(^)(NSInteger index,LJQMineModel *mineModel))successBlock faildBlock:(void(^)())faildBlock;

//平台公告
- (void)LJQPlatformNoticeDataPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void(^)(NSArray *array,NSInteger index))successBlock faild:(void(^)())faild;

//系统消息
- (void)LJQSystemMessageDataPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void(^)(NSArray *array,NSInteger index))successBlock faild:(void(^)())faild;

//设置系统消息已读(包括全部已读)
- (void)LJQsetSystemMessageReadMessageID:(NSArray *)messageID SuccessBlock:(void(^)(NSString *string,NSInteger index))successBlock faild:(void(^)())faild;

//删除系统消息
- (void)LJQDeleteSystemMessageMsgID:(NSArray *)messageID SuccessBlock:(void(^)(NSString *string,NSInteger index))successBlock faild:(void(^)())faild;

//交易明细
- (void)LJQTradeDetailType:(NSString *)type startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSInteger)page size:(NSInteger)size successBlock:(void(^)(NSArray *array,CGFloat amount,NSInteger index,NSString *message))successBlock faild:(void(^)())faild;

//提前还款列表
- (void)LJQEarlyBackMoneypage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void(^)(NSInteger index,NSArray *array,NSString *message))successBlock faild:(void(^)())faild;

//优惠券
//状态(可使用PLACED，已使用USED，过期EXPIRED)
- (void)LJQCouponsDataStatus:(NSString *)status page:(NSInteger)page size:(NSInteger)size successBlock:(void(^)(NSInteger index,NSArray *array,NSString *message))successBlock faild:(void(^)())faild;

//账户信息
- (void)LJQUserInfoDataSourceSuccessBlock:(void(^)(NSInteger index,LJQUserInfoModel *model,NSString *message))successBlock faild:(void(^)())faild;

//实名认证
- (void)LJQRealNameIdNumber:(NSString *)idNumber name:(NSString *)name successBlock:(void(^)())scuuessblock faild:(void(^)(NSString *message,BOOL status))faild;

//提现
/**
 提现
 */
- (void)getCashlianlianpayWithUserId:(NSString *)userId PayPassWord:(NSString *)passWord Amount:(NSString *)amount successBlock:(void(^)())successBlock faild:(void(^)(NSString *message))faild;


//是否实名认证
- (void)LJQIsRealNamesuccessblock:(void(^)(NSString *result))successblock faild:(void(^)())faild;

//是否设置交易密码
- (void)LJQIsSetTradePassWordSuccessblock:(void(^)(NSString *result))successBlock faild:(void(^)())faild;

//设置交易密码
- (void)LJQSetTradePassWordLoginPd:(NSString *)loginPd tradePd:(NSString *)tradePd successBlock:(void(^)(NSInteger result,NSString *str))successBlock faild:(void(^)(NSString *message))faild;

//修改登录密码
- (void)LJQModifyLoginPassWord:(NSString *)passWord newPassWord:(NSString *)newPassWord successBlock:(void(^)())successBlock faild:(void(^)(NSString *result))faild;

//修改交易密码 || 交易密码发送验证码
- (void)LJQSendTradeSmsCaptchaMobile:(NSString *)mobile successBlock:(void(^)())successBlock faild:(void(^)(NSString *message))faild;

//修改交易密码 || 交易密码验证验证码
- (void)LJQCheckTradeSmsCaptchaSmsCaptcha:(NSString *)smsCaptcha successBlock:(void(^)())successBlock faild:(void(^)(NSString *message))faild;

//修改交易密码 || 交易密码重置
- (void)LJQResetPayMentPassWord:(NSString *)passWord smsCaptcha:(NSString *)smsCaptcha successBlock:(void(^)())successBlock faild:(void(^)())faild;

//银行卡信息
- (void)LJQ_MineBankCardInfoSuccessBlock:(void(^)())successBlock faild:(void(^)())faild;


//请求省份
- (void)requestProvinceCodes:(void(^)(NSArray *array))successBlock faild:(void(^)())faild;
//请求市
- (void)requestProvinceCityCodes:(NSString *)code successBlock:(void(^)(NSArray *array))successBlock faild:(void(^)())faild;


/**
 债权转让列表

 @param page 页数
 @param size 每页条数
 @param successBlcok 成功回调
 @param faild 失败
 */
- (void)creditTransferListPage:(NSInteger)page size:(NSInteger)size successBlock:(void(^)(NSArray *creditList))successBlcok faild:(void(^)())faild;


/**
 购买转让

 @param creditAssignId 债权转让id
 @param applyAmountPrincipal 承接本金
 @param applyAmountActual 实际承接金额
 @param successBlock 成功回调
 @param faild 失败回调
 */
- (void)creditTransferToBuyCreditAssignId:(NSString *)creditAssignId applyAmountPrincipal:(NSString *)applyAmountPrincipal applyAmountActual:(NSString *)applyAmountActual successBlock:(void(^)())successBlock faild:(void(^)(NSString *message))faild;


/**
 提现--保存订单

 @param amount 提现金额
 @param successBlock 成功回调
 @param faild 失败回调
 */
- (void)withDrawSavePayAmount:(NSString *)amount successBlock:(void(^)(NSString *string))successBlock faild:(void(^)(NSString *message))faild;


/**
 form表单数据

 @param requestId 订单id
 @param successBlock 成功回调
 @param faild 失败回调
 */
- (void)withDrawFormDataRequestId:(NSString *)requestId successBlock:(void(^)())successBlock faild:(void(^)())faild;

/**
 获取支行名称

 @param KeyString 关键字
 @param limitCount 条数
 @param successBlock 成功回调
 @param faildBlock 失败回调
 */
- (void)getBranchNameByKeyString:(NSString *)KeyString limitCount:(NSString *)limitCount successBlock:(void(^)(NSArray *listArr,NSString *status))successBlock faildBlock:(void(^)(NSString *message))faildBlock;

/**
 自动债权转让签约

 @param assignId 债权记录id
 @param loanId 标的id
 @param successBlock 成功回调
 @param faild 失败回调
 */
- (void)automicCreditTransgerAssignId:(NSString *)assignId loanId:(NSString *)loanId successBlock:(void(^)(NSString *parameter))successBlock faild:(void(^)())faild;

/**
 保全记录

 @param page 页码
 @param size 条数
 @param type 类型
 */
- (void)DM_GetPreservationRecordDataWithPage:(NSInteger)page size:(NSInteger)size type:(NSString *)type showView:(UIView *)showView successBlock:(void(^)(NSArray<DMKeepRecordModel *> *keepRecordList))successBlock faild:(void(^)())faild;
@end
