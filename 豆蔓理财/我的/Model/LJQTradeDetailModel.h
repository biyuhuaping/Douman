//
//  LJQTradeDetailModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQTradeDetailModel : NSObject

@property (nonatomic, assign)CGFloat amount;//交易金额
@property (nonatomic, copy)NSString *status;//状态(SUCCESSFUL成功，其他状态失败)
@property (nonatomic, copy)NSString *timeRecord;//交易时间
@property (nonatomic, copy)NSString *type;//交易类型
@property (nonatomic, copy)NSString *statusName;//状态显示
@property (nonatomic, copy)NSString *recordName;//交易项目

@end
