//
//  DMScafferCreditManager.m
//  豆蔓理财
//
//  Created by edz on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScafferCreditManager.h"
#import "DMTenderUrlManager.h"
#import "DMTenderDescModel.h"
#import "DMScafferBuyModel.h"
#import "GZBuyListModel.h"
#import "DMRobtOpenInfoModel.h"
#import "DMRobtOpeningModel.h"
#import "DMRobtEndListModel.h"
#import "DMRobtDetailModel.h"
#import "DMRobtEndDetailModel.h"
#import "DMMyServerModel.h"
#import "DMMyServerHoldListModel.h"
#import "DMRobotHoldCreditModel.h"

@interface DMScafferCreditManager ()

@property (nonatomic, strong)AFHTTPSessionManager *requestManager;

@end

@implementation DMScafferCreditManager

+ (instancetype)scafferDefault {
    static DMScafferCreditManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.requestManager = [AFHTTPSessionManager manager];
        manager.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
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

- (void)DMGetScafferCreditListDataPage:(NSInteger)page size:(NSInteger)size months:(NSInteger)months showView:(UIView *)showView success:(void (^)(NSArray *,NSInteger))success faild:(void (^)())faild  {
    
    if (JudgeStatusOfNetwork()) {
        NSString *path = [NSString stringWithFormat:@"apk/index/getRetailLoanList?page=%ld&size=%ld&clientType=2",(long)page,(long)size];
        NSString *urlString = hostName(path);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            if ([status isEqualToString:@"0"]) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMScafferListModel class] json:responseObject[@"data"][@"loanList"]];
                NSInteger totalSize = array.count;
                success(array,totalSize);
            }else {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                ShowMessage(message);
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild();
        }];
    }else {
        ShowMessage(dataInfoMessage);
    }
}


- (void)getCreditDescWithLoanId:(NSString *)loadId Success:(void (^)(DMTenderDescModel *tenderModel, NSArray *authenArray))success faild:(void (^)())faild{
    NSString *url = [[DMTenderUrlManager manager] getCreditDescUrlLoanId:loadId];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"0"]) {
            DMTenderDescModel *model = [DMTenderDescModel yy_modelWithJSON:responseObject[@"data"]];
            NSMutableArray *authorArray = [NSMutableArray arrayWithCapacity:0];
            if ([model.enterPrise isEqualToString:@"1"]) {
                // 企业
                if (model.idNumberAuthen == 1) {
                    [authorArray addObject:@"身份认证"];
                }
                if (model.incomeAuthen == 1) {
                    [authorArray addObject:@"收入报告"];
                }
                if (model.creditAuthen == 1) {
                    [authorArray addObject:@"信用报告"];
                }
                if (model.yingyeAuthen == 1) {
                    [authorArray addObject:@"营业执照"];
                }
                if (model.shidiAuthen == 1) {
                    [authorArray addObject:@"实地报告"];
                }
            }else{
                //个人
                if (model.idNumberAuthen == 1) {
                    [authorArray addObject:@"身份证认证"];
                }
                if (model.mobileAuthen == 1) {
                    [authorArray addObject:@"手机认证"];
                }
                if (model.jobAuthen == 1) {
                    [authorArray addObject:@"工作证明"];
                }
                if (model.incomeAuthen == 1) {
                    [authorArray addObject:@"收入证明"];
                }
                if (model.houseAuthen == 1) {
                    [authorArray addObject:@"房产证明"];
                }
                if (model.carAuthen == 1) {
                    [authorArray addObject:@"车产证明"];
                }
            }
            success(model,authorArray);
        }else {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild();
    }];

}


- (void)getTenderBuyListWithLoadId:(NSString *)loadId Size:(NSString *)size success:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMTenderUrlManager manager] getTenderBuyListWithLoanId:loadId Size:size];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status isEqualToString:@"0"]) {
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[GZBuyListModel class] json:responseObject[@"data"][@"list"]];
            success(listArray);
        }else {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild();
    }];
}



- (void)DMScafferCreditToBuyWithAssetId:(NSString *)assetId loanId:(NSString *)loanId investAmount:(NSString *)investAmount couponId:(NSString *)couponId showView:(UIView *)showView successBlock:(void (^)(DMScafferBuyModel *))successBlock faild:(void (^)(NSString *))faild {
    
    if (JudgeStatusOfNetwork()) {
        NSString *urlString = [NSString stringWithFormat:@"%@api/v4/buy/assets/%@?access_token=%@&source=APP",mainUrl,USER_ID,AccessToken];
        NSDictionary *dic = [NSDictionary dictionary];
        if (isOrEmpty(couponId)) {
            dic = @{@"assetId":assetId,@"loanId":loanId,@"investAmount":investAmount,@"fromsource":@"1"};
        }else {
            dic = @{@"assetId":assetId,@"loanId":loanId,@"investAmount":investAmount,@"couponId":couponId,@"fromsource":@"1"};
        }
        
        if (isOrEmpty(loanId) && isOrEmpty(couponId)) {
            dic = @{@"assetId":assetId,@"investAmount":investAmount,@"fromsource":@"1"};
        }else if (!isOrEmpty(loanId) && !isOrEmpty(couponId)) {
            dic = @{@"assetId":assetId,@"investAmount":investAmount,@"couponId":couponId,@"fromsource":@"1"};
        }
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        [self.requestManager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            BOOL result = ((NSNumber *)[responseObject objectForKey:@"success"]).boolValue;
            if (result) {
                DMScafferBuyModel *buyModel = [DMScafferBuyModel yy_modelWithJSON:responseObject[@"data"]];
                successBlock(buyModel);
            }else {
                NSString *message = [NSString stringWithFormat:@"%@",[[responseObject[@"error"] lastObject] objectForKey:@"message"]];
                faild(message);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            faild(dataInfoMessage);
        }];
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}
#pragma 小豆机器人相关接口

- (void)DMRobtToGetOpeningWithRobtCycle:(NSString *)robtCycle showView:(UIView *)showView success:(void (^)(NSArray<DMRobtOpeningModel *> *, NSArray<DMRobtOpenInfoModel *> *))success faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        
        NSString *urlString;
        if (isOrEmpty(robtCycle)) {
            urlString = hostName(@"apk/robot/getOpeningRobots");
        }else {
            NSString *pathName = [NSString stringWithFormat:@"apk/robot/getOpeningRobots?robotCycle=%@",robtCycle];
            urlString = hostName(pathName);
        }
        NSLog(@"小豆机器人----%@",urlString);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            if ([message isEqualToString:@"成功"]) {
                NSArray *openArr = [NSArray yy_modelArrayWithClass:[DMRobtOpeningModel class] json:responseObject[@"data"][@"robots"]];
                NSArray *infoArr = [NSArray yy_modelArrayWithClass:[DMRobtOpenInfoModel class] json:responseObject[@"data"][@"robotInfos"]];
                success(openArr,infoArr);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild();
        }];
        
    }else {
        ShowMessage(@"网络连接失败，请检查您的网络设置");
         faild();
    }
}

- (void)DMRobtToGetEndRobtsWithPage:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void (^)(NSArray *))success faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
      
        NSString *pathName = [NSString stringWithFormat:@"apk/robot/getEndRobots?page=%ld&size=%ld",(long)page,(long)size];
        NSString *urlString = hostName(pathName);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            if ([message containsString:@"成功"]) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMRobtEndListModel class] json:responseObject[@"data"][@"robots"]];
                success(array);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             ShowMessage(dataInfoMessage);
            faild();
        }];
    }else {
        ShowMessage(@"网络连接失败，请检查您的网络设置");
        faild();
    }
}

- (void)DMRobtToGetDetailRobtWithRobtID:(NSString *)robtID showView:(UIView *)showView success:(void (^)(DMRobtEndDetailModel *))success faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"apk/robot/getRobot?id=%@",robtID];
        NSString *urlString = hostName(pathName);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            if ([message containsString:@"成功"]) {
                DMRobtEndDetailModel *detailModel = [DMRobtEndDetailModel yy_modelWithJSON:responseObject[@"data"][@"robot"]];
                success(detailModel);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild();
        }];
    }else {
        ShowMessage(@"网络连接失败，请检查您的网络设置");
        faild();
    }
}

- (void)DMRobtToGetListRobtBuyWithPage:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView robtID:(NSString *)robtID success:(void (^)(NSArray *))success faild:(void (^)())faild {
    if (JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/robot/listRobotBuy?page=%ld&size=%ld&robotId=%@",(long)page,(long)size,robtID];
        NSString *urlString = hostName(pathName);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            if ([message containsString:@"成功"]) {
                NSArray *listArr = [NSArray yy_modelArrayWithClass:[DMRobtDetailModel class] json:responseObject[@"data"][@"orders"]];
                success(listArr);
            }else {
                faild();
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild();
        }];
    }else {
        ShowMessage(@"网络连接失败，请检查您的网络设置");
        faild();
    }
}

- (void)DMRobtToMakeAppointmentToBuyWithOrderInvestAmount:(NSString *)orderInvestAmount robotID:(NSString *)robotID showView:(UIView *)showView success:(void (^)(NSString *))success faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@api/v2/robotAutomaticBid/automaticBidRequest?access_token=%@",mainUrl,AccessToken];
        MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        if (isOrEmpty(orderInvestAmount)) {
            orderInvestAmount = @"0";
        }
        if (isOrEmpty(robotID)) {
            robotID = @"0";
        }
        NSDictionary *dic = @{@"userId":USER_ID,@"orderInvestAmount":orderInvestAmount,@"robotId":robotID,@"vipFlag":@"0",@"fromsource":@"1",@"source":@"APP"};
        [self.requestManager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
            NSLog(@"小豆机器人预约购买==%@",responseObject);
            if ([result isEqualToString:@"Y"]) {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                success(message);
            }else {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                faild(message);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self performSelector:@selector(hideHUD:) withObject:progress afterDelay:0.3];
            faild(dataInfoMessage);
        }];
    }else {
        ShowMessage(@"网络连接失败，请检查您的网络设置");
        faild(@"网络未连接");
    }
}

#pragma mark --- 我的服务

- (void)getMyServerRobotInfoSuccess:(void (^)(DMMyServerModel *))success faild:(void (^)())faild{
    NSString *url = [[DMTenderUrlManager manager] getMyServerRobotInfoUrl];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            DMMyServerModel *serverModel = [DMMyServerModel yy_modelWithDictionary:responseObject[@"data"]];
            success(serverModel);
        }else {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        faild();
    }];
}


- (void)getMyServerHoldListWithStatus:(NSString *)status Size:(NSString *)size success:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMTenderUrlManager manager] getMyServerHoldListWithStatus:status Size:size];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[DMMyServerHoldListModel class] json:responseObject[@"data"][@"orders"]];
            success(listArray);
        }else {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        faild();
    }];

}


- (void)getMyServerRobotHoldCreditRobotId:(NSString *)robot Size:(NSString *)size success:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMTenderUrlManager manager] getMyserverHoldCreditWithRobotId:robot Size:size];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[DMRobotHoldCreditModel class] json:responseObject[@"data"][@"loans"]];
            success(listArray);
        }else {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        faild();
    }];
}

@end
