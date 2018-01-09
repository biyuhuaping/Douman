//
//  DMCreditTransferListModel.h
//  豆蔓理财
//
//  Created by mac on 2017/5/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCreditTransferListModel : NSObject

@property (nonatomic, copy)NSString *BIDAMOUNT; //债权成功转让金额
@property (nonatomic, assign)NSInteger CANCELABLE; //是否可撤销 1:是 0:否
@property (nonatomic, copy)NSString *CREDITAMOUNT; //债转总额
@property (nonatomic, copy)NSString *CREDITINTEREST; //债转利息
@property (nonatomic, copy)NSString *CREDITPRINCIPAL; //债权转让本金
@property (nonatomic, copy)NSString *HANDAMOUNT; //到手金额
@property (nonatomic, copy)NSString *ID; //债权转让记录id
@property (nonatomic, copy)NSString *TITLE; //债权标题
@property (nonatomic, copy)NSString *TIMEOPEN; //债转开始时间
@property (nonatomic, copy)NSString *TIMEFINISHED; //债转成交时间
@property (nonatomic, copy)NSString *LATELYDUEDATE; //最近回款日期
@property (nonatomic, copy)NSString *METHOD ;//还款方式
@property (nonatomic, copy)NSString *INTEREST_WAY; //计息方式
@property (nonatomic, copy)NSString *LOANID; //标的ID
@property (nonatomic, copy)NSString *RATE; //标的利率
@property (nonatomic, copy)NSString *INVESTAMOUNT; //投标金额
@property (nonatomic, copy)NSString *INTEREST_RATE; //标的贴息率
@property (nonatomic, copy)NSString *SURPLUSAMOUNT; //剩余可转让金额
@property (nonatomic, copy)NSString *SURPLUSDAYS; //剩余期限
@property (nonatomic, copy)NSString *PERCENT; //债权出让百分比

@end
