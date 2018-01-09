//
//  LJQBaseTableViewVC.h
//  豆蔓理财
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJQBaseTableViewVC : UITableViewController

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money;

- (NSString *)returnDecimalString:(NSString *)string;
@end
