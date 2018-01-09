//
//  DMRobtDetailModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/25.
//  Copyright © 2017年 edz. All rights reserved.
//
//机器人预约列表
#import <Foundation/Foundation.h>

@interface DMRobtDetailModel : NSObject

@property (nonatomic, copy)NSString *ID;//预约id
@property (nonatomic, copy)NSString *orderAmount;//预约金额
@property (nonatomic, copy)NSString *mobile;//用户
@property (nonatomic, copy)NSString *timeCreated;//预约时间

@end
