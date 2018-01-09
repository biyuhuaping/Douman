//
//  LJQOpenAccCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^confirmBlock)(UIButton *sender);
@interface LJQOpenAccCell : UITableViewCell

@property (nonatomic, strong)UILabel *cityLabel;
@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, copy)confirmBlock confirmBK;

@end
