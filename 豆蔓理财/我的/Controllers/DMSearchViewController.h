//
//  DMSearchViewController.h
//  豆蔓理财
//
//  Created by mac on 2017/5/23.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQBaseViewVC.h"

typedef void(^backAccountNameBlock)(NSString *string);
@interface DMSearchViewController : LJQBaseViewVC

@property (nonatomic, copy)backAccountNameBlock backAccountName;

@end
