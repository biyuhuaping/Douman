//
//  DMScafferBuyModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMScafferBuySubModel;
@interface DMScafferBuyModel : NSObject

@property (nonatomic, copy)NSString *interest; //收益
@property (nonatomic, copy)NSString *bidResult; //认购结果
@property (nonatomic, copy)NSString *investAmount; //投资金额
@property (nonatomic, copy)NSString *storeId; //认购ID
@property (nonatomic, strong)NSArray *annualCards; //周年庆许愿卡

@end
