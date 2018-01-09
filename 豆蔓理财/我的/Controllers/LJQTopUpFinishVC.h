//
//  LJQTopUpFinishVC.h
//  豆蔓理财
//
//  Created by mac on 2017/5/9.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQBaseViewVC.h"

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeWithTopUpSuccess = 0,
    ActionTypeWithTopUpFaild,
    ActionTypeWithWithDrawalSuccess,
    ActionTypeWithWithDrawalFaild
};

@interface LJQTopUpFinishVC : LJQBaseViewVC

@property (nonatomic, assign)ActionType LJQActionType;
@property (nonatomic, copy)NSString *messageString;

@end
