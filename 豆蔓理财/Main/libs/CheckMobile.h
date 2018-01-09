//
//  CheckMobile.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckMobile : NSObject

+ (instancetype)manager;

//判断手机的合法性
- (BOOL)checkMobileNumber:(NSString *)checkStr;


@end
