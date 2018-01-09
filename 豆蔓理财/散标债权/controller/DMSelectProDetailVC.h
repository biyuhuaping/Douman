//
//  DMSelectProDetailVC.h
//  豆蔓理财
//
//  Created by edz on 2017/7/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMBaseViewController.h"
@class DMHomeListModel;
@interface DMSelectProDetailVC : DMBaseViewController

@property (nonatomic, copy)NSString *assetID;
@property (nonatomic, strong)DMHomeListModel *productModel;

@end
