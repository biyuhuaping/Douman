//
//  DMRobtEndListModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/25.
//  Copyright © 2017年 edz. All rights reserved.
//
//机器人往期列表
#import <Foundation/Foundation.h>

@interface DMRobtEndListModel : NSObject

@property (nonatomic, copy)NSString *disCountRate;//贴息率
@property (nonatomic, copy)NSString *ID;//机器人ID
@property (nonatomic, copy)NSString *status;//状态
@property (nonatomic, copy)NSString *robotCycle;//服务期限
@property (nonatomic, copy)NSString *endTime;//结束时间
@property (nonatomic, copy)NSString *maxRate;//最大年化利率
@property (nonatomic, copy)NSString *minRate;//最小年化利率
@property (nonatomic, copy)NSString *robotName;//名称
@property (nonatomic, copy)NSString *sunNum;//已加入次数
@property (nonatomic, copy)NSString *robotNumber; //服务编码

@end
