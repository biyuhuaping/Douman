//
//  GZDistributionLoanListModel.h
//  豆蔓理财
//
//  Created by armada on 2017/1/11.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZDistributionLoanListModel : NSObject

/** 债权金额 */
@property(nonatomic, copy) NSNumber *amount;
/** 购买标题 */
@property(nonatomic, copy) NSString *title;
/** 债权ID */
@property(nonatomic, copy) NSString *loanId;
/** 债权类型 */
@property(nonatomic, copy) NSString *guarantyStyle;

@end
