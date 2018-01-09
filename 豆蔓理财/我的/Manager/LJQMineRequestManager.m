//
//  LJQMineRequestManager.m
//  豆蔓理财
//
//  Created by mac on 2016/12/21.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQMineRequestManager.h"
#import "DMKeepRecordModel.h"
@interface LJQMineRequestManager ()

@property (nonatomic, strong)AFHTTPSessionManager *manager;

@end

@implementation LJQMineRequestManager

+ (instancetype)RequestManager {
    static LJQMineRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.manager = [AFHTTPSessionManager manager];
        manager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];

    });
    return manager;
}


- (void)hideHUD:(MBProgressHUD *)progress {
    __block MBProgressHUD *progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}

- (void)saveDic:(NSMutableDictionary *)dic {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingString:@"/userDiary.plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:dic, nil];
    [array writeToFile:fileName atomically:YES];
}

- (NSDictionary *)readDic {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [path stringByAppendingString:@"/userDiary.plist"];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:fileName];
    NSDictionary *dic = array.firstObject;
    return dic;
}

//我的账户
- (void)LJQRequestMineDataStringSuccessBlock:(void(^)(NSInteger,LJQMineModel *))successBlock faildBlock:(void(^)())faildBlock {
    
    if (JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getAccountIndexInfo?userId=%@&access_token=%@",USER_ID,AccessToken];
        NSString *string = hostName(pathName);
        [self.manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"我的资产---%@",responseObject);
            NSInteger index = [responseObject[@"status"] integerValue];
            
            if (index == 0) {
                LJQMineModel *mineModel = [LJQMineModel yy_modelWithJSON:responseObject[@"data"]];
                NSLog(@"---账户中心-----%@",mineModel);
                successBlock(index,mineModel);
            }else{
                ShowMessage(responseObject[@"message"]);
                faildBlock();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ShowMessage(@"获取服务器数据失败");
            faildBlock();
        }];
    }else {
         ShowMessage(dataInfoMessage);
    }
    

}

//平台公告
- (void)LJQPlatformNoticeDataPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void (^)(NSArray *, NSInteger))successBlock faild:(void (^)())faild {
    
    if (JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getSystemNotice?page=%ld&size=%ld&access_token=%@",page,size,AccessToken];
        NSString *string = hostName(pathName);
        [self.manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"平台公告----%@",responseObject);
            NSInteger index = [responseObject[@"status"] integerValue];
            if (index == 0) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[LJQPlanformNoticeModel class] json:responseObject[@"data"][@"noticeList"]];
                successBlock(array,index);
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}


//系统消息
- (void)LJQSystemMessageDataPage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void (^)(NSArray *, NSInteger))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getMessage?userId=%@&page=%ld&size=%ld&access_token=%@",USER_ID,page,size,AccessToken];
        NSString *string = hostName(pathName);
        [self.manager GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"系统消息----%@",responseObject);
            NSInteger index = [responseObject[@"status"] integerValue];
            if (index == 0) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[LJQSystemMessageModel class] json:responseObject[@"data"][@"messageList"]];
                NSInteger number = [responseObject[@"data"][@"newSize"] integerValue];
                successBlock(array,number);
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}


//系统消息已读
- (void)LJQsetSystemMessageReadMessageID:(NSArray *)messageID SuccessBlock:(void (^)(NSString *, NSInteger))successBlock faild:(void (^)())faild {
   
    if (JudgeStatusOfNetwork()) {
        NSString *AllMessageID = [self operationAction:messageID];

        NSString *urlString = [NSString stringWithFormat:@"%@apk/userAccount/updateMessageReaded?userId=%@&access_token=%@",mainUrl,USER_ID,AccessToken];
        [self.manager POST:urlString parameters:@{@"messageIds":AllMessageID,@"fromsource":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSInteger index = [responseObject[@"status"] integerValue];
            
            if (index == 0) {
                successBlock(responseObject[@"message"],index);
            }else
                if (index == 1) {
                    successBlock(nil,index);
                }else {
                    successBlock(nil,index);
                }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"消息已读失败");
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

//将所有id拼接
- (NSString *)operationAction:(NSArray *)messageIDArr {
    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < messageIDArr.count; i++) {
        NSString *ID = [messageIDArr[i] stringByAppendingString:@","];
        if (i == messageIDArr.count -1) {
            ID = messageIDArr[i];
        }
        string = [string stringByAppendingString:ID];
    }
    return string;
}

//删除系统消息
- (void)LJQDeleteSystemMessageMsgID:(NSArray *)messageID SuccessBlock:(void (^)(NSString *, NSInteger))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        NSString *AllMessageID = [self operationAction:messageID];

        NSString *urlString = [NSString stringWithFormat:@"%@apk/userAccount/updateMessageDeleted?userId=%@&access_token=%@",mainUrl,USER_ID,AccessToken];
        
        [self.manager POST:urlString parameters:@{@"messageIds":AllMessageID,@"fromsource":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSInteger index = [responseObject[@"status"] integerValue];
            
            if (index == 0) {
                successBlock(responseObject[@"message"],index);
            }else
                if (index == 1) {
                    successBlock(nil,index);
                }else {
                    successBlock(nil,index);
                }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"删除消息失败");
        }];

    }else {
         ShowMessage(dataInfoMessage);
    }
}

//交易明细

- (void)LJQTradeDetailType:(NSString *)type startTime:(NSString *)startTime endTime:(NSString *)endTime page:(NSInteger)page size:(NSInteger)size successBlock:(void (^)(NSArray *, CGFloat, NSInteger, NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getFundRecords?userId=%@&type=%@&startTime=%@&endTime=%@&page=%ld&size=%ld&access_token=%@",USER_ID,type,startTime,endTime,page,size,AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // NSLog(@"交易明细----%@",responseObject);
            NSInteger index = [responseObject[@"status"] integerValue];
            CGFloat money = [responseObject[@"data"][@"amount"] floatValue];
            NSString *message = responseObject[@"message"];
            if (index == 0) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[LJQTradeDetailModel class] json:responseObject[@"data"][@"fundRecords"]];
                successBlock(array,money,index,message);
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}

//提前还款列表
- (void)LJQEarlyBackMoneypage:(NSInteger)page size:(NSInteger)size SuccessBlock:(void (^)(NSInteger, NSArray *, NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getAheadSettledList?userId=%@&page=%ld&size=%ld&access_token=%@",USER_ID,page,size,AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger index = [responseObject[@"status"] integerValue];
            NSString *message = responseObject[@"message"];
            if (index == 0) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[LJQEarlyBackMoneyModel class] json:responseObject[@"data"][@"aheadSettledList"]];
                successBlock(index,array,message);
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}


//优惠券
- (void)LJQCouponsDataStatus:(NSString *)status page:(NSInteger)page size:(NSInteger)size successBlock:(void (^)(NSInteger, NSArray *, NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getCouponPlacements?userId=%@&status=%@&page=%ld&size=%ld&access_token=%@",USER_ID,status,(long)page,(long)size,AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSInteger index = [responseObject[@"status"] integerValue];
            if (index == 0) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[LJQCouponsModel class] json:responseObject[@"data"][@"coupons"]];
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"totalSize"]];
                successBlock(index,array,message);
            }else{
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"优惠券请求失败");
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}


//账户信息
- (void)LJQUserInfoDataSourceSuccessBlock:(void (^)(NSInteger, LJQUserInfoModel *, NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getUserAccountInfo?userId=%@&access_token=%@",USER_ID,AccessToken];
        NSString *urlString = hostName(pathName);
        NSLog(@"----%@",urlString);
        [ self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"账户======%@",responseObject);
            NSInteger index = [responseObject[@"status"] integerValue];
            NSString *message = responseObject[@"message"];
            if (index == 0) {
                LJQUserInfoModel *model = [LJQUserInfoModel yy_modelWithDictionary:responseObject[@"data"]];
                if (!isOrEmpty(model.cardNbr)) {
                    [[NSUserDefaults standardUserDefaults] setObject:model.cardNbr forKey:@"cardNbr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                successBlock(index,model,message);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}

//实名认证
- (void)LJQRealNameIdNumber:(NSString *)idNumber name:(NSString *)name successBlock:(void (^)())scuuessblock faild:(void (^)(NSString *, BOOL))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/v2/kaAndKl/authenticateUserByKL?access_token=%@",mainUrl,AccessToken];
        
        [self.manager POST:urlString parameters:@{@"userId":USER_ID,@"name":name,@"idNumber":idNumber,@"fromsource":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"实名认证---%@",responseObject);
            if ([responseObject[@"success"] integerValue] == 1 ) {
                //成功
                scuuessblock();
            }else {
                NSString *string = [[responseObject[@"error"] firstObject] objectForKey:@"message"];
                faild(string,NO);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(nil,NO);
            ShowMessage(@"实名认证失败");
        }];
    }else {
        faild(nil,NO);
        ShowMessage(dataInfoMessage);
    }
}

//提现
- (void)getCashlianlianpayWithUserId:(NSString *)userId PayPassWord:(NSString *)passWord Amount:(NSString *)amount successBlock:(void (^)())successBlock faild:(void (^)(NSString *))faild{
    if (JudgeStatusOfNetwork()) {

        NSString *url = [NSString stringWithFormat:@"%@api/v2/lianlianpay/withdraw/%@?access_token=%@",mainUrl,USER_ID,AccessToken];
        NSDictionary *parameter = @{@"amount":amount,@"paymentPassword":passWord,@"source":@"APP",@"fromsource":@"1"};
        [self.manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"success"] integerValue]) {
                successBlock();
            }else{
                faild([responseObject[@"error"] firstObject][@"message"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(@"-----提现失败");
        }];

    }else {
         ShowMessage(dataInfoMessage);
    }
}


//是否实名认证
- (void)LJQIsRealNamesuccessblock:(void (^)(NSString *))successblock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/user/%@/isAuthenticate?access_token=%@",USER_ID,AccessToken];
        NSString *urlString = hostName(pathName);
        NSLog(@"是否实名认证is %@",urlString);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            successblock(string);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ShowMessage(@"是否实名认证响应失败");
            faild();
        }];

    }else {
         ShowMessage(dataInfoMessage);
         faild();
    }
}

//是否设置交易密码
- (void)LJQIsSetTradePassWordSuccessblock:(void (^)(NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/user/%@/paymentPasswordHasSet?access_token=%@",USER_ID,AccessToken];
        NSString *urlString = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            successBlock(string);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"是否设置交易密码失败");
        }];

    }else {
         ShowMessage(dataInfoMessage);
    }
}

//设置交易密码

- (void)LJQSetTradePassWordLoginPd:(NSString *)loginPd tradePd:(NSString *)tradePd successBlock:(void (^)(NSInteger,NSString *str))successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/v2/user/%@/setPaymentPassword?access_token=%@",mainUrl,USER_ID,AccessToken];
        
        NSDictionary *dic = @{@"loginPassword":loginPd,@"password":tradePd,@"fromsource":@"1"};
        [self.manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"----设置交易密码请求结果--------%@",responseObject);
            NSInteger isTure = [responseObject[@"success"] integerValue];
            
            if (isTure == 1) {
                successBlock(isTure,nil);
            }else {
                NSString *string = [[responseObject[@"error"] firstObject] objectForKey:@"message"];
                successBlock(isTure,string);
                faild(string);
            }            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(@"请求数据失败");
        }];
    }else {
        faild(dataInfoMessage);
        ShowMessage(dataInfoMessage);
    }

}

//修改登录密码
- (void)LJQModifyLoginPassWord:(NSString *)passWord newPassWord:(NSString *)newPassWord successBlock:(void (^)())successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/v3/mobile/changePassword/%@?access_token=%@",mainUrl,USER_ID,AccessToken];
        NSDictionary *dic = @{@"currentPassword":passWord,@"newPassword":newPassWord,@"fromsource":@"1"};
        [self.manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSInteger isTure = [responseObject[@"success"] integerValue];
            if (isTure == 1) {
                successBlock();
            }else {
                NSString *string = [[responseObject[@"error"] firstObject] objectForKey:@"message"];
                if ([string isEqualToString:@"INVALID_MOBILE_CAPTCHA"]) {
                    faild(@"无效的手机验证码");
                }
                if ([string isEqualToString:@"USER_NOT_FOUND"]) {
                    faild(@"用户名不存在");
                }
                if ([string isEqualToString:@"PASSWORD_ERROR"]) {
                    faild(@"登录密码错误");
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(@"获取数据失败");
        }];

    }else {
        faild(dataInfoMessage);
         ShowMessage(dataInfoMessage);
    }
}

//修改交易密码 || 交易密码发送验证码
- (void)LJQSendTradeSmsCaptchaMobile:(NSString *)mobile successBlock:(void (^)())successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/user/%@/sendSmsCaptcha?mobile=%@&smsType=%@&access_token=%@",USER_ID,mobile,@"CONFIRM_CREDITMARKET_RESET_PAYMENTPASSWORD",AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"------------%@",responseObject);
            NSInteger isTrue = [responseObject[@"success"] integerValue];
            if (isTrue == 1) {
                successBlock();
            }else {
                faild(@"发送失败");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }else {
         ShowMessage(dataInfoMessage);
    }
}

//修改交易密码 || 交易密码验证验证码
- (void)LJQCheckTradeSmsCaptchaSmsCaptcha:(NSString *)smsCaptcha successBlock:(void (^)())successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/user/%@/checkSmsCaptcha?smsCaptcha=%@&smsType=%@&access_token=%@",USER_ID,smsCaptcha,@"CONFIRM_CREDITMARKET_RESET_PAYMENTPASSWORD",AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"------------%@",responseObject);
            NSInteger isTrue = [responseObject[@"success"] integerValue];
            if (isTrue == 1) {
                successBlock();
            }else {
                NSString *string = [[responseObject[@"error"] firstObject] objectForKey:@"message"];
                if ([string isEqualToString:@"MOBILE_INVALID"]) {
                    faild(@"无效的手机号码");
                }
                if ([string isEqualToString:@"INVITE_CODE_INVALID"]) {
                    faild(@"注册码无效");
                }
                if ([string isEqualToString:@"MOBILE_CAPTCHA_INVALID"]) {
                    faild(@"短信验证码无效");
                }
                if ([string isEqualToString:@"EMP_REFERRAL_NOT_EXISTS"]) {
                    faild(@"员工唯一号不存在");
                }
                if ([string isEqualToString:@"USERINVITECODE_INVALID"]) {
                    faild(@"邀请码无效");
                }
                if ([string isEqualToString:@"MOBILE_EXISTS"]) {
                    faild(@"手机号已存在");
                }
                if ([string isEqualToString:@"CHANNEL_INVALID"]) {
                    faild(@"无效的来源渠道");
                }
                if ([string isEqualToString:@"NAME_INVALID"]) {
                    faild(@"无效的用户姓名");
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(@"校验失败");
            NSLog(@"校验失败");
        }];
    }else {
        faild(dataInfoMessage);
        ShowMessage(dataInfoMessage);
    }
}

//修改交易密码 || 交易密码重置
- (void)LJQResetPayMentPassWord:(NSString *)passWord smsCaptcha:(NSString *)smsCaptcha successBlock:(void (^)())successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/v2/user/%@/resetPaymentPassword?access_token=%@",mainUrl,USER_ID,AccessToken];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *dic = @{@"password":passWord,@"smsCaptcha":smsCaptcha,@"smsType":@"CONFIRM_CREDITMARKET_RESET_PAYMENTPASSWORD",@"fromsource":@"1"};
        [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([string isEqualToString:@"true"]) {
                successBlock();
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}

//银行卡信息
- (void)LJQ_MineBankCardInfoSuccessBlock:(void (^)())successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/users/bankCardInfo?userId=%@&access_token=%@",USER_ID,AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"------%@",responseObject);
            NSInteger isTure = [responseObject[@"hasbind"] integerValue];
            if (isTure == 1) {
                successBlock();
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
         ShowMessage(dataInfoMessage);
    }
}


//请求省份
- (void)requestProvinceCodes:(void (^)(NSArray *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *pathName = [NSString stringWithFormat:@"api/v2/lianlianpay/provinceCodes?access_token=%@",AccessToken];
        NSString *url = hostName(pathName);
        [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[responseObject allKeys]];
            NSArray * array = [mutableArr  sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [[self firstCharactor:obj1] compare:[self firstCharactor:obj2]];
            }];
            successBlock(array);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}

//请求市
- (void)requestProvinceCityCodes:(NSString *)code successBlock:(void (^)(NSArray *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        //转换格式
        NSString *string = [code stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];

        NSString *pathName = [NSString stringWithFormat:@"api/v2/lianlianpay/provinceCityCodes/%@?access_token=%@",string,AccessToken];
        NSString *url = hostName(pathName);
        [self.manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray * array = [responseObject allKeys];
            NSLog(@"市区-----%ld",array.count);
            successBlock(array);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild();
        }];
    }else {
        faild();
        ShowMessage(dataInfoMessage);
    }
}

// 获取拼音首字母，返回大写拼音首字母
- (NSString *)firstCharactor:(NSString *)aString {
    //转换成可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //转换成不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //转换成大写拼音
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}

- (void)creditTransferListPage:(NSInteger)page size:(NSInteger)size successBlock:(void (^)(NSArray *))successBlcok faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        

        NSString *pathName = [NSString stringWithFormat:@"apk/creditassign/list?size=%ld",size];
        NSString *urlString = hostName(pathName);
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"债权转让列表------%@",responseObject);
            
            NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
            if ([result isEqualToString:@"1"]) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMCreditTransferListModel class] json:responseObject[@"assignList"]];
                successBlcok(array);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)creditTransferToBuyCreditAssignId:(NSString *)creditAssignId applyAmountPrincipal:(NSString *)applyAmountPrincipal applyAmountActual:(NSString *)applyAmountActual successBlock:(void (^)())successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/v4/creditassign/applyCreditAssign/%@?access_token=%@",mainUrl,USER_ID,AccessToken];

        if (creditAssignId.length <= 0) {
            return;
        }
        if (applyAmountPrincipal.length <= 0) {
            ShowMessage(@"输入不能为空");
            return;
        }
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.manager POST:urlString parameters:@{@"creditAssignId":creditAssignId,@"applyAmountPrincipal":applyAmountPrincipal,@"applyAmountActual":applyAmountActual,@"source":@"APP",@"fromsource":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"购买转让===%@",responseObject);
            NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"success"]];
            if ([result isEqualToString:@"1"]) {
                !successBlock ? : successBlock();
            }else {
                NSString *stirng = [NSString stringWithFormat:@"%@",[responseObject[@"error"]firstObject][@"message"]];
                !faild ? : faild(stirng);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"%@",error.userInfo);
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)withDrawSavePayAmount:(NSString *)amount successBlock:(void (^)(NSString *))successBlock faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/sumpay/withdraw/savePay?access_token=%@",mainUrl,AccessToken];

        if (amount.length <= 0) {
            ShowMessage(@"提现金额不能为空");
            return;
        }
         [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.manager POST:urlString parameters:@{@"amount":amount,@"source":@"APP",@"userId":USER_ID,@"fromsource":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"保存订单%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"%@",error.userInfo);
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)withDrawFormDataRequestId:(NSString *)requestId successBlock:(void (^)())successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {

        NSString *urlString = [NSString stringWithFormat:@"%@api/sumpay/withdraw/form/%@?access_token=%@",mainUrl,USER_ID,AccessToken];

        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.manager POST:urlString parameters:@{@"requestId":requestId,@"source":@"APP",@"fromsource":@"1"} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSLog(@"form表单===%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)getBranchNameByKeyString:(NSString *)KeyString limitCount:(NSString *)limitCount successBlock:(void (^)(NSArray *, NSString *))successBlock faildBlock:(void (^)(NSString *))faildBlock {
    if (JudgeStatusOfNetwork()) {
        
        if (KeyString.length <= 0) {
            return;
        }
        NSString *urlString = [NSString stringWithFormat:@"%@apk/userAccount/getBranchNameBykey",mainUrl];
        
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.manager POST:urlString parameters:@{@"key":KeyString,@"limit":limitCount,@"fromsource":@"1"} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            if ([status isEqualToString:@"2"]) {
                NSArray *listArr = [NSArray yy_modelArrayWithClass:[DMGetBranchNameModel class] json:responseObject[@"data"]];
                !successBlock ? : successBlock(listArr,status);
            }
            
            if ([status isEqualToString:@"1"]) {
                !faildBlock ? : faildBlock(@"没有查找到数据");
            }
            
            if ([status isEqualToString:@"0"]) {
                !faildBlock ? : faildBlock(@"程序异常");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
             [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)automicCreditTransgerAssignId:(NSString *)assignId loanId:(NSString *)loanId successBlock:(void (^)(NSString *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        

        NSString *pathName = [NSString stringWithFormat:@"api/v4/creditassign/autoAssignSign/%@?assignId=%@&loanId=%@&access_token=%@&loginFlag=%@&source=APP",USER_ID,assignId,loanId,AccessToken,AccessToken];
        NSString *urlString = hostName(pathName);
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@",responseObject);
            if (isOrEmpty(responseObject[@"ERRORMSG"])) {
                NSString *arg = [NSString stringWithFormat:@"CARDNBR=%@&COINSTCHANNEL=%@&COINSTCODE=%@&FORGERPWD_URL=%@&MERCHANT_CODE=%@&REBACK_URL=%@&REQUEST_ID=%@&REQUEST_TYPE=%@&SERI_NO=%@&SIGNATURE=%@&SUCCESSRESULT_URL=%@&TRANSACTION_URL=%@&TRDRESV=%@&TRXDATE=%@&TRXTIME=%@",responseObject[@"CARDNBR"],responseObject[@"COINSTCHANNEL"],responseObject[@"COINSTCODE"],responseObject[@"FORGERPWD_URL"],responseObject[@"MERCHANT_CODE"],responseObject[@"REBACK_URL"],responseObject[@"REQUEST_ID"],responseObject[@"REQUEST_TYPE"],responseObject[@"SERI_NO"],responseObject[@"SIGNATURE"],responseObject[@"SUCCESSRESULT_URL"],responseObject[@"TRANSACTION_URL"],responseObject[@"TRDRESV"],responseObject[@"TRXDATE"],responseObject[@"TRXTIME"]];
                
                !successBlock ? : successBlock(arg);
            }else {
                !faild ? : faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.userInfo);
            !faild ? : faild();
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}

- (void)DM_GetPreservationRecordDataWithPage:(NSInteger)page size:(NSInteger)size type:(NSString *)type showView:(UIView *)showView successBlock:(void (^)(NSArray<DMKeepRecordModel *> *))successBlock faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"apk/userProducts/getSecurityNumberByUser?access_token=%@&userId=%@&page=%ld&size=%ld",AccessToken,USER_ID,page,size];
        NSString *urlString = hostName(pathName);
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            NSLog(@"%@",responseObject);
            if ([status isEqualToString:@"0"]) {
                
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMKeepRecordModel class] json:responseObject[@"securityNumberList"]];
                successBlock(array);
                
            }else if([status isEqualToString:@"3"]){
//                ShowMessage(@"暂无保全记录");
                faild();
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            faild();
        }];
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}
@end
