//
//  DMHomeRequestManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMHomeBannerModel;
@class GZAssetInfoModel;
@class GZBuyListModel;
@class GZLoanListModel;
@interface DMHomeRequestManager : NSObject

+ (instancetype)manager;

//banner
- (void)getHomeBannerSuccess:(void(^)(NSArray *bannerArray))success
                       faild:(void(^)())faild;

//公告
- (void)getHomeNoticeSuccess:(void(^)(NSArray *noticeArray))success
                       faild:(void(^)())faild;

//新手专享

- (void)getNewHandSuccess:(void(^)(NSArray *newArray))success
                    faild:(void(^)())faild;

//首页推荐
- (void)getRecommendPage:(NSInteger)page
                    Size:(NSInteger)size
                 Success:(void(^)(NSArray *recommendArray))success
                   faild:(void(^)())faild;

//是否新手
- (void)getIsNewUserSuccess:(void(^)(BOOL isNewUser))success
                      faild:(void(^)())faild;
/**
 产品介绍

 @param assetID 产品ID
 */
- (void)DMGetProductInfoMessageWithAssetID:(NSString *)assetID showView:(UIView *)showView success:(void(^)(GZAssetInfoModel *infoModel))success faild:(void(^)(NSString *message))faild;


/**
 产品购买列表

 @param assetID 产品ID
 @param page 页码
 @param size 条数
 @param showView 加载父视图
 */
- (void)DMGetProductBuyListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void(^)(NSArray<GZBuyListModel *> *buyListArr))success faild:(void(^)(NSString *message))faild;


/**
 本期债权

 @param assetID 产品id
 */
- (void)DMGetLoanListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size showView:(UIView *)showView success:(void(^)(NSArray<GZLoanListModel *> *loanListArr))success faild:(void(^)(NSString *message))faild;
@end
