//
//  DMHomeRequestManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeRequestManager.h"
#import "DMHomeUrlManager.h"
#import "DMHomeBannerModel.h"
#import "DMHomeListModel.h"
#import "GZAssetInfoModel.h"
#import "GZBuyListModel.h"
#import "GZLoanListModel.h"
@interface DMHomeRequestManager ()

@property (nonatomic, strong)AFHTTPSessionManager *requestManager;

@end

@implementation DMHomeRequestManager

+ (instancetype)manager {
    static DMHomeRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMHomeRequestManager alloc] init];
        manager.requestManager = [AFHTTPSessionManager manager];
        manager.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",nil];
    });
    return manager;
}


- (void)getHomeBannerSuccess:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMHomeUrlManager manager] getHomeBannerUrl];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *bannerArray = [NSArray yy_modelArrayWithClass:[DMHomeBannerModel class] json:responseObject[@"articleList"]];
            success(bannerArray);
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

- (void)getHomeNoticeSuccess:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMHomeUrlManager manager] getNoticeUrl];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *bannerArray = [NSArray yy_modelArrayWithClass:[DMHomeBannerModel class] json:responseObject[@"articleList"]];
            success(bannerArray);
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


- (void)getNewHandSuccess:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMHomeUrlManager manager] getNewHandUrl];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *newArray = [NSArray yy_modelArrayWithClass:[DMHomeListModel class] json:responseObject[@"assetList"]];
            success(newArray);
        }else {
//            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
//            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        faild();
    }];
}

//是否新手
- (void)getIsNewUserSuccess:(void (^)(BOOL))success faild:(void (^)())faild{
    NSString *url = [[DMHomeUrlManager manager] getIsNewUserUrl];
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            BOOL isnewuser = [responseObject[@"isNewUser"] boolValue];
            success(isnewuser);
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

- (void)getRecommendPage:(NSInteger)page Size:(NSInteger)size Success:(void (^)(NSArray *))success faild:(void (^)())faild{
    NSString *url = [[DMHomeUrlManager manager] getRecommendUrlWithPage:page Size:size];
    NSLog(@"%@",url);
    [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
        if (result) {
            NSArray *newArray = [NSArray yy_modelArrayWithClass:[DMHomeListModel class] json:responseObject[@"productList"]];
            success(newArray);
        }else {
//            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
//            ShowMessage(message);
            faild();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        faild();
    }];
}

- (void)DMGetProductInfoMessageWithAssetID:(NSString *)assetID showView:(UIView *)showView success:(void (^)(GZAssetInfoModel *))success faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {
        
        NSString *url = [[DMHomeUrlManager manager] DMGetProductInfoUlrWithAssetID:assetID];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
            if (result) {
                GZAssetInfoModel *model = [GZAssetInfoModel yy_modelWithJSON:responseObject[@"assetInfo"]];
                success(model);
            }else {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                faild(message);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild(dataInfoMessage);
        }];
    }else {
        faild(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)DMGetProductBuyListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void (^)(NSArray<GZBuyListModel *> *))success faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {
     
        NSString *url = [[DMHomeUrlManager manager] DMGetProductToBuyListWithAssetID:assetID page:page size:size];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
            if (result) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[GZBuyListModel class] json:responseObject[@"buyList"]];
                success(array);
            }else {
               NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                faild(message);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild(dataInfoMessage);
        }];
    }else {
        faild(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)DMGetLoanListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void (^)(NSArray<GZLoanListModel *> *))success faild:(void (^)(NSString *))faild {
    if (JudgeStatusOfNetwork()) {
        NSString *url = [[DMHomeUrlManager manager] DMGetLoanListWithAssetID:assetID page:page size:size];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.requestManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            BOOL result = [[NSString stringWithFormat:@"%@",responseObject[@"result"]] boolValue];
            if (result) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[GZLoanListModel class] json:responseObject[@"loanList"]];
                success(array);
            }else {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
                faild(message);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            faild(dataInfoMessage);
        }];
    }else {
        faild(@"网络连接失败,请检查您的网络设置");
    }
}

- (void)hideHUD:(MBProgressHUD *)progress {
    __block MBProgressHUD *progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hide:YES];
        progressC = nil;
    });
}

@end
