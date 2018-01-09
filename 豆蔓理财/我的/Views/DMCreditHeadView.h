//
//  DMCreditHeadView.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/9.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCreditDetailController.h"
@class DMCarPledgeModel;


@protocol DMCreditHeadViewDelegate <NSObject>

/**
 跳转合同
 */
- (void)getContract;

- (void)selectSegmentWithIndex:(NSInteger)index;

@end

@interface DMCreditHeadView : UIView


@property (nonatomic, weak) id<DMCreditHeadViewDelegate>delegate;


- (instancetype)initWithFrame:(CGRect)frame Type:(CreditType)type;


@property (nonatomic, strong) DMCarPledgeModel *infoModel;

@property (nonatomic, strong) NSArray *icars;

@end
