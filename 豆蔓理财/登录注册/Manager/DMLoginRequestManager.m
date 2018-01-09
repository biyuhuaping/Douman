//
//  DMLoginRequestManager.m
//  豆蔓理财
//
//  Created by edz on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMLoginRequestManager.h"
#import "DMLoginUrlManager.h"
#import "HMTabBarViewController.h"

#import <UMMobClick/MobClick.h>

@interface DMLoginRequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation DMLoginRequestManager


+ (instancetype)manager{
    static DMLoginRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMLoginRequestManager alloc] init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"text/plain",@"application/json", nil];
    });
    return manager;
}



#pragma mark -----登录

- (void)loginWithUserName:(NSString *)userName PassWord:(NSString *)passWord Success:(void (^)())success Faild:(void (^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *url = [[DMLoginUrlManager manager] getUserLoginUrl];
        NSDictionary *parameter = @{@"username":userName,
                                    @"password":passWord,
                                    @"grant_type":@"password",
                                    @"client_id": @"client-id-for-mobile-dev",
                                    @"client_secret": @"client-secret-for-mobile-dev",
                                    @"source":@"APP",
                                    @"fromsource":@"1"};
        [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                NSString *realName = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"name"]];
                NSString *assignSignFlag = [NSString stringWithFormat:@"%@",responseObject[@"user"][@"assignSignFlag"]];
                NSString *cardNbr = [NSString stringWithFormat:@"%@",isOrEmpty(responseObject[@"user"][@"cardNbr"]) ? @"" : responseObject[@"user"][@"cardNbr"]];

                [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"userPassWord"];
                [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"phoneNumber"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"id"] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"user"][@"source"] forKey:@"source"];
                [[NSUserDefaults standardUserDefaults] setObject:assignSignFlag forKey:@"assignSignFlag"];
                [[NSUserDefaults standardUserDefaults] setObject:realName forKey:@"realName"];
                [[NSUserDefaults standardUserDefaults] setObject:cardNbr forKey:@"cardNbr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //统计用户
                [MobClick profileSignInWithPUID:responseObject[@"user"][@"id"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hidelogin" object:nil];
                success();
            }else{
                faild();
                ShowMessage(@"登录失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
            NSLog(@"Error: %@", error);
            NSLog(@"%@",task.currentRequest.HTTPBody);
            
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSDictionary *json = [self dictionaryWithJsonString:errResponse];
            
            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] hasSuffix:@"(400)"]) {
                NSString *errorStr = json[@"error_description"][@"result"];
                if ([errorStr isEqualToString:@"USER_DISABLED"]) {
                    ShowMessage(@"您的账号已被锁定，请联系网站客服！");
                }else if ([errorStr isEqualToString:@"FAILED"]){
                    ShowMessage(@"账号不存在或密码错误");
                }else if ([errorStr isEqualToString:@"TOO_MANY_ATTEMPT"]){
                    ShowMessage(@"登录失败次数过多，暂停使用");
                }else if ([errorStr isEqualToString:@"EMPLOYEE_DISABLED"]){
                    ShowMessage(@"员工禁用，请联系管理员");
                }return;
            } else if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] hasSuffix:@"(500)"]) {
                ShowMessage(@"服务器繁忙");
            } else {
                ShowMessage(@"登录失败");
            }
        }];
    }else {
        faild();
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }

}

// 注册发送验证码

- (void)msmCaptchaWithPhoneNumber:(NSString *)number Success:(void(^)())success Faild:(void(^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *str = [[DMLoginUrlManager manager] getsmsCaptchaWithPhoneNumber:number];
        [self.sessionManager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                success();
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            faild();
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }

}



#pragma mark ------  注册验证的手机号是否存在
- (void)checkMobileWithPhoneNumber:(NSString *)number Success:(void (^)())success Faild:(void (^)(NSString *))faild{
    
    if(JudgeStatusOfNetwork()) {
        NSString *url = [[DMLoginUrlManager manager] getCheckMobile];
        NSDictionary *parameter = @{@"mobile":number,@"fromsource":@"1"};
        [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                success();
            }else{
                NSArray *jsonArray = responseObject[@"error"];
                NSString *message = [jsonArray firstObject][@"message"];
                if ([message isEqualToString:@"MOBILE_EXISTS"]) {
                    faild(@"该手机号已经注册,请直接登录");
                }else{
                    faild(@"您输入的手机号不存在");
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}
// 注册

- (void)userRegisterWithPhoneNumber:(NSString *)number Captcha:(NSString *)captcha PassWord:(NSString *)passWord Success:(void (^)())success Faild:(void (^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *url = [[DMLoginUrlManager manager] getRegisterUrl];
        NSDictionary *parameter = @{@"mobile":number,@"mobile_captcha":captcha,@"channel":@"9",@"source":@"APP",@"password":passWord,@"fromsource":@"1"};
        
        [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                success();
            }else{
                faild();
                NSArray *jsonArray = responseObject[@"error"];
                NSString *message = [jsonArray firstObject][@"message"];
                if ([message isEqualToString:@"NAME_INVALID"]) {
                    ShowMessage (@"无效的用户姓名");
                }else if([message isEqualToString:@"MOBILE_INVALID"]){
                    ShowMessage (@"无效的手机号码");
                }else if ([message isEqualToString:@"INVITE_CODE_INVALID"]){
                    ShowMessage (@"注册码无效");
                }else if ([message isEqualToString:@"MOBILE_CAPTCHA_INVALID"]){
                    ShowMessage (@"短信验证码无效");
                }else if ([message isEqualToString:@"EMP_REFERRAL_NOT_EXISTS"]){
                    ShowMessage (@"员工唯一号不存在");
                }else if ([message isEqualToString:@"USERINVITECODE_INVALID"]){
                    ShowMessage (@"邀请码无效");
                }else{
                    ShowMessage (@"手机号已存在");
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }

    
    
}

#pragma mark --- 忘记密码发送验证码 & 修改密码发送验证码
- (void)findPassWordWithPhoneNumber:(NSString *)number Success:(void (^)())success Faild:(void (^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        NSString *url = [[DMLoginUrlManager manager] getsmsPassWordUrl:number];

        [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                success();
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            faild();
            NSLog(@"%@",error);
        }];
    }else {
        faild();
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

#pragma mark ----------重置密码
- (void)resetPassWordWithPhoneNumber:(NSString *)number Captcha:(NSString *)captcha NewPsd:(NSString *)password Success:(void (^)())success Faild:(void (^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        NSString *url = [[DMLoginUrlManager manager] resetPassWordUrl];

        NSDictionary *parameter = @{@"mobile":number,@"captcha":captcha,@"newPassword":password,@"fromsource":@"1"};
        [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                success();
            }else{
                faild();
                NSArray *jsonArray = responseObject[@"error"];
                NSString *message = [jsonArray firstObject][@"message"];
                if ([message isEqualToString:@"NAME_INVALID"]) {
                    ShowMessage (@"无效的用户姓名");
                }else if([message isEqualToString:@"MOBILE_INVALID"]){
                    ShowMessage (@"无效的手机号码");
                }else if ([message isEqualToString:@"INVITE_CODE_INVALID"]){
                    ShowMessage (@"注册码无效");
                }else if ([message isEqualToString:@"MOBILE_CAPTCHA_INVALID"]){
                    ShowMessage (@"短信验证码无效");
                }else if ([message isEqualToString:@"EMP_REFERRAL_NOT_EXISTS"]){
                    ShowMessage (@"员工唯一号不存在");
                }else if ([message isEqualToString:@"USERINVITECODE_INVALID"]){
                    ShowMessage (@"邀请码无效");
                }else if ([message isEqualToString:@"MOBILE_IS_BACK"]){
                    ShowMessage (@"借款用户修改登录密码请联系门店，谢谢！");
                }else{
                    ShowMessage (@"加载失败，请重试");
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)smsVoiceCaptchaWithPhoneNumber:(NSString *)number
                               Success:(void(^)())success
                                 Faild:(void(^)())faild{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *path = [NSString stringWithFormat:@"api/v2/users/smsVoiceCaptcha?mobile=%@",number];
        NSString *url = hostName(path);
        [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure) {
                ShowMessage(@"语音验证码发送成功");
            }else{
                ShowMessage(@"语音验证码发送失败");
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];

    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}


- (void)exit{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassWord"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"realName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cardNbr"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"source"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"assignSignFlag"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showview"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exit" object:nil];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

@end
