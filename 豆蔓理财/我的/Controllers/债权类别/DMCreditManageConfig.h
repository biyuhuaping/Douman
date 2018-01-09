//
//  DMCreditManageConfig.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 债权管理类型

 - kCanTransfer: 可转让
 - kTransferIng: 转让中
 - kHadtransfer: 已转让
 */
typedef NS_ENUM(NSUInteger, CreditManageType) {
    kCanTransfer,
    kTransferIng,
    kHadtransfer,
};
