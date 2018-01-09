//
//  DMRobtOpenInfoModel.h
//  豆蔓理财
//
//  Created by edz on 2017/7/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRobtOpenInfoModel : NSObject

@property (nonatomic, copy)NSString *disCountRate;//小豆贴息
@property (nonatomic, copy)NSString *robotCycle;//服务期限
@property (nonatomic, copy)NSString *minPurchaseAmount;//最小认购金额
@property (nonatomic, copy)NSString *maxRate; //最大标的利率
@property (nonatomic, copy)NSString *minRate; //最小标的利率

@end
