//
//  DMMyAccountHeaderView.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myAccountToWithDrawalBlock)();
typedef void(^myAccountToTopUpBlock)();

@class LJQMineModel;
@interface DMMyAccountHeaderView : UIView

@property (nonatomic, copy)myAccountToWithDrawalBlock myAccountToWithDrawal;

@property (nonatomic, copy)myAccountToTopUpBlock myAccountToTopUp;

@property (nonatomic, strong)LJQMineModel *mineModel;
@end
