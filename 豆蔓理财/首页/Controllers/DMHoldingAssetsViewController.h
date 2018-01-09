//
//  DMHoldingAssetsViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"
#import "DMHoldingAssetsModel.h"


@interface DMHoldingAssetsViewController : DMBaseViewController

@property (nonatomic, assign)BOOL isSevenBack; //是否是近7日回款页面
@property (nonatomic, copy)NSString *nameTittle; // 导航条标题

@property (nonatomic, assign)BOOL push;

@end
