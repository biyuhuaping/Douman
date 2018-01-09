//
//  DMSettingManager.m
//  豆蔓理财
//
//  Created by edz on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettingManager.h"

@implementation DMSettingManager


+ (instancetype)RequestManager {
    static DMSettingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}



//绑卡第一步

- (void)requestForSettinguserId:(NSString *)userId
                       bankName:(NSString *)bankName
                       bankCard:(NSString *)bankCard
                          phone:(NSString *)phone
                       province:(NSString *)province
                           city:(NSString *)city
                     branchName:(NSString *)branchName
                        Success:(void(^)(NSString *externalRefNumber,NSString*token,BOOL sure))success
                          Faild:(void(^)())faild {
    
    NSString *url =  [NSString stringWithFormat:@"%@api/v2/kaAndKl/bindCardByKQ?access_token=%@",mainUrl,AccessToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"-------bankCard 银行卡号----------%@",bankCard);
    NSDictionary *parameter = @{@"userId":userId,@"bankName":bankName,@"bankCard":bankCard,@"phone":phone,@"province":province,@"city":city,@"branchName":branchName,@"fromsource":@"1"};
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        
        NSInteger isTure = [json[@"success"] integerValue];
        if (isTure) {
            
            BOOL sure = YES;
            //ShowMessage(@"绑卡成功");
            NSString *externalRefNumber = json[@"data"][@"externalRefNumber"];
            NSString *token = json [@"data"][@"token"];
            success(externalRefNumber,token,sure);
        }else{
            BOOL sure = NO;
            NSArray *arr = json[@"error"];
            NSString *str = arr[0][@"message"];
            success(nil,nil,sure);
            ShowMessage(str);
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            //NSLog(@"请求失败");
        faild();
    }];

    
}


///判断银行卡是哪个银行

- (void)requestForbandCard:(NSString *)bandcard
                   Success:(void(^)(NSString *))success
                     Faild:(void(^)(NSString *))faild {
    
    NSString *pathName = [NSString stringWithFormat:@"api/v2/lianlianpay/findBankName?access_token=%@&userId=%@&bankCode=%@",AccessToken,USER_ID,bandcard];
    NSString *url = hostName(pathName);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger isTure = [json[@"result"] integerValue];
        
        NSLog(@"=========%@",json);
        
        if (isTure == 1) {
            success(json[@"message"]);
            
        }else{
            
            faild(json[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

///发送验证码
- (void)requestForSendMessage:(NSString *)bankMobile
                      smsType:(NSString *)smsType
                      Success:(void (^)())success
                        Faild:(void (^)())faild{
    
    NSString *url = [NSString stringWithFormat:@"%@api/v2/smsMessage/bankMobile?access_token=%@",mainUrl,AccessToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"smsType":@"CREDITMARKET_CAPTCHA",@"bankMobile":bankMobile,@"fromsource":@"1"};
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger isTure = [json[@"success"] integerValue];
        if (isTure) {
            ShowMessage(@"发送成功");
        }else{
            
            BOOL sure = NO;
            ShowMessage(@"发送失败");
            NSArray *arr = json[@"error"];
            NSString *str = arr[0][@"message"];
            success(nil,nil,sure);
            ShowMessage(str);
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        //NSLog(@"请求失败");
        faild();
    }];
}



///绑卡第二部

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
                          Faild:(void (^)())faild {
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@api/v2/kaAndKl/checkValidCodeByKQ?access_token=%@",mainUrl,AccessToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"userId":userId,@"bankName":bankName,@"bankCard":bankCard,@"phone":phone,@"province":province,@"city":city,@"branchName":branchName,@"validCode":validCode,@"externalRefNumber":externalRefNumber,@"token":token,@"fromsource":@"1"};
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger isTure = [json[@"success"] integerValue];
        if (isTure) {
            
            NSLog(@"绑卡成功");
            BOOL sure = YES;
            
            success(sure);
            
        }else{
            
            BOOL sure = NO;
            success(sure);
            
            NSLog(@"绑卡失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];


}

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
                          Faild:(void (^)(BOOL sure))faild{
    NSString *url = [NSString stringWithFormat:@"%@api/v2/kaAndKl/realNameBindCardByKaoLa?access_token=%@",mainUrl,AccessToken];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameter = @{@"userId":userId,@"bankName":bankName,@"bankCard":bankCard,@"phone":phone,@"province":province,@"city":city,@"branchName":branchName,@"smsCaptcha":smsCaptcha,@"smsType":smsType,@"name":name,@"idNumber":idNumber,@"fromsource":@"1"};
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger isTure = [json[@"success"] integerValue];
        if (isTure) {
            success(YES);
        }else{
            faild(NO);
            NSArray *arr = json[@"error"];
            NSString *str = arr[0][@"message"];
            ShowMessage(str);
        }
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        faild(NO);
        NSLog(@"%@",error);
    }];

}

//////////新的设置交易密码
- (void)requestForSettingTransactionPasswordSuccess:(void (^)(BOOL sure))success
                                             Faild:(void (^)(NSString *message))faild{
    
    if (JudgeStatusOfNetwork()) {
    
        NSString *pathName = [NSString stringWithFormat:@"api/sumpay/account/setPayPwd/%@?source=APP",USER_ID];
        NSString *url = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            NSInteger isTure = [json[@"result"] integerValue];
            
            NSLog(@"=========%@",json);
            
            if (isTure == 1) {
                success(YES);
                
            }else{
                
                faild(json[@"message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            
        }];
        
    } else {
        ShowMessage(dataInfoMessage);
    }
}

//////////新的是否绑卡
- (void)requestForTieOnCardSuccess:(void (^)(BOOL sure))success
                            Faild:(void (^)())faild{
    
    if (JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"api/sumpay/account/isBindCard/%@?access_token=%@",USER_ID,AccessToken];
        NSString *url = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"true"]) {
                success(YES);
            } else {
                success(NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            faild();
            NSLog(@"%@",error);
        }];
    } else {
        faild();
        ShowMessage(dataInfoMessage);
    }

    
}

//////////新的是否实名
- (void)requestForRealNameSuccess:(void (^)(NSString *string))success
                                 Faild:(void (^)(BOOL sure))faild{
    
    
    if (JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"api/v2/user/%@/isAuthenticate?access_token=%@",USER_ID,AccessToken];
        NSString *urlString = hostName(pathName);
        NSLog(@"是否实名认证is %@",urlString);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            success(string);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            ShowMessage(@"是否实名认证请求失败");
            
        }];
        
    }else {
        ShowMessage(dataInfoMessage);
    }

}

/////////微商绑卡接口
- (void)requestForhuishangBankTieOnCarduserId:(NSString *)userId
                                         name:(NSString *)name
                                     idNumber:(NSString *)idNumber
                                     bankName:(NSString *)bankName
                                   bankCardNo:(NSString *)bankCardNo
                                       mobile:(NSString *)mobile
                                      Success:(void (^)(BOOL sure))success
                                        Faild:(void (^)(BOOL sure))faild{
    
    if (JudgeStatusOfNetwork()) {
        NSString *url =  [NSString stringWithFormat:@"%@api/sumpay/sumpayCard/signCardBinding?access_token=%@",mainUrl,AccessToken];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *parameter = @{@"userId":userId,@"name":name,@"idNumber":idNumber,@"bankName":bankName,@"bankCardNo":bankCardNo,@"mobile":mobile,@"fromsource":@"1"};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            NSInteger isTure = [json[@"success"] integerValue];
            if (isTure) {
                success(YES);
            }else{
                faild(NO);
//                NSArray *arr = json[@"error"];
//                NSString *str = [arr firstObject][@"message"];
//                ShowMessage(str);
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            faild(NO);
        }];
    } else {
        faild(NO);
        ShowMessage(dataInfoMessage);
    }
}
/////////微商开户接口
- (void)requestForhuishangBankOpenAnAccountuserId:(NSString *)userId
                                             name:(NSString *)name
                                         idNumber:(NSString *)idNumber
                                         bankName:(NSString *)bankName
                                       bankCardNo:(NSString *)bankCardNo
                                           mobile:(NSString *)mobile
                                          Success:(void (^)(BOOL sure))success
                                            Faild:(void (^)(BOOL sure))faild{
    
    
    if (JudgeStatusOfNetwork()) {
        
        NSString *url = [NSString stringWithFormat:@"%@api/sumpay/realNameAuth/openAccount?access_token=%@",mainUrl,AccessToken];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *parameter = @{@"userId":userId,@"name":name,@"idNumber":idNumber,@"bankName":bankName,@"bankCardNo":bankCardNo,@"mobile":mobile,@"fromsource":@"1"};
        
        [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            NSInteger isTure = [json[@"success"] integerValue];
            if (isTure) {
                success(YES);
            }else{
                faild(NO);
//                NSArray *arr = json[@"error"];
//                NSString *str = [arr firstObject][@"message"];
//                ShowMessage(str);
            }
        } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
            ShowMessage(@"请求失败，请检查网络");
            faild(NO);
        }];
    } else {
        faild(NO);
        ShowMessage(dataInfoMessage);
    }

    
}






@end
