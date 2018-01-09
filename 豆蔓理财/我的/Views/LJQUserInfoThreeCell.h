//
//  LJQUserInfoThreeCell.h
//  豆蔓理财
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^openAccountBlock)(UIButton *sender);

@class LJQUserInfoModel;
@interface LJQUserInfoThreeCell : UITableViewCell

@property (nonatomic, assign)BOOL isOpenAccount;
@property (nonatomic, copy)openAccountBlock openAccount;

@property (nonatomic, strong)LJQUserInfoModel *infoModel;
@end
