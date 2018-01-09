//
//  GZLoanListModel.h
//  豆蔓理财
//
//  Created by armada on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZLoanListModel : NSObject

/** 债权金额 */
@property(nonatomic, strong) NSNumber *loanAmount;
/** 债权投资进度 */
@property(nonatomic, copy) NSString *loanBidPercent;
/** 购买标题 */
@property(nonatomic, copy) NSString *loanTitle;
/** 债权ID */
@property(nonatomic, copy) NSString *loanId;
/** 债权类型 */
@property(nonatomic, copy) NSString *guarantyStyle;
@property (nonatomic, copy)NSString *rate;// 利率
@property (nonatomic, copy)NSString *months;// 期限
@property (nonatomic, copy)NSString *method;// 还款方式
@property (nonatomic, copy)NSString *sourceOfAssets;// 资产来源
@property (nonatomic, copy)NSString *status;// 标的状态
@end
