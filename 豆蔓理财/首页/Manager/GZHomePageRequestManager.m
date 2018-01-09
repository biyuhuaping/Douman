//
//  GZHomePageRequestManager.m
//  豆蔓理财
//
//  Created by armada on 2016/12/17.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZHomePageRequestManager.h"

@implementation GZHomePageRequestManager

static GZHomePageRequestManager *defaultManager = nil;

#pragma mark - Strict singleton
+(instancetype)defaultManager {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(defaultManager == nil) {
            defaultManager = [[GZHomePageRequestManager alloc]init];
        }
    });
    return defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if(defaultManager == nil) {
            defaultManager = [super allocWithZone:zone];
        }
    });
    return defaultManager;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

#pragma mark - Networking Request

//新手专享数据
- (void)requestForHomePageIsInvestWithUserId:(NSString *)userId
                                 accessToken:(NSString *)accessToken
                                successBlock:(void(^)(
                                                      BOOL result,
                                                      NSString *message,
                                                      NSNumber *isInvested
                                                      )
                                              )successBlock
                                failureBlock:(failureBlock)failureBlock {
    
    NSString *user_id;
    NSString *access_token;
    
    if(!userId) {
        user_id = @"";
    }else {
        user_id = userId;
    }
    
    if(!accessToken) {
        access_token = @"";
    }else {
        access_token = accessToken;
    }
    
    NSString *pathName = [NSString stringWithFormat:@"apk/index/isInvested?userId=%@&access_token=%@",user_id,access_token];
    NSString *requestUrl = hostName(pathName);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *err;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
        BOOL result = [[dict objectForKey:@"result"] boolValue];
        
        if(result) {
            
            NSNumber *isNewUser = [dict[@"isNewUser"] isEqual:[NSNull null]]?@0:dict[@"isNewUser"];
            
            successBlock(result,nil,isNewUser);
        }else {
            
            NSString *message = dict[@"message"];
            successBlock(result,message,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
    }];
}

//首页基本数据
- (void)requestForHomePageBasicDataWithType:(NSString *)type
                                     userId:(NSString *)userId
                               successBlock:(void (^)(
                                                      BOOL result,
                                                      NSString *msg,
                                                      NSString *platformInvestTotalAmount,
                                                      NSNumber *platformTotalnvestor,
                                                      NSString *totalAmount,
                                                      NSString *hasAmount
                                                      )
                                             )successBlock
                               failureBlock:(failureBlock)failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *requestUrl;
        
        if(!userId) {
            NSString *pathName = [NSString stringWithFormat:@"apk/index/baseData?type=%@",type];
            requestUrl = hostName(pathName);
        }else {
            NSString *pathName = [NSString stringWithFormat:@"apk/index/baseData?type=%@&userId=%@",type,userId];
            requestUrl = hostName(pathName);
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = ((NSNumber *)[dict objectForKey:@"result"]).boolValue;
            
            if (result) {
                
                NSString *platformInvestTotalAmount = [dict[@"platformInvestTotalAmount"] isEqual:[NSNull null]]?@"0":dict[@"platformInvestTotalAmount"];
                
                NSString *totalAmount = [dict[@"totalAmount"] isEqual:[NSNull null]]?@"0":dict[@"totalAmount"];
                
                NSNumber *platformTotalnvestor = [dict[@"platformTotalnvestor"] isEqual:[NSNull null]]?@0:dict[@"platformTotalnvestor"];
                NSString *hasAmount = [dict[@"platformTotalnvestor"] isEqual:[NSNull null]]?@0:dict[@"hasAmount"];
                
                successBlock(result,nil,platformInvestTotalAmount,platformTotalnvestor,totalAmount,hasAmount);
            }else{
                
                NSString *msg = dict[@"message"];
                //错误信息回传
                successBlock(result,msg,nil,nil,nil,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接不可用 ,请检查您的网络");
    }
}

//首页产品
- (void)requestForHomePageProductWithMonth:(NSString *)month
                                clientType:(NSString *)clientType
                              successBlock:(void (^)(
                                                     BOOL result,
                                                     NSString *message,
                                                     NSArray<GZProductListModel *> *productList
                                                     ))successBlock
                              failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *requestUrl;
        
        if([month isEqualToString:@"0"]) {
            
            NSString *pathName = [NSString stringWithFormat:@"apk/index/recommendProduct?month=%@&clientType=%@",@"",clientType];
            requestUrl = hostName(pathName);
        }else {
            NSString *pathName  = [NSString stringWithFormat:@"apk/index/recommendProduct?month=%@&clientType=%@",month,clientType];
            requestUrl = hostName(pathName);
        }
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"%@",dict);
            
            BOOL result = ((NSNumber *)[dict objectForKey:@"result"]).boolValue;
            
            if (result) {
                
                NSArray *productList = [dict[@"productList"] isEqual:[NSNull null]]?[NSArray array]:[GZProductListModel mj_objectArrayWithKeyValuesArray:dict[@"productList"]];
                
                successBlock(result,nil,productList);
            }else{
                
                NSString *msg = dict[@"message"];
                //错误信息回传
                successBlock(result,msg,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接不可用 ,请检查您的网络");
    }
}

//首页用户可用余额
- (void)requestForHomePageUserAvailableAmountWithUserId:(NSString *)userId
                                            accessToken:(NSString *)accessToken
                                           successBlock:(void (^)(
                                                                  BOOL result,
                                                                  NSString *message,
                                                                  NSString *availableAmount
                                                                  )
                                                         )successBlock
                                           failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getUserAvailableAmount?userId=%@&access_token=%@",userId,accessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                NSString *availableAmount = [dict[@"availableAmount"] isEqual:[NSNull null]]?@"0":dict[@"availableAmount"];
                
                successBlock(result,nil,availableAmount);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
        
    }else {
        ShowMessage(@"网络连接不可用 ,请检查您的网络");
    }
}

//首页产品优惠券
- (void)requestForHomePageCouponListWithUserId:(NSString *)userId
                                   accessToken:(NSString *)accessToken
                                       assetId:(NSString *)assetId
                                  successBlock:(void (^)(
                                                         BOOL result,
                                                         NSString *message,
                                                         NSArray<LJQCouponsModel *> *couponsList
                                                         )
                                                )successBlock
                                  failureBlock:(failureBlock)failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getAllCouponList?userId=%@&assetId=%@&access_token=%@",userId,assetId,accessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                NSArray *rebateCouponList = [dict[@"RebateCouponList"] isEqual:[NSNull null]]?[NSArray array]:[LJQCouponsModel mj_objectArrayWithKeyValuesArray:dict[@"RebateCouponList"]];
                
                successBlock(result,nil,rebateCouponList);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接不可用 ,请检查您的网络");
    }
}

//首页产品的购买列表
- (void)requestForHomePageBuyListWithAssetID:(NSString *)assetId
                                      pageNo:(int)pageNo
                                    pageSize:(int)pageSize
                                successBlock:(void (^)(
                                                       BOOL result,
                                                       NSString *message,
                                                       NSString *periods,
                                                       NSArray<GZBuyListModel *> *buyList,
                                                       NSString *totalSize
                                                       )
                                              )successBlock
                                failureBlock:(failureBlock)failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getBuyList?assetId=%@&pageNo=%d&pageSize=%d",assetId,pageNo,pageSize];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                NSString *periods = [dict[@"periods"] isEqual:[NSNull null]]?@"0":dict[@"periods"];
                NSArray *buyList = [dict[@"buyList"] isEqual:[NSNull null]]?[NSArray array]:[GZBuyListModel mj_objectArrayWithKeyValuesArray: dict[@"buyList"]];
                NSString *totalSize = [dict[@"totalSize"] isEqual:[NSNull null]]?@"0":dict[@"totalSize"];
                
                successBlock(result,nil,periods,buyList,totalSize);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //NSLog(@"首页产品的购买列表,请求失败");
            failureBlock(error);
            
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//首页购买产品的债权列表
- (void)requestForHomePageLoanListWithAssetID:(NSString *)assetId
                                 successBlock:(void (^)(
                                                        BOOL result,
                                                        NSString *message,
                                                        NSString *sourceOfAssets,
                                                        NSString *periods,
                                                        NSString *guarantStyle,
                                                        NSString *totalAmount,
                                                        NSString *bidNumber,
                                                        NSString *totalBidpercent,
                                                        NSArray<GZLoanListModel *> *loanList,
                                                        NSNumber* userHasLoan
                                                        )
                                               )successBlock
                                 failureBlock:(failureBlock)failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getLoanList?assetId=%@&userId=%@",assetId,USER_ID];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            NSLog(@"%@",dict);
            
            if (result) {
                
                NSString *sourceOfAssets = [dict[@"sourceOfAssets"] isEqual:[NSNull null]]?@"":dict[@"sourceOfAssets"];
                NSString *periods = [dict[@"periods"] isEqual:[NSNull null]]?@"0":dict[@"periods"];
                NSString *guarantStyle = [dict[@"guarantStyle"] isEqual:[NSNull null]]?@"":dict[@"guarantStyle"];
                NSString *totalAmount = [dict[@"totalAmount"] isEqual:[NSNull null]]?@"0":dict[@"totalAmount"];
                NSString *bidNumber = [dict[@"bidNumber"] isEqual:[NSNull null]]?@"0":dict[@"bidNumber"];
                NSString *totalBidpercent  = [dict[@"totalBidpercent"] isEqual:[NSNull null]]?@"0":dict[@"totalBidpercent"];
                NSNumber *userHasLoan  = [dict[@"userHasLoan"] isEqual:[NSNull null]]?@0:dict[@"userHasLoan"];
                
                NSArray<GZLoanListModel *> *loanList = [dict[@"loanList"] isEqual:[NSNull null]]?[NSArray array]:[GZLoanListModel mj_objectArrayWithKeyValuesArray:dict[@"loanList"]];
                
                successBlock(result,nil,sourceOfAssets,periods,guarantStyle,totalAmount,bidNumber,totalBidpercent,loanList,userHasLoan);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil,nil,nil,nil,nil,nil,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
            //NSLog(@"首页购买产品的债权列表,请求失败");
        }];
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}


///首页产品的债权基础信息
- (void)requestForHomePageLoansInfoOfAssetWithAssetID:(NSString *)assetId
                                               UserID:(NSString *)userId
                                         successBlock:(void(^)(
                                                               BOOL result,
                                                               NSString *message,
                                                               NSString *sourceOfAssets,
                                                               NSString *periods,
                                                               NSString *guarantStyle,
                                                               NSString *totalAmount,
                                                               NSString *bidNumber,
                                                               NSString *totalBidpercent,
                                                               NSNumber *userHasLoan,
                                                               NSString *assetId,
                                                               NSString *guarant
                                                               )
                                                       )successBlock
                                         failureBlock:(failureBlock)failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getLoansInfoOfAsset?assetId=%@&userId=%@",assetId,USER_ID];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            NSLog(@"%@",dict);
            
            if (result) {
                
                NSString *sourceOfAssets = [dict[@"sourceOfAssets"] isEqual:[NSNull null]]?@"":dict[@"sourceOfAssets"];
                NSString *periods = [dict[@"periods"] isEqual:[NSNull null]]?@"0":dict[@"periods"];
                NSString *guarantStyle = [dict[@"guarantStyle"] isEqual:[NSNull null]]?@"":dict[@"guarantStyle"];
                NSString *totalAmount = [dict[@"totalAmount"] isEqual:[NSNull null]]?@"0":dict[@"totalAmount"];
                NSString *bidNumber = [dict[@"bidNumber"] isEqual:[NSNull null]]?@"0":dict[@"bidNumber"];
                NSString *totalBidpercent  = [dict[@"totalBidpercent"] isEqual:[NSNull null]]?@"0":dict[@"totalBidpercent"];
                NSNumber *userHasLoan  = [dict[@"userHasLoan"] isEqual:[NSNull null]]?@0:dict[@"userHasLoan"];
                NSString *assetId = [dict[@"assetId"] isEqual:[NSNull null]]?@0:dict[@"assetId"];
                NSString *guarant = [dict[@"guarant"] isEqual:[NSNull null]]?@0:dict[@"guarant"];
                
                successBlock(result,nil,sourceOfAssets,periods,guarantStyle,totalAmount,bidNumber,totalBidpercent,userHasLoan,assetId,guarant);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil,nil,nil,nil,nil,nil,nil,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
            ShowMessage(@"网络连接失败,请检查您的网络设置");
            //NSLog(@"首页购买产品的债权列表,请求失败");
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//首页产品的购买列表
- (void)requestForHomePagegetLoanListWithAssetID:(NSString *)assetId
                                            Page:(NSString *)page
                                            Size:(NSString *)size
                                    successBlock:(void(^)(
                                                          BOOL result,
                                                          NSString *message,
                                                          NSArray<GZLoanListModel *> *loanList,
                                                          NSString *assetId
                                                          ))successBlock
                                    failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getLoanList?assetId=%@&page=%@&size=%@",assetId,page,size];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            NSLog(@"%@",dict);
            
            if (result) {
                
                NSArray<GZLoanListModel *> *loanList = [dict[@"loanList"] isEqual:[NSNull null]]?[NSArray array]:[GZLoanListModel mj_objectArrayWithKeyValuesArray:dict[@"loanList"]];
                NSString *assetId = [dict[@"assetId"] isEqual:[NSNull null]]?@0:dict[@"assetId"];
                
                successBlock(result,nil,loanList,assetId);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

///首页往期产品列表
- (void)requestForHomePageLoanListWithMonth:(NSString *)month
                                 clientType:(NSString *)clientType
                                       type:(NSString *)type
                                     pageNo:(NSString *)pageNo
                                   pageSize:(NSString *)pageSize
                               successBlock:(void (^)(
                                                      BOOL result,
                                                      NSString *message,
                                                      NSArray<GZProductListModel*> *productList,
                                                      NSString *totalSize
                                                      )
                                             )successBlock
                               failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getHistoryAssetList?month=%@&clientType=%@&type=%@&pageNo=%@&pageSize=%@",month,clientType,type,pageNo,pageSize];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                NSArray *productList = [dict[@"productList"] isEqual:[NSNull null]]?[NSArray array]:[GZProductListModel mj_objectArrayWithKeyValuesArray:dict[@"productList"]];
                NSString *totalSize = [dict[@"totalSize"] isEqual:[NSNull null]]?@"0":dict[@"totalSize"];
                
                successBlock(result,nil,productList,totalSize);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//首页往期产品详情
- (void)requestForHomePageAssetInfoWithAssetID:(NSString *)assetId
                                  successBlock:(void (^)(
                                                         BOOL result,
                                                         NSString *message,
                                                         GZAssetInfoModel *assetInfo
                                                         )
                                                )successBlock
                                  failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getAssetInfoByAssetId?assetId=%@",assetId];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                GZAssetInfoModel *assetInfo = [GZAssetInfoModel mj_objectWithKeyValues:dict[@"assetInfo"]];
                
                successBlock(result,nil,assetInfo);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//认购
- (void)requestForPurchasingAssetsWithUserId:(NSString *)userId
                                 accessToken:(NSString *)accessToken
                                     assetId:(NSString *)assetId
                                investAmount:(NSString *)investAmount
                                    couponId:(NSString *)couponId
                                      source:(NSString *)source
                                successBlock:(void (^)(
                                                       BOOL status,
                                                       NSArray *err,
                                                       NSNumber *interest,
                                                       NSString *bidResult,
                                                       NSNumber *investAmount,
                                                       NSString *storeId
                                                       )
                                              )sucessBlock
                                failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *requestUrl = [NSString stringWithFormat:@"%@api/v4/buy/assets/%@?access_token=%@",mainUrl,userId,accessToken];
        
        //判断优惠券是否为nil
        NSString *avaliableCouponId;
        
        if(!couponId){
            avaliableCouponId = @"";
        }else {
            avaliableCouponId = couponId;
        }
        
        NSDictionary *paras = @{@"userId":userId,
                                @"assetId":assetId,
                                @"investAmount":investAmount,
                                @"couponId":avaliableCouponId,
                                @"source":source,
                                @"fromsource":@"1"};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestUrl parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = ((NSNumber *)[dict objectForKey:@"success"]).boolValue;
            NSArray *error = dict[@"error"];
            
            if (result) {
                
                if(error.count == 0) {
                    
                    NSDictionary *data = dict[@"data"];
                    NSNumber *interest = [data[@"interest"] isEqual:[NSNull null]]?@0:data[@"interest"];
                    NSString *bidResult = [data[@"bidResult"] isEqual:[NSNull null]]?@"":data[@"bidResult"];
                    NSNumber *investAmount = [data[@"investAmount"] isEqual:[NSNull null]]?@0:data[@"investAmount"];
                    NSString *storeId = [data[@"storeId"] isEqual:[NSNull null]]?@"":data[@"storeId"];
                    
                    sucessBlock(result,nil,interest,bidResult,investAmount,storeId);
                }else {
                    
                    sucessBlock(result,error,nil,nil,nil,nil);
                }
                
            }else{
                //错误信息回传
                NSArray *err = dict[@"error"];
                sucessBlock(result,err,nil,nil,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error);
            //        NSString *errDesc = (NSString *)[error.userInfo objectForKey:@"NSLocalizedDescription"];
            //
            //        ShowMessage(errDesc);
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//首页购买成功页面
- (void)requestForHomePageLoanInfoWithAssetBuyId:(NSString *)assetBuyRecordId
                                     accessToken:(NSString *)accessToken
                                    successBlock:(void (^)(
                                                           BOOL result,
                                                           NSString *message,
                                                           NSNumber *paymentInterest,
                                                           NSNumber *loanNumber,
                                                           NSArray<GZDistributionLoanListModel *> *loanList,
                                                           NSString *repaymentMethod,
                                                           NSString *investAmount
                                                           )
                                                  )successBlock
                                    failureBlock:(failureBlock)failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/index/getLoanInfoByAssetBuyId?assetBuyRecordId=%@&access_token=%@",assetBuyRecordId,accessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = [[dict objectForKey:@"result"] boolValue];
            
            if (result) {
                
                NSNumber *paymentInterest = [dict[@"paymentInterest"] isEqual:[NSNull null]]?@0:dict[@"paymentInterest"];
                NSNumber *loanNumber = [dict[@"loanNumber"] isEqual:[NSNull null]]?@0:dict[@"loanNumber"];
                NSArray<GZDistributionLoanListModel *> *loanList = [dict[@"loanList"] isEqual:[NSNull null]]?[NSArray array]:[GZDistributionLoanListModel mj_objectArrayWithKeyValuesArray:dict[@"loanList"]];
                NSString *repaymentMethod = [dict[@"repaymentMethod"] isEqual:[NSNull null]]?@"":dict[@"repaymentMethod"];
                NSString *investAmount = [dict[@"investAmount"] isEqual:[NSNull null]]?@"0":dict[@"investAmount"];
                successBlock(result,nil,paymentInterest,loanNumber,loanList,repaymentMethod,investAmount);
            }else{
                //错误信息回传
                NSString *msg = dict[@"message"];
                
                successBlock(result,msg,nil,nil,nil,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }else {
        failureBlock(nil);
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}
//持有资产页面

- (void)requestForHomePageuserAccountWithUserId:(NSString *)userdID repaymethod:(NSString *)repaymethod orderType:(NSString *)ordertype months:(NSString *)months page:(NSString *)page size:(NSString *)size isSevenBack:(BOOL)isSevenBack access_token:(NSString *)access_token successBlock:(void (^)(NSArray *,NSString *str))sccessBlock failureBlock:(void (^)())failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        if (isSevenBack) {
            ordertype = @"nextSettleTime";
        }
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getHasRecordList?userId=%@&repayMethod=%@&orderType=%@&months=%@&page=%@&size=%@&access_token=%@",USER_ID,repaymethod,ordertype,months,page,size,AccessToken];
        NSString *requestUrl = hostName(pathName);
        
        NSLog(@"持有资产--%@",requestUrl);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSNumber *status = [dict objectForKey:@"status"];
            NSLog(@"%@",dict);
            
            if (status.integerValue == 0) { //登录成功
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMHoldingAssetsModel class] json:dict[@"data"][@"hasRecordList"]];
                NSString *str = [dict[@"data"][@"noSettleAmount"] isEqual:[NSNull null]]?@"":dict[@"data"][@"noSettleAmount"];
                
                if ([str isEqual:[NSNull null]]) {
                    str = @"0";
                }
                sccessBlock(array,str);
            }else if(status.integerValue == 1){ //未登录
                failureBlock();
                ShowMessage(@"用户未登录");
            }else { //接口异常
                failureBlock();
                ShowMessage(@"接口异常");
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock();
        }];
    }else {
        failureBlock();
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)requestForSettledAssetesWithUserId:(NSString *)userId repayMethod:(NSString *)repayMethod amountType:(NSString *)amountType months:(NSString *)months page:(NSString *)page size:(NSString *)size access_token:(NSString *)access_token successBlock:(void (^)(NSArray *, NSString *))sccessBlock failureBlock:(void (^)())failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getEndRecordList?userId=%@&repayMethod=%@&months=%@&page=%@&size=%@&amountType=%@&access_token=%@",USER_ID,repayMethod,months,page,size,amountType,AccessToken];
        NSString *requestUrl = hostName(pathName);
        
        NSLog(@"----------%@",requestUrl);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSNumber *status = [dict objectForKey:@"status"];
            NSLog(@"%@",dict);
            
            if (status.integerValue == 0) { //登录成功
                
                NSArray *array = [NSArray yy_modelArrayWithClass:[DMSettledAssetsModel class] json:dict[@"data"][@"endRecordList"]];
                
                
                NSString *str = [dict[@"data"][@"settleAmount"] isEqual:[NSNull null]]?@"":dict[@"data"][@"settleAmount"];
                
                
                sccessBlock(array,str);
                
            }else if(status.integerValue == 1){ //未登录
                
                
            }else { //接口异常
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //  NSLog(@"已结清资产页面请求失败");
            failureBlock(error);
            
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)requestForHolfDetailsUserId:(NSString *)userId
                           recordId:(NSString *)assetId
                       access_token:(NSString *)access_token
                       successBlock:(void(^)(NSArray *arr,
                                             NSString *totalInterest,
                                             NSString *noSettleInterest,
                                             NSString *settleInterest,
                                             NSString *noSettlePrincipal,
                                             NSString *settlePrincipal,
                                             NSString *repaymentMethod,
                                             NSString *periods,
                                             NSString *investAmount,
                                             NSString *rate,
                                             NSString *monthSettleAmount,
                                             NSString *settlePeriod,
                                             NSString *noSettleAmount,
                                             NSString *buyTime,
                                             NSString *interestTime,
                                             NSString *assetId,
                                             NSString *termUnit
                                             ))sccessBlock
                       failureBlock:(void(^)())failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getHasRecordDetail?userId=%@&assetId=%@&access_token=%@",USER_ID,assetId,AccessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSNumber *status = [dict objectForKey:@"status"];
            
            NSLog(@"%@",dict);
            
            if (status.integerValue == 0) { //登录成功
                
                NSArray *array = [dict[@"data"][@"repaymentList"] isEqual:[NSNull null]]?[NSArray array]:dict[@"data"][@"repaymentList"];
                NSString *totalInterest = [dict[@"data"][@"totalInterest"] isEqual:[NSNull null]]?@"0":dict[@"data"][@"totalInterest"];
                NSString *noSettleInterest = [dict[@"data"][@"noSettleInterest"] isEqual:[NSNull null]]?@"0":dict[@"data"][@"noSettleInterest"];
                NSString *settleInterest = [dict[@"data"][@"settleInterest"] isEqual:[NSNull null]]?@"0":dict[@"data"][@"settleInterest"];
                NSString *noSettlePrincipal = [dict[@"data"][@"noSettlePrincipal"] isEqual:[NSNull null]]?@"":dict[@"data"][@"noSettlePrincipal"];
                NSString *settlePrincipal = [dict[@"data"][@"settlePrincipal"] isEqual:[NSNull null]]?@"":dict[@"data"][@"settlePrincipal"];
                NSString *repaymentMethod = [dict[@"data"][@"repaymentMethod"] isEqual:[NSNull null]]?@"":dict[@"data"][@"repaymentMethod"];
                NSString *periods = [dict[@"data"][@"periods"] isEqual:[NSNull null]]?@"":dict[@"data"][@"periods"];
                NSString *investAmount = [dict[@"data"][@"investAmount"] isEqual:[NSNull null]]?@"":dict[@"data"][@"investAmount"];
                NSString *rate = [dict[@"data"][@"rate"] isEqual:[NSNull null]]?@"":dict[@"data"][@"rate"];
                NSString *monthSettleAmount = [dict[@"data"][@"monthSettleAmount"] isEqual:[NSNull null]]?@"":dict[@"data"][@"monthSettleAmount"];
                NSString *settlePeriod = [dict[@"data"][@"settlePeriod"] isEqual:[NSNull null]]?@"":dict[@"data"][@"settlePeriod"];
                NSString *noSettleAmount = [dict[@"data"][@"noSettleAmount"] isEqual:[NSNull null]]?@"":dict[@"data"][@"noSettleAmount"];
                NSString *buyTime = [dict[@"data"][@"buyTime"] isEqual:[NSNull null]]?@"":dict[@"data"][@"buyTime"];
                NSString *interestTime = [dict[@"data"][@"interestTime"] isEqual:[NSNull null]]?@"":dict[@"data"][@"interestTime"];
                NSString *assetId = [dict[@"data"][@"assetId"] isEqual:[NSNull null]]?@"":dict[@"data"][@"assetId"];
                
                NSString *unit = [NSString stringWithFormat:@"%@",dict[@"data"][@"termUnit"]];
                                  
                NSString *termUnit = [unit isEqual:[NSNull null]]?@"": unit;
                
                sccessBlock(array,totalInterest,noSettleInterest,settleInterest,noSettlePrincipal,settlePrincipal,repaymentMethod,periods,investAmount,rate,monthSettleAmount,settlePeriod,noSettleAmount,buyTime,interestTime,assetId,termUnit);
                
            }else if(status.integerValue == 1){ //未登录
                
            }else { //接口异常
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //NSLog(@"资产详情页面请求失败");
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}


////////获取认购的借贷咨询与管理协议列表：
- (void)requestForHolfDetailsUserId:(NSString *)userId
                       WithrecordId:(NSString *)recordId
                       successBlock:(void(^)(NSArray *dataArr))sccessBlock
                       failureBlock:(void(^)())failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"api/v2/useramountinfo/getRecordProtocolyList/%@?recordId=%@&access_token=%@",USER_ID,recordId,AccessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];

                sccessBlock(arr);

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"已结清页面已结金额请求失败");
        }];
        
    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }

}


// 已结清页面已结金额
- (void)requestForSettledDetailsUserId:(NSString *)userId
                           repayMethod:(NSString *)repayMethod
                            amountType:(NSString *)amountType
                                months:(NSString *)months
                          access_token:(NSString *)access_token
                          successBlock:(void(^)(NSNumber *settleAmount))sccessBlock
                          failureBlock:(void(^)())failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getEndRecordPageAmount?userId=%@&access_token=%@",USER_ID,AccessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSNumber *status = [dict objectForKey:@"status"];
            
            if (status.integerValue == 0) { //登录成功
                
                NSNumber *settleAmount = [dict[@"data"][@"settleAmount"] isEqual:[NSNull null]]?@0:dict[@"data"][@"settleAmount"];
                
                sccessBlock(settleAmount);
            }else if(status.integerValue == 1){ //未登录
                
                
            }else { //接口异常
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"已结清页面已结金额请求失败");
        }];
        
    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

//自动投标签约状态
- (void)requestStatusOfAutoSignWithUserId:(NSString *)userId
                           successBlock:(void(^)(
                                                 NSString *status,
                                                 NSString *msg)
                                         )successBlock
                           failureBlock:(void(^)(NSError *err, NSString *msg))failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"api/sumpay/bid/isAutoSign?userId=%@&access_token=%@",USER_ID,AccessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = ((NSNumber *)[dict objectForKey:@"success"]).boolValue;
          
            if (result) {
                
                //1.托管开关未打开 2.已签约 3.未签约
                NSString *status = [[dict objectForKey:@"data"] objectForKey:@"status"];
                NSString *msg = [[dict objectForKey:@"data"] objectForKey:@"msg"];
                
                successBlock(status, msg);
                
            }else {
                
                NSString *msg = [[(NSArray *)[dict objectForKey:@"error"] firstObject] objectForKey:@"message"];
                
                failureBlock(nil, msg);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error,nil);
            
        }];
        
    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)requestForFormInfoWithUserId:(NSString *)userId
                        successBlock:(void(^)(
                                              NSMutableDictionary *infoDict
                                              )
                                      )successBlock
                        failureBlock:(void(^)(NSError *err, NSString *msg))failureBlock {
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *requestUrl = [NSString stringWithFormat:@"%@api/sumpay/bid/form?access_token=%@",mainUrl,AccessToken];
        NSDictionary *paras = @{@"userId":USER_ID,@"fromApp":@"1",@"appType":@"0",@"source":@"APP",@"loginFlag":AccessToken,@"fromsource":@"1"};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestUrl parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            BOOL result = ((NSNumber *)[dict objectForKey:@"result"]).boolValue;

            if (result) {
                
                NSMutableDictionary *infoDict = [dict mutableCopy];
                
                [infoDict removeObjectForKey:@"result"];

                successBlock(infoDict);
                
            }else {
                
                NSString *msg = [dict objectForKey:@"message"];
                
                failureBlock(nil,msg);
            }
            

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failureBlock(error,nil);
        }];
        
    }else {
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
    
}

- (void)requestForSettledDetailsUserId:(NSString *)userId
                              recordId:(NSString *)recordId
                          access_token:(NSString *)access_token
                          successBlock:(void(^)(NSArray *arr,NSString *totalInterest,NSString *noSettleInterest,NSString *settleInterest,
                                                NSString *buyTime,
                                                NSString *interestTime,
                                                NSString *amountPrincipal))sccessBlock
                          failureBlock:(void(^)())failureBlock{
    
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"apk/userAccount/getEndRecordDetail?userId=%@&assetId=%@&access_token=%@",USER_ID,recordId,AccessToken];
        NSString *requestUrl = hostName(pathName);
        
        NSLog(@"%@",requestUrl);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            NSNumber *status = [dict objectForKey:@"status"];
            
            if (status.integerValue == 0) { //登录成功
                
                NSArray *array = dict[@"data"][@"repaymentList"];
                
                NSString *totalInterest = [dict[@"data"][@"totalInterest"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"totalInterest"];
                NSString *noSettleInterest = [dict[@"data"][@"noSettleInterest"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"noSettleInterest"];
                NSString *settleInterest = [dict[@"data"][@"settleInterest"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"settleInterest"];
                NSString *buyTime = [dict[@"data"][@"buyTime"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"buyTime"];
                NSString *interestTime = [dict[@"data"][@"interestTime"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"interestTime"];
                NSString *amountPrincipal = [dict[@"data"][@"amountPrincipal"] isEqual:[NSNull null]]? @"0":dict[@"data"][@"amountPrincipal"];
                
                sccessBlock(array,totalInterest,noSettleInterest,settleInterest,buyTime,interestTime,amountPrincipal);
                
                NSLog(@"%@",dict);
                
            }else if(status.integerValue == 1){ //未登录
                
                
            }else { //接口异常
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"已结清页面请求失败");
        }];
        
    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}


- (void)requestForInformationWithContractId:(NSString *)contractId
                               successBlock:(void(^)(NSString *url))sccessBlock
                               failureBlock:(void(^)())failureBlock{
    if(JudgeStatusOfNetwork()) {
        
        NSString *pathName = [NSString stringWithFormat:@"api/v2/useramountinfo/getRecordProtocoly?contractId=%@&access_token=%@",contractId,AccessToken];
        NSString *requestUrl = hostName(pathName);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:requestUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *err;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:&err];
            
            sccessBlock(arr);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"已结清页面已结金额请求失败");
        }];
        
    }else {
        
        ShowMessage(@"网络连接失败,请检查您的网络设置");
    }
}

@end
