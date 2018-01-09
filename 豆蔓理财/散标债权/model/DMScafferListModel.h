//
//  DMScafferListModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/5.
//  Copyright © 2017年 edz. All rights reserved.
//

//散标债权列表
#import <Foundation/Foundation.h>

@interface DMScafferListModel : NSObject

@property (nonatomic, copy)NSString *storeId; //产品id
@property (nonatomic, copy)NSString *bagId;//产品包id
@property (nonatomic, copy)NSString *loanId;//标的id
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *rate;//年化利率
@property (nonatomic, copy)NSString *interestRate;//贴息
@property (nonatomic, copy)NSString *months;//期限
@property (nonatomic, copy)NSString *amount;//借款金额
@property (nonatomic, copy)NSString *method;//还款方式
@property (nonatomic, copy)NSString *bidAmount;//认购金额
@property (nonatomic, copy)NSString *surplusAmount;//剩余金额
@property (nonatomic, copy)NSString *progressNum;//认购进度
@property (nonatomic, copy)NSString *methodName;//    还款方式中文
@property (nonatomic, copy)NSString *periods;//期数
@property (nonatomic, copy)NSString *maxPurchaseAmount;//最大认购金额
@property (nonatomic, copy)NSString *minPurchaseAmount;//最小认购金额
@property (nonatomic, copy)NSString *timeOut;//筹标时间
@property (nonatomic, copy)NSString *timeOpen;//开放时间
@property (nonatomic, copy)NSString *timeEnd;//筹标截止时间
@property (nonatomic, copy)NSString *status; //标的状态(OPENED立即出借,FINISHED已满标,SETTLED还款中,CLEARED已还款
@property (nonatomic, assign)int termUnit; //期限单位

@end
