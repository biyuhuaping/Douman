//
//  GZCouponsViewController.h
//  豆蔓理财
//
//  Created by armada on 2016/12/20.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"
@class LJQCouponsCell;
@class GZHomePageViewController;

@protocol LJQCouponCellDelegate <NSObject>

- (void)updateUserInterfaceWithCouponModel:(LJQCouponsModel *)model;

- (void)cancelCouponSelection;

@end

@protocol LJQCouponCellPopDelegate <NSObject>

- (void)popViewControllerWithAnimated:(BOOL)animiaton;

@end

@interface GZCouponsViewController : DMBaseViewController

@property(nonatomic,copy) NSString *assetId;

@property(nonatomic,weak) id<LJQCouponCellDelegate> delegate;

@end
