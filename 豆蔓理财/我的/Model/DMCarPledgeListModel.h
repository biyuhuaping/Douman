//
//  DMCarPledgeListModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/27.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCarPledgeListModel : NSObject

@property (nonatomic, copy) NSString * settleStatus;            // 0未还，1已还
@property (nonatomic, copy) NSString *dueDate;      //还款日期


@property (nonatomic) double amountInterest;   //利息
@property (nonatomic) BOOL isAheadSettle;       // 是否提前还款1提前还款，0为提前还款
@property (nonatomic, copy) NSString * isSettled;           //是否还款1已还，0未还
@property (nonatomic) double amountPrincipal;  //本金
@property (nonatomic) CGFloat repayAmount;      //还款金额



@end
