//
//  DMSettingManager.h
//  豆蔓理财
//
//  Created by edz on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSettingManager : NSObject


+ (instancetype)RequestManager;

-(void)requestForSettinguserId:(NSString *)userId
                      bankName:(NSString *)bankName
                      bankCard:(NSString *)bankCard
                         phone:(NSString *)phone
                      province:(NSString *)province
                          city:(NSString *)city
                    branchName:(NSString *)branchName
                     Success:(void(^)(NSString *externalRefNumber,NSString*token,BOOL sure))success
                       Faild:(void(^)())faild;

- (void)requestForbandCard:(NSString *)bandcard
                   Success:(void(^)(NSString *))success
                     Faild:(void(^)(NSString *))faild;



- (void)requestForSettinguserId:(NSString *)userId
                       bankName:(NSString *)bankName
                       bankCard:(NSString *)bankCard
                          phone:(NSString *)phone
                       province:(NSString *)province
                           city:(NSString *)city
                     branchName:(NSString *)branchName
                      validCode:(NSString *)validCode
                          token:(NSString *)token
              externalRefNumber:(NSString *)externalRefNumber
                        Success:(void (^)(BOOL sure))success
                          Faild:(void (^)())faild;



////////////发送短信

- (void)requestForSendMessage:(NSString *)bankMobile
                      smsType:(NSString *)smsType
                      Success:(void (^)())success
                        Faild:(void (^)())faild;

///////新的实名绑卡
- (void)requestForSettinguserId:(NSString *)userId
                       bankName:(NSString *)bankName
                       bankCard:(NSString *)bankCard
                          phone:(NSString *)phone
                       province:(NSString *)province
                           city:(NSString *)city
                     branchName:(NSString *)branchName
                      smsCaptcha:(NSString *)smsCaptcha
                          token:(NSString *)token
                        smsType:(NSString *)smsType
                           name:(NSString *)name
                       idNumber:(NSString *)idNumber
                        Success:(void (^)(BOOL sure))success
                          Faild:(void (^)(BOOL sure))faild;


//////////新的设置交易密码
-(void)requestForSettingTransactionPasswordSuccess:(void (^)(BOOL sure))success
                                             Faild:(void (^)(NSString *message))faild;

//////////新的是否绑卡
- (void)requestForTieOnCardSuccess:(void (^)(BOOL sure))success
                        Faild:(void (^)())faild;

//////////新的是否实名
- (void)requestForRealNameSuccess:(void (^)(NSString *string))success
                                 Faild:(void (^)(BOOL sure))faild;

/////////微商绑卡接口
- (void)requestForhuishangBankTieOnCarduserId:(NSString *)userId
                                         name:(NSString *)name
                                     idNumber:(NSString *)idNumber
                                     bankName:(NSString *)bankName
                                   bankCardNo:(NSString *)bankCardNo
                                       mobile:(NSString *)mobile
                                      Success:(void (^)(BOOL sure))success
                                        Faild:(void (^)(BOOL sure))faild;
/////////微商开户接口
- (void)requestForhuishangBankOpenAnAccountuserId:(NSString *)userId
                                             name:(NSString *)name
                                         idNumber:(NSString *)idNumber
                                         bankName:(NSString *)bankName
                                       bankCardNo:(NSString *)bankCardNo
                                           mobile:(NSString *)mobile
                                          Success:(void (^)(BOOL sure))success
                                            Faild:(void (^)(BOOL sure))faild;




@end
