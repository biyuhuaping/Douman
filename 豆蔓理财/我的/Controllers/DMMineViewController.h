//
//  DMMineViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/11/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMBaseViewController.h"

@interface DMMineViewController : DMBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, assign)CGRect finalCellRect;

@end
