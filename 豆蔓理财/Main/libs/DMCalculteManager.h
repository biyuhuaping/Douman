//
//  DMCalculteManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/18.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCalculteManager : NSObject


/**
 收益方式
 - kPayInterestByMonth: 按月付息
 - kEqualAmountInterest: 等额本息
 */
typedef NS_ENUM(NSUInteger, ProfitType) {
    kPayInterestByMonth,
    kEqualAmountInterest,
};


+ (instancetype)manager;


- (NSString *)calculatePorfitWithAmount:(NSString *)amount
                                   Rate:(NSString *)rate
                                   Type:(ProfitType)type
                                  Month:(NSString *)month;


@end
