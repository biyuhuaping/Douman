//
//  DMHomeUrlManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMHomeUrlManager : NSObject

+ (instancetype)manager;



/**
 首页banner
 */
- (NSString *)getHomeBannerUrl;


/**
 首页公告
 */
- (NSString *)getNoticeUrl;


/**
 新手专享
 */
- (NSString *)getNewHandUrl;



/**
 首页推荐
 */
- (NSString *)getRecommendUrlWithPage:(NSInteger)page Size:(NSInteger)size;

/**
 产品介绍

 @param assetID 产品id
 */
- (NSString *)DMGetProductInfoUlrWithAssetID:(NSString *)assetID;


/**
 产品购买列表

 @param assetID 产品ID
 @param page 页码
 @param size 条数
 */
- (NSString *)DMGetProductToBuyListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size;


/**
 本期债权

 @param assetID 产品ID
 */
- (NSString *)DMGetLoanListWithAssetID:(NSString *)assetID page:(NSInteger)page size:(NSInteger)size;


/**
 是否新手
 */
- (NSString *)getIsNewUserUrl;

@end
