//
//  LJQUserInfoModel.h
//  豆蔓理财
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJQUserInfoModel : NSObject

@property (nonatomic, copy)NSString *name; //姓名
@property (nonatomic, copy)NSString *account;//银行账户
@property (nonatomic, copy)NSString *bank; //银行名称
@property (nonatomic, copy)NSString *mobile;//手机
@property (nonatomic, copy)NSString *idNumber; //身份证号

@property (nonatomic, copy)NSString *branch; //支行名称
@property (nonatomic, copy)NSString *associateNumber; //联行卡号

@property (nonatomic, copy)NSString *assignSignFlag; //是否债转签约
@property (nonatomic, copy)NSString *cardNbr; //徽商账号

@property (nonatomic, copy)NSString *investType; //风险测评类型
@property (nonatomic, copy)NSString *signFlag; //是否签约
@end
