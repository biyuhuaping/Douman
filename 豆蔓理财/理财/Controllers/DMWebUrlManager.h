//
//  DMWebUrlManager.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/1/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMWebUrlManager : NSObject

+ (instancetype)manager;


/**
 充值url
 */
- (NSString *)getChargeUrl;


/**
 关于我们
 */
- (NSString *)getAboutUs;


/**
 帮助中心
 */
- (NSString *)getHelpCenter;


/**
 债权模式
 */
- (NSString *)creditModel;

/**
 新手专享
 */
- (NSString *)newHang;

/**
 公告内容
 */
- (NSString *)platformDetail;


/**
 安全保障
 */
- (NSString *)safeguard;

/**
相关协议及风险提示
 */
//- (NSString *)productProtocol;


/**
 注册协议
 */
- (NSString *)registerProtocol;


////获取借贷咨询与管理协议pdf：
//- (NSString *)getPdf:(NSString *)contractId;

//////////////
- (NSString *)protocolWithassetId:(NSString *)assetId;


- (NSString *)getActivityUrl;



//徽商页面跳转地址

- (NSString *)getsumapayUrl;


//徽商设置交易密码
- (NSString *)getReplaceWebUrl;

//自动投标协议
- (NSString *)getAutoSignAuthProtocolUrl;


// 自动投标签约
- (NSString *)getAutoMakeABid;

// 小豆机器人协议
- (NSString *)getRobotProtocolUrl;


// 银行存管

- (NSString *)getHuiShangPingTai;

@end
