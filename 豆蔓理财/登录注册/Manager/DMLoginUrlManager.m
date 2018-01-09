//
//  DMLoginUrlManager.m
//  豆蔓理财
//
//  Created by edz on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMLoginUrlManager.h"

@implementation DMLoginUrlManager

+ (instancetype)manager{
    static DMLoginUrlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMLoginUrlManager alloc] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static DMLoginUrlManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}


// 获取登录url

- (NSString *)getUserLoginUrl{
    return [NSString stringWithFormat:@"%@api/v2/token",mainUrl];
}

//注册发送验证码
- (NSString *)getsmsCaptchaWithPhoneNumber:(NSString *)number{
    NSString *pathName = [NSString stringWithFormat:@"api/v2/users/smsCaptcha?mobile=%@",number];
    return hostName(pathName);
}

//注册验证的手机号是否存在
- (NSString *)getCheckMobile{
    return [NSString stringWithFormat:@"%@api/v2/users/check/mobile",mainUrl];
}

//注册
- (NSString *)getRegisterUrl{
    return [NSString stringWithFormat:@"%@api/v2/users/register",mainUrl];
}

//忘记密码发送验证码 & 修改密码发送验证码
- (NSString *)getsmsPassWordUrl:(NSString *)number{
    NSString *pathName = [NSString stringWithFormat:@"api/v2/users/smsCaptcha/changePwd?mobile=%@",number];
    return hostName(pathName);
}

//重置密码
- (NSString *)resetPassWordUrl{
    return [NSString stringWithFormat:@"%@api/v2/auth/reset_password/password",mainUrl];
}


@end
