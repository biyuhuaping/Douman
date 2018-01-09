//
//  DMSettledDetailsViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"
#import "DMSettledAssetsModel.h"

@interface DMSettledDetailsViewController : DMBaseViewController

@property (nonatomic ,strong)DMSettledAssetsModel *model;

@property (nonatomic ,strong)NSString *recordId;

@end
