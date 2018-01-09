//
//  DMHomeUrlManager.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeUrlManager.h"

@implementation DMHomeUrlManager

+ (instancetype)manager{
    static DMHomeUrlManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DMHomeUrlManager alloc] init];
    });
    return manager;
}


- (NSString *)getHomeBannerUrl{
    return hostName(@"apk/article/HOMEPAGE/list?name=banner_app");
}

- (NSString *)getNoticeUrl{
    NSString *path = [@"apk/article/PUBLICATION/list?name=最新公告&size=10" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return hostName(path);
}

- (NSString *)getNewHandUrl{
    return hostName(@"apk/newbie/getNewBieVIPAssets?status=RELEASED&page=1&size=1");
}

- (NSString *)getRecommendUrlWithPage:(NSInteger)page Size:(NSInteger)size{
    NSString *path = [NSString stringWithFormat:@"apk/index/getAssetList?status=RELEASED&clientType=2&featuredProduct=1&page=%@&size=%@",@(page),@(size)];
    return hostName(path);
}

- (NSString *)DMGetProductInfoUlrWithAssetID:(NSString *)assetID {
    NSString *path = [NSString stringWithFormat:@"apk/index/getAssetInfoByAssetId?assetId=%@",assetID];
    return hostName(path);
}

- (NSString *)DMGetProductToBuyListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size {
    NSString *path = [NSString stringWithFormat:@"apk/index/getBuyList?assetId=%@&pageNo=%@&pageSize=%@",assetID,@(page),@(size)];
    return hostName(path);
}

- (NSString *)DMGetLoanListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size {
    NSString *path = [NSString stringWithFormat:@"apk/index/getLoanList?assetId=%@&page=%@&size=%@",assetID,@(page),@(size)];
    return hostName(path);
}


- (NSString *)getIsNewUserUrl{
    NSString *path = [NSString stringWithFormat:@"apk/index/isInvested?userId=%@&access_token=%@",USER_ID,AccessToken];
    return hostName(path);
}

@end
