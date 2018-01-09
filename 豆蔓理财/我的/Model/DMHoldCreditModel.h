//
//  DMHoldCreditModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHoldCreditModel : NSObject

@property (nonatomic, copy) NSString *loanNum;          //持有债权数量
@property (nonatomic, copy) NSString *totalHasAmount;   //债权总额
@property (nonatomic, copy) NSString *aheadSettleNum;   //提前还款
@property (nonatomic, copy) NSString *overdueNum;       //逾期还款
@property (nonatomic, copy) NSString *page;             //当前页
@property (nonatomic, copy) NSString *totalSize;        //总条数
@property (nonatomic, copy) NSString *totalPage;        //总页数

@end
