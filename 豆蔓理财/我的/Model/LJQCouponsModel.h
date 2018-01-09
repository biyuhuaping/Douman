//
//  LJQCouponsModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQCouponsModel : NSObject

@property (nonatomic, copy)NSString *status; //状态(可使用PLACED，已使用USED，过期EXPIRED)
@property (nonatomic, copy)NSString *parValue;//面值
@property (nonatomic, copy)NSString *couponName;//优惠券名称
@property (nonatomic, copy)NSString *timeExpire; //过期时间
@property (nonatomic, copy)NSString *minimumInvest;//最小购买金额
@property (nonatomic, copy)NSString *type;//优惠券类型
@property (nonatomic, copy)NSString *couponId; //优惠券ID
@property (nonatomic, copy)NSString *minimumDuration; //最小期限
@property (nonatomic, copy)NSString *maximumDuration; //最大期限

@end
