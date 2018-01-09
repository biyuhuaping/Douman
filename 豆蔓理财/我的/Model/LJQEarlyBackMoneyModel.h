//
//  LJQEarlyBackMoneyModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQEarlyBackMoneyModel : NSObject

@property (nonatomic, copy)NSString *periods;//所属产品
@property (nonatomic, copy)NSString *title;//债权标题
@property (nonatomic, copy)NSString *hasAmount;//持有金额
@property (nonatomic, copy)NSString *loanId;//债权ID

@property (nonatomic, copy)NSString *guarantyStyle; //债权类型

@end
