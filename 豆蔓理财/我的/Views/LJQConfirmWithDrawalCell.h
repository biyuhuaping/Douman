//
//  LJQConfirmWithDrawalCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

typedef void(^forgetPassWordBlock)(UIButton *sender);
@interface LJQConfirmWithDrawalCell : UITableViewCell

@property (nonatomic, strong)UILabel *amountLabel;

@property (nonatomic, strong)CustomTextField *textField;

@property (nonatomic, copy)forgetPassWordBlock forgetPW;

@end
