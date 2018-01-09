//
//  GZBenefitDetailViewController.h
//  豆蔓理财
//
//  Created by armada on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMBaseViewController.h"

#import "GZBenefitDetailTableViewCell.h"

@interface GZBenefitDetailViewController : DMBaseViewController

/** 预计购买金额 */
@property(nonatomic, copy) NSString *expectedPurchasedAmount;
/** 预期收益 */
@property(nonatomic, copy) NSString *expectedBenefit;
/** 月结本息 */
@property(nonatomic, copy) NSString *monthlyWithdraw;
/** 产品期限 */
@property(nonatomic, assign) NSInteger months;

@end
