//
//  DMLoginUrlManager.h
//  豆蔓理财
//
//  Created by edz on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLoginUrlManager : NSObject

+ (instancetype)manager;


/**
 登录
 */
- (NSString *)getUserLoginUrl;



/// 校验手机号是否存在
- (NSString *)getCheckMobile;



//找回密码 重置密码

- (NSString *)getsmsPassWordUrl:(NSString *)number;

///注册发送短信验证码
- (NSString *)getsmsCaptchaWithPhoneNumber:(NSString *)number;


// 用户注册
- (NSString *)getRegisterUrl;

// 密码重置url
- (NSString *)resetPassWordUrl;






@end
