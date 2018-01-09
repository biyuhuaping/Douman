//
//  DMCreditRequestManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCreditRequestManager.h"
#import "DMCreditUrlManager.h"
#import "DMCreditAssetListModel.h"
#import "DMHoldCreditModel.h"
#import "DMloanProportionModel.h"
#import "DMSingleLoanModel.h"
#import "DMCarPledgeModel.h"
#import "DMCarPledgeListModel.h"
#import "DMCreditTransferModel.h"
@interface DMCreditRequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation DMCreditRequestManager


+ (instancetype)manager{
    static DMCreditRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMCreditRequestManager alloc] init];
        manager.sessionManager = [AFHTTPSessionManager manager];
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    });
    return manager;
}

// 持有详情列表

- (void)getHoldCreditListWithStyle:(NSString *)Style Size:(NSString *)size Success:(void (^)(DMHoldCreditModel *, NSArray<DMCreditAssetListModel *> *, NSArray<DMloanProportionModel *> *))success Failed:(void (^)())failed{
    NSString *urlString = [[DMCreditUrlManager manager] getHoldCreditListUrlWithStyle:Style Size:size];
//    NSLog(@"   %@",urlString);
    [self.sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"持有债权详情列表%@",responseObject);
        DMHoldCreditModel *creditModel = [DMHoldCreditModel yy_modelWithJSON:responseObject[@"data"]];
        NSArray *listArray = [NSArray yy_modelArrayWithClass:[DMCreditAssetListModel class] json:responseObject[@"data"][@"assetList"]];
        NSArray *loanArray = [NSArray yy_modelArrayWithClass:[DMloanProportionModel class] json:responseObject[@"data"][@"loanProportions"]];
        success(creditModel,listArray,loanArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failed();
    }];

}

// 单期持有债权

- (void)getSingleHoldCreditWithAssetId:(NSString *)assetId page:(NSString *)page Success:(void (^)(DMCreditAssetListModel *, NSArray<DMSingleLoanModel *> *))success Failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getSingleHoldCreditWithAssetid:assetId Page:page];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"单期持有债权%@",responseObject);
        NSArray *list = [NSArray yy_modelArrayWithClass:[DMSingleLoanModel class] json:responseObject[@"data"][@"loanList"]];
        DMCreditAssetListModel *listModel = [DMCreditAssetListModel yy_modelWithJSON:responseObject[@"data"]];
        success(listModel,list);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];
    
}

// 车辆质押债权详情
- (void)getRequstCarPledgeWithLoanId:(NSString *)loanId Success:(void (^)(DMCarPledgeModel *, NSArray<DMCarPledgeListModel *> *))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCarPledgeCreditDetailWithLoanId:loanId];
    NSLog(@" ===  %@", url);
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"车辆质押  %@",responseObject);
        NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([result isEqualToString:@"0"]) {
            DMCarPledgeModel *model = [DMCarPledgeModel yy_modelWithJSON:responseObject[@"data"]];
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[DMCarPledgeListModel class] json:responseObject[@"data"][@"repaymentList"]];
            success(model,listArray);
        }else{
            ShowMessage(responseObject[@"message"]);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];

}

//车险分期债权详情

- (void)getRequestCarInsuranceWithLoanId:(NSString *)loanId Success:(void (^)(DMCarPledgeModel *, NSArray<DMCarPledgeListModel *> *))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCarInsuranceCreditDetailWithLoanId:loanId];
    NSLog(@" ===  %@", url);
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"车辆分期  %@",responseObject);
        NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([result isEqualToString:@"0"]) {
            DMCarPledgeModel *model = [DMCarPledgeModel yy_modelWithJSON:responseObject[@"data"]];
            NSArray *listArray = [NSArray yy_modelArrayWithClass:[DMCarPledgeListModel class] json:responseObject[@"data"][@"repaymentList"]];
            success(model,listArray);
        }else{
            ShowMessage(responseObject[@"message"]);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];
}


// 验证密码
- (void)checkPassWordWithPassword:(NSString *)password Success:(void (^)())success Faild:(void (^)(NSString *))failed{
    NSString *url = [[DMCreditUrlManager manager] getCheckPassWordUrl];
    NSDictionary *parameter = @{@"loginPassword":password,@"fromsource":@"1"};
    [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *value = responseObject[@"success"];
        if ([value integerValue]) {
            success();
        }else{
            NSArray *errors = responseObject[@"error"];
            NSString *message = [errors firstObject][@"message"];
            if ([message isEqualToString:@"INVALID_PARAMS"]) {
                failed(@"密码错误");
            }else{
                failed(@"验证失败");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(@"验证失败");
    }];
}


//债转转让列表

- (void)getCreditTransferStatus:(NSString *)status Success:(void (^)(NSArray<DMCreditTransferModel *> *))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCreditTransferListUrlStatus:status];

    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"债转转让列表/n  %@",responseObject);
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[DMCreditTransferModel class] json:responseObject[@"assignList"]];
        success(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failed();
    }];
}

/**
 发起债转
 */

- (void)startCreditTransferInvestId:(NSString *)investId Success:(void (^)())success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCreditTransferStartUrlInvestId:investId];
    
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发起债转/n  %@",responseObject);
        BOOL result = [responseObject[@"result"] boolValue];
        NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        ShowMessage(message);
        if (result) {
            success();
        }else{
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failed();
    }];
}

// 撤销
- (void)revokeCreditTransferId:(NSString *)transferId Success:(void (^)())success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCreditTransferRevokeUrlTransferId:transferId];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"撤销债转/n  %@",responseObject);
        BOOL result = [responseObject[@"result"] boolValue];
        NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
        ShowMessage(message);
        if (result) {
            success();
        }else{
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failed();
    }];

}

- (void)getCreditContactWithLoadId:(NSString *)loanId Success:(void (^)(NSString *loanUrl))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getCreditContactUrl:loanId];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BOOL result = [responseObject[@"success"] boolValue];
        if (result) {
            NSString *loanUrl = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"path"]];
            success(loanUrl);
        }else{
            NSString *message = [NSString stringWithFormat:@"%@",[responseObject[@"error"] firstObject][@"message"]];
            ShowMessage(message);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        failed();
    }];

}

// 已转让合同
- (void)getTransferContactWithLoadId:(NSString *)loanId Success:(void (^)(NSArray *))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getTransferContactUrl:loanId];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BOOL result = [responseObject[@"result"] boolValue];
        if (result) {
            NSArray *contactArray = (NSArray *)responseObject[@"contractList"];
            NSMutableArray *contactList = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < contactArray.count; i ++) {
                [contactList addObject:[contactArray[i] objectForKey:@"PATH"]];
            }
            success(contactList);
        }else{
            NSString *message = [NSString stringWithFormat:@"%@",[responseObject[@"error"] firstObject][@"message"]];
            ShowMessage(message);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        failed();
    }];
}


// 提现 保存订单

- (void)withDrawCash:(NSString *)cash branchName:(NSString *)brancheName Success:(void (^)(NSString *))success failed:(void (^)())failed {
    NSString *url = [[DMCreditUrlManager manager] getdrawSavePayUrl];
    NSDictionary *parameter;
    
//    if (brancheName != nil) {
//        parameter = @{@"userId":USER_ID,@"amount":cash,@"source":@"APP",@"branchName":brancheName};
//    }else {
        parameter = @{@"userId":USER_ID,@"amount":cash,@"source":@"APP",@"fromsource":@"1"};
//    }
    
    [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger value = [[NSString stringWithFormat:@"%@",responseObject[@"success"]] integerValue];
        if (value) {
            NSString *requestId = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            success(requestId);
        }else{
            NSArray *errors = responseObject[@"error"];
            NSString *message = [errors firstObject][@"message"];
            ShowMessage(message);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];
}

-(void)getFormDataWithRequestId:(NSString *)requestId Success:(void (^)(NSString *argument))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getFormDataUrl];
    NSDictionary *parameter = @{@"userId":USER_ID,@"requestId":requestId,@"source":@"APP",@"fromsource":@"1"};

    [self.sessionManager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        if ([result isEqualToString:@"true"]) {
            NSString *arg = [NSString stringWithFormat:@"REQUEST_TYPE=%@&REQUEST_ID=%@&MERCHANT_CODE=%@&ORDERNO=%@&TRXDATE=%@&TRXTIME=%@&COINSTCODE=%@&COINSTCHANNEL=%@&CARDNBR=%@&BANKNAME=%@&CARD_BIND=%@&NAME=%@&IDNO=%@&IDTYPE=%@&PHONE=%@&AMOUNT=%@&FEE=%@&FORGERPWD_URL=%@&BACKGROUND_URL=%@&TRANSACTION_URL=%@&ROUT_FLAG=%@&ROUT_CODE=%@&BANK_CNAPS=%@&SIGNATURE=%@",responseObject[@"REQUEST_TYPE"],responseObject[@"REQUEST_ID"],responseObject[@"MERCHANT_CODE"],responseObject[@"ORDERNO"],responseObject[@"TRXDATE"],responseObject[@"TRXTIME"],responseObject[@"COINSTCODE"],responseObject[@"COINSTCHANNEL"],responseObject[@"CARDNBR"],responseObject[@"BANKNAME"],responseObject[@"CARD_BIND"],responseObject[@"NAME"],responseObject[@"IDNO"],responseObject[@"IDTYPE"],responseObject[@"PHONE"],responseObject[@"AMOUNT"],responseObject[@"FEE"],responseObject[@"FORGERPWD_URL"],responseObject[@"BACKGROUND_URL"],responseObject[@"TRANSACTION_URL"],responseObject[@"ROUT_FLAG"],responseObject[@"ROUT_CODE"],responseObject[@"BANK_CNAPS"],responseObject[@"SIGNATURE"]];
            success(arg);
        }else{
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];
}

// 设置交易密码
- (void)replacePassWordSuccess:(void (^)(NSString *))success failed:(void (^)())failed{
    NSString *url = [[DMCreditUrlManager manager] getReplacePassWordUrl];
    [self.sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        if ([result isEqualToString:@"true"]) {
            NSString *arg = [NSString stringWithFormat:@"CARDNBR=%@&COINSTCHANNEL=%@&COINSTCODE=%@&IDNO=%@&IDTYPE=%@&MERCHANT_CODE=%@&NAME=%@&PHONE=%@&REQUEST_ID=%@&REQUEST_TYPE=%@&RESETPWD_FURL=%@&RESETPWD_SURL=%@&SIGNATURE=%@&TRXDATE=%@&TRXTIME=%@",responseObject[@"CARDNBR"],responseObject[@"COINSTCHANNEL"],responseObject[@"COINSTCODE"],responseObject[@"IDNO"],responseObject[@"IDTYPE"],responseObject[@"MERCHANT_CODE"],responseObject[@"NAME"],responseObject[@"PHONE"],responseObject[@"REQUEST_ID"],responseObject[@"REQUEST_TYPE"],responseObject[@"RESETPWD_FURL"],responseObject[@"RESETPWD_SURL"],responseObject[@"SIGNATURE"],responseObject[@"TRXDATE"],responseObject[@"TRXTIME"]];
            success(arg);
        }else{
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            ShowMessage(message);
            failed();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed();
    }];
    
}


@end
