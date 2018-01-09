//
//  DMLoginViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/11/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMBaseViewController.h"

@interface DMLoginViewController : DMBaseViewController


@property (nonatomic) BOOL isExpanded;  // 快速注册按钮布局用
@property (nonatomic) BOOL current;     //登录完成是否回到当前界面

@property (nonatomic, assign)BOOL mine;


@property (nonatomic, copy) void(^LoginSuccess)();


@end
