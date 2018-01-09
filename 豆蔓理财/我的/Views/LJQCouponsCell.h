//
//  LJQCouponsCell.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GZCouponsViewController.h"

@class LJQCouponsModel;

typedef NS_ENUM(NSInteger, YHCouponCategory)
{
    YHCouponCategoryReturnCard, //返现卡
    YHCouponCategoryExperienceCard, //体验金
    YHCouponCategoryCoupon      //加息劵
};


@interface LJQCouponsCell : UITableViewCell

@property (nonatomic, assign)BOOL  isExpired;
@property (nonatomic, assign)BOOL isArrow;
@property (nonatomic, assign)YHCouponCategory  couponCategory;
@property (nonatomic, strong)LJQCouponsModel *model;
@property (nonatomic, strong)UILabel *durationLabel; //可用区间

@property (nonatomic,weak) id<LJQCouponCellPopDelegate> popDelegate;
@property (nonatomic,weak) id<LJQCouponCellDelegate> updateDelegate;

- (void)addGesture;
@end
