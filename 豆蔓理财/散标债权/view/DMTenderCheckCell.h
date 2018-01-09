//
//  DMTenderCheckCell.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTenderCheckCell : UITableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)createWithArryay:(NSMutableArray *)array;

@end
