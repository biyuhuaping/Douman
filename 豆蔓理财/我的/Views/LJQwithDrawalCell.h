//
//  LJQwithDrawalCell.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

typedef void(^withDrawalBlock)(UIButton *sender,NSString *string,NSString *branchName);
typedef void(^allWithDrawalBlock)(NSString *string);
typedef void(^forgetOpenAccountNameBlock)();
@class LJQUserInfoModel;
@interface LJQwithDrawalCell : UITableViewCell

@property (nonatomic, strong)UILabel *amountLabel;

@property (nonatomic, strong)CustomTextField *textField;
@property (nonatomic, strong)UIButton *allBtn;

@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;

@property (nonatomic, strong)UILabel *accountTextField;

@property (nonatomic, copy)withDrawalBlock withDrawalBK;
@property (nonatomic, copy)allWithDrawalBlock allWithDrawalBK;
@property (nonatomic, copy)forgetOpenAccountNameBlock forgetOpenAccountName;

@property (nonatomic, strong)LJQUserInfoModel *model;

@end
