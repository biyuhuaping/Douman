//
//  DMWebViewController.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMBaseViewController.h"

@interface DMWebViewController : DMBaseViewController

@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *parameter;
/**
 是否要返回按钮 1 是 0 否
 */
@property (nonatomic, assign) BOOL root;


/**
 是否充值
 */
@property (nonatomic, copy) NSString * type;



/**
 是否提现界面
 */

@end
