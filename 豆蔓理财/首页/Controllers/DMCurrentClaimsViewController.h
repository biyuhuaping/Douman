//
//  DMCurrentClaimsViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/12/6.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"

@class GZLoanListModel;
@interface DMCurrentClaimsViewController : DMBaseViewController

@property (nonatomic , strong)GZLoanListModel *model;

@property (nonatomic ,copy)NSString *assetId;

@end
