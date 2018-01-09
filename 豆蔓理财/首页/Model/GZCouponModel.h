//
//  GZInterestCouponModel.h
//  豆蔓理财
//
//  Created by armada on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZCouponModel : NSObject

/** 面值 */
@property(nonatomic, copy) NSString *perValue;
/** 最小投资金额 */
@property(nonatomic, copy) NSString *minimumInvest;
/** 优惠券类型 */
@property(nonatomic, copy) NSString *type;

@end
