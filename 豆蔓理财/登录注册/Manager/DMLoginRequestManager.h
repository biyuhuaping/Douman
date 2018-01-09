//
//  DMLoginRequestManager.h
//  豆蔓理财
//
//  Created by edz on 2016/12/22.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLoginRequestManager : NSObject

typedef void (^successBlock)(BOOL result, NSDictionary *dict);
//typedef void (^failureBlock)(BOOL result,NSError* err);


//单例
+(instancetype)manager;

//登录


- (void)loginWithUserName:(NSString *)userName
                 PassWord:(NSString *)passWord
                  Success:(void(^)())success
                    Faild:(void(^)())faild;


//注册验证的手机号是否存在
-(void)checkMobileWithPhoneNumber:(NSString*)number
                          Success:(void(^)())successBlock
                            Faild:(void(^)(NSString *message))failureBlock;

// 注册发送验证码
- (void)msmCaptchaWithPhoneNumber:(NSString *)number
                          Success:(void(^)())success
                            Faild:(void(^)())faild;

// 注册
- (void)userRegisterWithPhoneNumber:(NSString *)number
                            Captcha:(NSString *)captcha
                           PassWord:(NSString *)passWord
                            Success:(void(^)())success
                              Faild:(void(^)())faild;

// 忘记密码发送验证码 & 修改密码发送验证码
- (void)findPassWordWithPhoneNumber:(NSString *)number
                            Success:(void(^)())success
                              Faild:(void(^)())faild;

// 重置密码
- (void)resetPassWordWithPhoneNumber:(NSString *)number
                             Captcha:(NSString *)captcha
                              NewPsd:(NSString *)password
                             Success:(void (^)())success
                               Faild:(void (^)())faild;

// 语音验证码
- (void)smsVoiceCaptchaWithPhoneNumber:(NSString *)number
                               Success:(void(^)())success
                                 Faild:(void(^)())faild;


/**
 退出
 */
- (void)exit;
@end
