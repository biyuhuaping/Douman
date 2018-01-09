//
//  LJQMineModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQMineModel : NSObject

@property (nonatomic, assign)CGFloat totalAmount; // 资产总额
@property (nonatomic, assign)CGFloat totalInvestAmount; //累计投资
@property (nonatomic, assign)CGFloat hasAmount; // 持有资产
@property (nonatomic, assign)CGFloat nextSevenDayAmount; //近7日待回款
@property (nonatomic, assign)CGFloat noSettleInterest; //未结收益
@property (nonatomic, assign)CGFloat availableAmount; //账户余额
@property (nonatomic, assign)CGFloat totalInterest; //累计收益
@property (nonatomic, assign)CGFloat frozenAmount; // 提现审核中金额
@end
