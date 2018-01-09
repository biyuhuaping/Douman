//
//  GZBuyListModel.h
//  豆蔓理财
//
//  Created by armada on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZBuyListModel : NSObject

/** 购买时间 */
@property(nonatomic, copy) NSString *buyTime;
/** 投资金额 */
@property(nonatomic, copy) NSString *investAmount;
/** 手机号码 */
@property(nonatomic, copy) NSString *mobile;

@end
